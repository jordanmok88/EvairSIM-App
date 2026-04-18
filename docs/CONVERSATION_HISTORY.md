# EvairSIM (Flutter) — Development Conversation History

> Last updated: April 18, 2026
> Repo: https://github.com/jordanmok88/EvairSIM-App (`main`)
> Aliyun mirror: `codeup.aliyun.com/sz0755/ZenoSIM/flutter.git` (`feature/evairsim-jordan`)
> iCloud backup: `~/Library/Mobile Documents/com~apple~CloudDocs/EvairSIM-App-Backup`
> Local: `~/Development/EvairSIM-App`

This document is the source-of-truth memory for the Flutter app build. It complements
`/Users/jordanmok/Desktop/iCloud Drive/Cursor Codes/Evair-H5/docs/CONVERSATION_HISTORY.md`
(which covers the H5 app this Flutter app is replacing).

---

## Original Intent

- Transition from the Evair-H5 web app to a **native Flutter mobile app** called **EvairSIM**.
- Compressed timeline: ship MVP to TestFlight in **1–2 weeks** (not the 4 weeks originally proposed).
- Priority platform: **iOS first** (Option A). Apple ID: `jordan_mok@icloud.com`.
- China IT team handed over a scaffold repo: `codeup.aliyun.com/sz0755/ZenoSIM/flutter.git` on `feature/pccw`.
- We did NOT clone that repo as the working tree — we did a clean `flutter create` at `~/Development/EvairSIM-App` and kept their docs as a style reference. Reason: their branch had unrelated history and partial scaffolding we didn't need; a fresh tree was faster.

---

## Tech Stack (as built)

- **Framework**: Flutter 3.38.x + Dart 3.x
- **State**: Riverpod (`hooks_riverpod` + `riverpod_generator`) — no `setState` for global state
- **Logic**: `flutter_hooks` (minimize `StatefulWidget`)
- **Routing**: GoRouter with `StatefulShellRoute.indexedStack` for bottom nav
- **Network**: Plain Dio (no retrofit) + `fpdart` `Either<Failure, T>` at repository boundary
- **Storage**: `flutter_secure_storage` (tokens, locale) + Hive (reserved for cache)
- **Codegen**: `freezed` + `json_serializable` + `build_runner`
- **UI**: Material 3, Inter font, custom glassmorphism theme (palette in `lib/core/theme/app_colors.dart`)
- **QR**: `qr_flutter` for activation codes
- **Charts**: custom-painted `UsageDonut` (avoided heavy chart libs)
- **Assets**: `flutter_launcher_icons` + `flutter_native_splash`
- **API base**: `https://evair.zhhwxt.cn/api` with `/v1/app` (Flutter-app guard) and `/v1/h5` (legacy web guard) — both accept the same Sanctum token

