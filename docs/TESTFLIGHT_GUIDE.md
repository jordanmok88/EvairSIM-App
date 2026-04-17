# EvairSIM iOS TestFlight Submission Guide

This guide walks you through the very first TestFlight upload. Subsequent
uploads are a single button press once your signing is set up.

> **What you need first**
> - A paid **Apple Developer Program** membership on
>   `jordan_mok@icloud.com` (or a team you belong to). USD 99 / year.
> - **Xcode** installed and opened at least once (downloading in
>   parallel — confirm with `xcodebuild -version` returning a version
>   rather than a "command line tools" error).
> - **Mac** with at least 20 GB free disk.
> - Two-factor auth enabled on your Apple ID.

---

## 1. Set the bundle identifier

The Flutter template ships with
`com.example.evairSim`. Apple rejects anything starting with
`com.example`. Change it **once**:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the `Runner` project (blue icon) → `Runner` target →
   **Signing & Capabilities**.
3. Under **Bundle Identifier**, enter a reverse-DNS id you own. We
   recommend:
   ```
   com.evairdigital.evairsim
   ```
4. Under **Team**, choose your Apple Developer team. If it is not
   listed, sign in via `Xcode → Settings → Accounts`.
5. Check **Automatically manage signing**. Xcode will create a
   signing cert + provisioning profile for you.

## 2. Bump build version

Edit `pubspec.yaml` → `version: 1.0.0+1` whenever you upload. The
format is `<semver>+<build number>`. **Build number must increase
every time.** Example:

```yaml
version: 1.0.0+2   # second TestFlight build
```

## 3. Register the app in App Store Connect

1. Go to <https://appstoreconnect.apple.com> → **My Apps** → `+` →
   **New App**.
2. Platform: **iOS**. Name: **EvairSIM** (must match
   `CFBundleDisplayName`). Primary language: **English (U.S.)**.
3. Bundle ID: select the `com.evairdigital.evairsim` you registered
   in Xcode (refresh the dropdown if empty — Xcode pushes the ID
   when you first build with signing).
4. SKU: any unique string (e.g. `evairsim-ios-1`).

## 4. Build the archive

```bash
cd ~/Development/EvairSIM-App

# Regenerate native icons and splash after any pubspec changes.
dart run flutter_launcher_icons
dart run flutter_native_splash:create

# Produce an optimised release build.
flutter build ipa --release

# The archive lands in build/ios/archive/Runner.xcarchive
```

If `flutter build ipa` fails with "No valid code signing certificates
were found", open the `.xcarchive` in Xcode, re-select the team,
then retry.

## 5. Upload to App Store Connect

Option A — Xcode (recommended the first time):

1. Open `build/ios/archive/Runner.xcarchive` in Xcode (it will open
   the **Organizer** window).
2. Click **Distribute App** → **App Store Connect** → **Upload**.
3. Choose the automatically-managed signing. Xcode uploads the IPA
   (~60 MB) to App Store Connect.

Option B — Transporter.app (faster, once comfortable):

1. Install **Transporter** from the Mac App Store.
2. Run `flutter build ipa --release --export-method=app-store`.
3. Drag `build/ios/ipa/Runner.ipa` into Transporter → Deliver.

## 6. Wait for processing + invite testers

1. App Store Connect → **TestFlight** tab → wait for the upload to
   finish "Processing" (10–20 min the first time).
2. Under **iOS Builds**, fill in the missing Export Compliance
   questions. EvairSIM does **not** use non-exempt cryptography, so
   answer:
   - "Does your app use encryption?" → **Yes**
   - "Does your app qualify for any exemptions?" → **Yes**
     (HTTPS/TLS only).
3. Add **Internal Testers**: App Store Connect → **Users and
   Access** → add your Apple ID as `App Manager` → you receive an
   invite email.
4. Open **TestFlight** on your iPhone (install from the App Store
   if needed) → accept the invite → install.

## 7. Smoke-test checklist for the first TestFlight build

- [ ] App launches past the splash screen.
- [ ] Welcome → Login works with `flutter-test@evairdigital.com`.
- [ ] Shop tab loads countries within 5 s on LTE.
- [ ] Buy a $2.20 USA package end-to-end. Expect the confirmation
      screen to show a QR and the order number.
- [ ] My SIMs tab reloads with the new purchase (may require
      pulling-to-refresh once the backend provisions the eSIM).
- [ ] Profile → Log out returns to the welcome screen.

## 8. Future releases

1. Bump `version: 1.0.0+N` in `pubspec.yaml`.
2. Run `flutter build ipa --release`.
3. Upload via Xcode Organizer or Transporter.
4. TestFlight auto-notifies existing testers. New public testers can
   join via a public link (TestFlight → Public Link).

---

## Common failures + fixes

| Symptom | Fix |
| --- | --- |
| `No signing certificate found` | Open Xcode → Settings → Accounts → Add Apple ID → agree to Apple Developer Terms. |
| `Bundle identifier is not available` | The ID is taken by another app. Add a suffix: `com.evairdigital.evairsim.app`. |
| `ITMS-90338 Non-public API usage` | Uncommon with Flutter. Usually caused by an old plugin — run `flutter pub upgrade`. |
| Upload succeeds but TestFlight status stays at "Invalid Binary" | Check the email Apple sends; 99% of the time you missed Export Compliance (step 6.2). |
| `Build number already exists` | Bump the `+N` suffix in `pubspec.yaml`. |

## What's still stubbed out (explicitly, before App Store review)

These are fine for internal TestFlight but must be wired before public
App Store submission:

- **Payment**: the checkout flow calls `/v1/h5/payments/create` and
  then marks the order complete in the UI. A real Stripe confirmation
  step using `flutter_stripe` needs to land. Waiting on Stripe
  publishable key from the business side.
- **Barcode scanner**: physical SIM activation currently accepts
  manual entry only. `mobile_scanner` will be added before launch;
  the `NSCameraUsageDescription` string is already in place.
- **Notifications**: backend `/v1/h5/notifications` returns 500. We
  show an empty Inbox until the endpoint is stable.
- **Multi-language**: UI strings are English. The language picker
  is wired but the ARB files are not yet extracted.

Email all of the above to the China IT team so there are no
surprises during App Review.
