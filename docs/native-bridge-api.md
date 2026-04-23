# EvairSIM Native Bridge API

> **Audience:** H5 developers. This doc explains what native features the APP
> shell exposes to H5 via `window.evair`, how to call them, and how to
> detect whether the site is running inside the APP vs. a plain browser.

---

## Overview

Starting 2026-04, the EvairSIM APP is a thin Flutter shell that hosts the
H5 site inside a full-screen WebView. Everything the user sees is shipped
from H5. To preserve a native-app feel, the shell injects a small JavaScript
object, `window.evair`, that H5 can call to trigger native features.

```
┌─────────────────────────────────────────┐
│  Flutter shell (iOS / Android)          │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │   InAppWebView                    │  │
│  │                                   │  │
│  │   H5 site (evair.zhhwxt.cn)       │  │
│  │      │                            │  │
│  │      ▼  window.evair.share(...)   │  │
│  │   ─────────────────────────────── │  │
│  │   NativeBridge (Dart)             │  │
│  │      │                            │  │
│  │      ▼  iOS UIActivityViewController │
│  │         Android Sharesheet Intent │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

---

## Detecting the shell

Every method returns a `Promise`. When H5 runs in a regular browser
(`window.evair` is absent) the site should fall back to a non-native
equivalent (`navigator.share`, `window.open`, `document.execCommand('copy')`,
etc.).

```js
const inApp = typeof window.evair !== 'undefined' && window.evair.isNative;

if (inApp) {
  await window.evair.share({ title: 'Evair', url: location.href });
} else if (navigator.share) {
  await navigator.share({ title: 'Evair', url: location.href });
} else {
  window.open(location.href, '_blank');
}
```

A tiny helper in H5 is recommended:

```ts
// services/nativeBridge.ts
type Evair = {
  isNative: true;
  share(opts: { title?: string; text?: string; url?: string }): Promise<{ ok: boolean }>;
  openExternal(url: string): Promise<{ ok: boolean }>;
  copyToClipboard(text: string): Promise<{ ok: boolean }>;
  getAppInfo(): Promise<{ platform: 'ios' | 'android' | 'web'; version: string; buildNumber: string }>;
  haptic(type?: 'light' | 'medium' | 'heavy' | 'selection'): Promise<{ ok: boolean }>;
};

export const nativeBridge = (window as any).evair as Evair | undefined;
export const isNative = !!nativeBridge?.isNative;
```

---

## API reference

### `share(options)`

Trigger the native share sheet (iOS `UIActivityViewController`,
Android `ACTION_SEND`).

| Param       | Type     | Notes                                         |
|-------------|----------|-----------------------------------------------|
| `title`     | `string` | Subject line (email clients only).            |
| `text`      | `string` | Main body text.                               |
| `url`       | `string` | Appended to body with a newline.              |

Either `text` or `url` is required.

**Example**

```js
await window.evair.share({
  title: 'Check out this eSIM plan',
  url: 'https://evair.zhhwxt.cn/shop/esim?plan=AS-12',
});
```

### `openExternal(url)`

Opens the URL in the **system browser**, not the WebView. Use for:

- Bank / PSP redirects H5 doesn't own.
- App-store links.
- External marketing pages.

```js
await window.evair.openExternal('https://apps.apple.com/id1234567890');
```

### `copyToClipboard(text)`

Writes to the native clipboard. Works where `document.execCommand('copy')`
is flaky on mobile WebViews.

```js
await window.evair.copyToClipboard('evair-order-12345');
```

### `getAppInfo()`

Returns shell metadata. Useful for analytics segmentation.

```js
const { platform, version, buildNumber } = await window.evair.getAppInfo();
// { platform: 'ios', version: '1.0.0', buildNumber: '1' }
```

### `haptic(type?)`

Triggers native haptic feedback. `type` is one of:

- `'light'` (default) — subtle tap
- `'medium'` — noticeable bump
- `'heavy'` — firm thud
- `'selection'` — picker-style tick

```js
await window.evair.haptic('selection');
```

---

## Planned (not yet implemented)

| Method                     | Status  | Notes                                                        |
|----------------------------|---------|--------------------------------------------------------------|
| `installEsim(lpa)`         | Phase 2 | iOS `CTCellularPlanProvisioning`, Android `EuiccManager`.    |
| `scanQr()`                 | Phase 2 | `mobile_scanner` plugin.                                     |
| `registerPush(token)`      | Phase 2 | FCM (Android) / APNs (iOS).                                  |
| `biometricAuth()`          | Phase 2 | `local_auth` — return an opaque token to H5.                 |
| `secureStorage.get/set`    | Phase 2 | Encrypted keychain / keystore for refresh tokens.            |

H5 should **not** call these yet — guard with `if ('installEsim' in window.evair)`.

---

## Error handling

Every handler returns `{ ok: true }` on success, or `{ ok: false, error, reason }`
on failure. Handlers never throw — the Promise always resolves. Timeouts are
rare (most calls are synchronous under the hood) but you may still want to
race against a 5-second timer if you show a spinner.

---

## Local development

Set the URL the shell loads via a Dart define:

```bash
# iOS simulator / Flutter web (Chrome tab in start-all-previews.sh)
flutter run --dart-define=H5_URL=http://localhost:3000

# Android emulator (127.0.0.1 points at the emulator itself)
flutter run --dart-define=H5_URL=http://10.0.2.2:3000

# Physical device on the same Wi-Fi as your laptop
flutter run --dart-define=H5_URL=http://<laptop-ip>:3000
```

`start-all-previews.sh` already passes `H5_URL=http://localhost:3000` when
it launches the Chrome preview tab.

---

## Checklist for H5 devs

- [ ] Feature-detect `window.evair.isNative` before calling bridge methods.
- [ ] Provide a browser fallback for every native call.
- [ ] Avoid UIs that reserve space for a URL bar — WebView is full-screen.
- [ ] Test login flow with cookies disabled once — WebView stores its own
      jar, but 3rd-party cookie restrictions apply.
- [ ] For PSP redirects (Stripe, WeChatPay, AliPay), route them via
      `openExternal` so the user returns to the APP after payment.