### China-friendly network setup
`~/.zshrc` sets:
```
PUB_HOSTED_URL=https://pub.flutter-io.cn
FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

---

## Milestones Completed (M0 – M7)

### M0 — Environment bootstrap
- Xcode installed via Mac App Store.
- `flutter doctor` green for iOS toolchain.
- Discovered `flutter create` hung when run from iCloud Drive (fake-IP / VPN pub.dev resolution issues); moved the project to `~/Development/EvairSIM-App` (local-only path).
- Configured pub mirror env vars (above) to unblock `pub get`.
- Removed `retrofit` / `retrofit_generator` from `pubspec.yaml` — preferred plain Dio.
- Added `invalid_annotation_target: ignore` to `analysis_options.yaml` to silence noise from freezed `JsonKey`.

### M1 — Auth (Laravel `/v1/app`)
- `AuthRepository` with `login`, `register`, `forgotPassword`, `resetPassword`, `logout`, `refreshToken`.
- Test account created for Jordan.
- Client-side **backend error translation** in `lib/core/error/backend_error_messages.dart` — maps Chinese backend `msg` strings and numeric `code`s to user-facing English.
- `ApiResponse.isSuccess` accepts: integer `0`, string `"0"` / `"200"` / `"201"` / `"SUCCESS"` (Laravel and H5 endpoints are inconsistent).
- Token persisted via `FlutterSecureStorage` under `access_token` / `refresh_token`.

### M2 — Shop (browse)
- `countriesProvider` + `hotPackagesProvider` via `ShopRepository`.
- `ShopPage` with `_Header` (dark gradient, "Hi, {name}", "207 countries • 2,489+ plans"), `_SearchBar`, `_HotPackages` horizontal carousel, `_CountryList` with flag + chevron rows.
- `CountryPackagesPage` drill-down with `_showPackagePreview` bottom sheet → "Buy now" → checkout route.
- **NOTE (added April 18)**: Comparing this implementation to the actual H5 `views/ShopView.tsx`, the Flutter shop is **structurally different** from the H5 design. See "Pending Redesign" below.

### M3 — Purchase / checkout
- `OrderApi` + `OrderRepository` wrap these endpoints:
  - `POST /v1/h5/orders/esim` — create eSIM order for a given `packageCode` (works with `auth:app` token)
  - `POST /v1/h5/payments/create` — create Stripe PaymentIntent and return `clientSecret`
  - `GET  /v1/app/orders` — paginated order list
  - `POST /v1/h5/email/esim-delivery` — send receipt email via Resend
- `CheckoutController` (StateNotifier) orchestrates: create order → create payment session → navigate to confirmation.
- **Payment is SIMULATED for MVP** — we create a real Stripe PaymentIntent on the backend but do NOT confirm it client-side. A test-mode banner is shown. Real Stripe Payment Sheet is deferred until publishable key is provisioned.
- `AppOrder` Freezed model has custom `readValue` functions to handle:
  - `order_no` vs `order_number` key inconsistency
  - `amount` as int cents (H5 create) vs float decimals (app list)
  - `status` defaulting to `'pending'` when absent
  - `lpa_code` / `lpa` / `qr_code` / `activation_code` fallback resolution
- `OrderConfirmationPage` renders the LPA via `qr_flutter`; shows an amber "provisioning…" banner when the backend hasn't yet issued a real LPA (falls back to `LPA:1$evair.zhhwxt.cn$<order_no>` placeholder so the screen renders).

### M4 — My SIMs
- `SimApi` + `SimRepository` wrap:
  - `GET  /v1/h5/user/sims`
  - `GET  /v1/h5/esim/{iccid}`
  - `GET  /v1/h5/esim/{iccid}/usage`
  - `POST /v1/app/users/bind-sim`
  - `POST /v1/app/users/unbind-sim`
  - `GET  /v1/app/recharge-packages`
  - `POST /v1/h5/orders/topup`
- `UsageDonut` custom painter — lightweight, no chart lib dependency.
- `MySimsPage` lists SIMs with combined usage overview + per-sim tiles.
- `SimDetailPage` → `TopUpPage` with filtered recharge packages.
- `PhysicalSimPage` — manual ICCID entry with "paste from clipboard"; camera barcode scanner deferred to native iOS/Android milestone.

### M5 — Profile
- `ProfilePage` with menu items: Inbox, Contact Us, My Orders, Language, About EvairSIM, Log out.
- `InboxPage` — empty state placeholder (backend notifications endpoint is currently broken per H5 rules).
- `ContactUsPage` — email deep link (`service@evairdigital.com`), website link (`evairdigital.com`), live-chat placeholder.
- `OrdersPage` — paginated list of `AppOrder`s via `ordersProvider`.

### M6 — i18n (en / zh / es)
- `lib/core/i18n/app_locale.dart` — `AppLocale` enum (en/zh/es) with flag emoji + label.
- `lib/core/i18n/app_strings.dart` — single typed accessor surface (`AppStrings.of(context).shopPopular`). Private `_K` enum of keys + three complete translation maps; missing key falls back to English then enum name.
- `LocaleController` (StateNotifier) persists locale to `flutter_secure_storage` under `app_locale_code`.
- `MaterialApp.router` now registers `flutter_localizations` delegates and rebuilds on locale change.
- Profile → Language shows a bottom sheet with flags; tapping switches the whole app instantly.
- Already localized: bottom nav, Profile menu, Shop header/sections/search hint, Buy-now button.
- NOT yet localized: every other screen's hardcoded strings (deferred polish — strings are still in English, but the accessor surface is ready).

### M7 — Branding & TestFlight prep
- Created placeholder icon assets at `assets/icon/` (`icon.png`, `icon_fg.png`, `splash_logo.png`) — solid orange gradient generated via Python. **To be replaced with real brand art before TestFlight.**
- `flutter_launcher_icons` + `flutter_native_splash` configured in `pubspec.yaml` for iOS, Android, Web.
- iOS `Info.plist`:
  - `CFBundleDisplayName` = `EvairSIM`
  - `NSCameraUsageDescription` — for future barcode scanner
  - `NSPhotoLibraryUsageDescription` — for future save-QR-to-photos
- `docs/TESTFLIGHT_GUIDE.md` written — covers bundle id, version bumping, App Store Connect registration, IPA build, Transporter upload, tester invites, smoke-test checklist, common failures.

---

## Key Architecture Decisions

1. **Unified API client with case conversion**: camelCase on the Dart side ↔ snake_case on the wire. Interceptors in `lib/core/network/` (`api_interceptor.dart`, `secure_storage_provider.dart`).
2. **`ResponseEnvelope` utility** (`lib/core/network/response_envelope.dart`) — centralizes the `{code, msg, data}` parsing so every repository doesn't reimplement the same error/success branching.
3. **Auth guard cross-compatibility confirmed** — the Sanctum token issued for `auth:app` works against `auth:h5` endpoints too, which is why we can reuse the richer H5 order/payment routes from the Flutter app.
4. **Clean Architecture, strict layering**:
   - `lib/domain/entities/*` — plain Freezed models, no framework deps
   - `lib/domain/repositories/*` — abstract contracts
   - `lib/data/datasources/remote/*_api.dart` — Dio wrappers (thin)
   - `lib/data/repositories/*_impl.dart` — apply `ResponseEnvelope`, map JSON to entities
   - `lib/presentation/providers/*` — Riverpod providers
   - `lib/presentation/controllers/*` — StateNotifiers for multi-step flows
   - `lib/presentation/pages/*` — page widgets (hooks/consumer)
   - `lib/presentation/widgets/*` — reusable UI atoms
5. **Platform detection via `defaultTargetPlatform`**, never `dart:io Platform`, so the app stays web-compatible during development on Chrome (`localhost:3002`).
6. **`useRootNavigator: true`** for all bottom sheets and dialogs so they overlay the bottom nav.
7. **No hardcoded `Colors.white` / `Colors.black`** — only palette tokens from `AppColors`.
8. **`const` constructors everywhere** — analyzer enforced via lint rules.

---

## Remotes & Sync Commands

```bash
# push to GitHub (personal, public)
git push origin main

# push to Aliyun (shared with China IT team, on a non-overlapping branch)
git push aliyun main:feature/evairsim-jordan

# iCloud backup
rsync -a --delete \
  --exclude='.git' --exclude='.dart_tool' --exclude='build' \
  --exclude='ios/Pods' --exclude='ios/.symlinks' \
  --exclude='android/.gradle' --exclude='android/build' --exclude='android/app/build' \
  "$HOME/Development/EvairSIM-App/" \
  "$HOME/Library/Mobile Documents/com~apple~CloudDocs/EvairSIM-App-Backup/"
```

---

## Pending Redesign — H5 Visual Fidelity Pass (next session)

On April 18 the user compared the running Flutter Shop page to the H5 `views/ShopView.tsx` and flagged they look materially different. Honest root cause: the initial Flutter UI followed the China IT team's Flutter style guide instead of cloning the H5. We need a second UI pass.

### Concrete gaps (Shop page)

| Element | H5 (source of truth) | Flutter (current) | Action |
|---|---|---|---|
| Header bg | White sticky, compact | Dark red/brown gradient banner | Replace with white sticky header |
| Greeting | `Hello, {name}` + `Find the perfect plan for your trip` | `Hi, {name}` + `207 countries…` | Copy H5 copy |
| Right icons | Bell (notifications badge) + round orange avatar | Logout icon only | Add bell + avatar, logout moved to Profile |
| Product toggle | Animated segmented pill `SIM Card ↔ eSIM` | Missing | Add toggle + route state |
| My SIMs quick-jump | Orange-bordered pill with stacked flags (shown when `activeSims` non-empty) | Missing | Build `_MySimsBar` |
| Hero card | Orange→red gradient ("Purchase your eSIM") for eSIM mode; dark slate ("Bind your SIM") for physical | Missing | Build `_EsimHero` + `_PhysicalHero` |
| Country rows | Flag + name + **"X Plans" badge**, popular rows have **amber background** | Flag + name + chevron | Add plan count badge + amber highlight |
| Popular plans carousel | **Does not exist in H5** | Present in Flutter | Remove, fold popularity into country list |

Same kind of drift exists on My SIMs, Profile, and the checkout/QR flow — do a pass on each after Shop is done.

### Session plan for tomorrow

1. Rewrite `ShopPage` + new widgets to match H5 exactly. Ship this first, let Jordan eyeball it.
2. Rewrite `MySimsPage` to match H5 `views/MySimsView.tsx`.
3. Rewrite `ProfilePage` to match H5 `views/ProfileView.tsx`.
4. Rewrite `CheckoutPage` + `OrderConfirmationPage` to match H5 checkout + eSIM result screens.
5. Rewrite `PhysicalSimPage` to match H5 `views/PhysicalSimSetupView.tsx` (3-step wizard).
6. One analyze + build_runner pass, commit with "feat: redesign UI to match H5 1:1", push to both remotes, iCloud sync.

---

## Deferred Items (post-H5-fidelity pass)

1. **Replace placeholder app icon** at `assets/icon/icon.png` with real EvairSIM brand art. Re-run `dart run flutter_launcher_icons` + `dart run flutter_native_splash:create`.
2. **Real Stripe Payment Sheet** — needs publishable key from backend team. Currently simulated with test-mode banner.
3. **Camera QR scanner for physical SIM activation** — native iOS/Android only. Use `mobile_scanner`. `NSCameraUsageDescription` is already in `Info.plist`.
4. **Live chat in Contact Us** — currently a placeholder card pointing to email.
5. **i18n coverage of every screen** — infrastructure is done; remaining pages still have hardcoded English strings.
6. **Apple Developer enrollment check** — required for TestFlight, follow `docs/TESTFLIGHT_GUIDE.md`.

---

## Known Issues & Gotchas

- `flutter analyze` currently passes with "No issues found".
- `flutter_localizations` requires `intl: ^0.20.2` (SDK-pinned) — do NOT downgrade.
- `library_private_types_in_public_api` ignore comment is required on `AppStrings.t()` because the key enum `_K` is intentionally private.
- When regenerating codegen (`dart run build_runner build`), always use `--delete-conflicting-outputs` since we have multiple sources emitting into the same `lib/app.g.dart`.
- Running `build_runner` from inside a sandboxed shell fails with "Operation not permitted" on the Flutter engine stamp — run with full permissions.
- Dev server: `flutter run -d chrome --web-port 3002 --web-browser-flag "--disable-web-security"` — dies when the shell that launched it is killed, that's fine.

---

## Session Log

### Session 1 (April 17–18, 2026)

- Set up Flutter environment (Xcode, mirrors).
- Built M0–M7 in one autonomous pass after Jordan said "work on everything automatically without keep asking me on every milestones."
- Created test account, mapped backend errors to English.
- Added i18n scaffolding, Shop search wiring, real-LPA surfacing on confirmation page.
- `git init` + baseline commit `eb5bfdd`.
- Pushed to GitHub (`jordanmok88/EvairSIM-App`, public) and Aliyun (`feature/evairsim-jordan`).
- iCloud backup synced.
- Jordan reviewed the Shop page screenshot and correctly pointed out the UI is structurally different from H5 → redesign planned for session 2.
- Session ended with a "good night."

### Session 2 (April 19, 2026)

**Part A — Shop redesign (done):**
- Rewrote `shop_page.dart` to match H5 structurally: white sticky SliverAppBar with greeting + bell + avatar, animated SIM Card / eSIM segmented toggle, mode-specific hero cards, unified country-list card with amber highlight for popular countries.
- New files: `core/constants/popular_countries.dart`, `presentation/providers/sim_type_provider.dart`, `presentation/widgets/shop/country_list_card.dart`.
- New theme tokens: `AppColors.starAmber`, `AppColors.popularRowBg`.
- Commit `21976eb`, pushed to GitHub `main`.

**Part B — Portal integration (done):**
Jordan flagged: "make sure the APP can connect to the features of our portal." Surveyed admin portal (`/Users/jordanmok/Desktop/iCloud Drive/Cursor Codes/admin`) and mapped features to Laravel endpoints. Identified the two biggest gaps: Inbox (notifications) and Contact Us (live chat) were static placeholders. Built the plumbing for both:
- `AppNotification` entity (locale-aware title/body getters)
- `Conversation` + `ChatMessage` entities (freezed)
- `NotificationApi`, `ChatApi` → Dio wrappers on `/v1/h5/notifications` and `/v1/h5/conversations/*`
- Repositories with `Either<Failure, T>` + `ResponseEnvelope` handling
- `notificationsProvider` (FutureProvider.autoDispose)
- `ChatController` / `ChatState`: creates conversation, optimistic send, 5s polling with `since=` delta.
- Commit follow-up. `flutter analyze` clean.

**Part C — Strategic pivot (IMPORTANT):**
Jordan clarified the app's product scope before we continued redesigning:

> "the major feature of the APP will be bind and top up the sim card from PCCW,
>  and then to be able to connect, top up red tea eSIM. No more eCard at the moment"

What this means operationally:
1. **PCCW physical SIM** is the PRIMARY surface — bind by ICCID / barcode, then top-up.
2. **Red Tea eSIM** is the SECONDARY surface — customer "connects" an eSIM they've already obtained (LPA code issued via email / admin portal), then tops it up.
3. **No more eCard / eSIM marketplace** — the "Shop by country, buy a new eSIM" flow is OFF-SCOPE for now. The `ShopPage` I just redesigned with country browse needs to be reshaped.
4. **No shipping flow** — customers buy physical PCCW SIMs on Amazon / Temu / your website; the app never handles purchase or shipping. (Future: deep-link to your Amazon listing.)
5. **Top-up packages come from the admin portal**, not the supplier API — see `routes/v1/app/protected.php`:
   - `GET /v1/app/recharge-packages`
   - `POST /v1/app/recharge`
   - `POST /v1/app/recharge/{id}/pay`
   - `GET /v1/app/recharge-records`
6. **Follow H5 layout exactly**, but swap "eCard from Red Tea" content with "SIM card from PCCW" content in the corresponding positions, and replace eSIM-browse with eSIM-connect.

Confirmed via `AskQuestion` form before pivoting any code.

**Pending rework for the pivot (session 2 continues or session 3):**
- Reshape `ShopPage`: keep header + toggle + hero styling, drop the country list + search. SIM Card mode → "Activate PCCW SIM" CTA routing to the existing 3-step wizard. eSIM mode → "Connect eSIM" CTA routing to a new `ConnectEsimPage`.
- Build `ConnectEsimPage`: paste LPA activation code (and later, QR scan). Calls backend to register the eSIM against the user, then navigates to My SIMs.
- Switch top-up flow to `/v1/app/recharge-packages` + `/v1/app/recharge` + `/v1/app/recharge/{id}/pay`.
- Remove / hide `country_packages_page.dart` + any eSIM marketplace purchase hooks (CheckoutPage keeps top-up order path only).
- Rewrite Inbox + Contact Us UIs on top of the already-wired providers.
- Redesign My SIMs (donut + list + install CTA for eSIMs).
- Redesign Profile.
- Order detail + cancel + tracking for top-up history.

**Aliyun push policy reminder:** stay on `feature/evairsim-jordan`. Do NOT touch the Chinese team's `feature/pccw` branch.

---

## Resources

- **H5 source of truth**: `/Users/jordanmok/Desktop/iCloud Drive/Cursor Codes/Evair-H5/views/*.tsx`
- **H5 history**: `/Users/jordanmok/Desktop/iCloud Drive/Cursor Codes/Evair-H5/docs/CONVERSATION_HISTORY.md`
- **Backend API spec**: `/Users/jordanmok/Development/EvairSIM-App/docs/BACKEND_API_SPEC.md` (if present) — otherwise cross-reference H5's `services/api/` and Laravel `routes/` files
- **TestFlight guide**: `/Users/jordanmok/Development/EvairSIM-App/docs/TESTFLIGHT_GUIDE.md`
- **Agent transcripts folder**: `/Users/jordanmok/.cursor/projects/Users-jordanmok-Desktop-iCloud-Drive-Cursor-Codes-Evair-H5/agent-transcripts/`
