# CLAUDE.md

Guidance for any AI agent working in this repository.

## What This Is

**EvairSIM** — native Flutter mobile app for eSIM & physical SIM management. This is the Flutter successor to the Evair H5 web app. Target: iOS first (TestFlight), then Android.

## Project Layout (IMPORTANT)

| Path | Role |
|---|---|
| `~/Development/EvairSIM-App` | **Working copy** — always edit here |
| `~/Library/Mobile Documents/com~apple~CloudDocs/EvairSIM-App-Backup` | iCloud rsync mirror — DO NOT edit, gets overwritten on save |

`flutter create` / `pub get` hangs inside iCloud Drive (VPN/pub.dev resolution), so the working tree MUST be local.

## Remotes

| Remote | URL | Branch mapping |
|---|---|---|
| `origin` | `git@github.com:jordanmok88/EvairSIM-App.git` | push `main` → `main` |
| `aliyun` | `codeup.aliyun.com/sz0755/ZenoSIM/flutter.git` (China IT team) | push `main` → `feature/evairsim-jordan` — **never touch `feature/pccw`** |

## Save Workflow (IMPORTANT)

Jordan has two projects: **Evair H5** (`Cursor Codes/Evair-H5`) and this one (Flutter).
When he says "save" or "save my work", save BOTH:

```bash
bash "/Users/jordanmok/Desktop/iCloud Drive/Cursor Codes/save-all.sh"
```

To save just this project:

```bash
bash ~/Development/EvairSIM-App/scripts/save.sh
# or with message:
bash ~/Development/EvairSIM-App/scripts/save.sh "feat: xyz"
```

`scripts/save.sh` commits (if dirty), pushes to GitHub `origin`, pushes to `aliyun feature/evairsim-jordan`, then rsyncs the iCloud backup.

Full details: `.cursor/rules/auto-save-workflow.mdc`.

## Tech Stack

- Flutter 3.38.x + Dart 3.x
- State: Riverpod (`hooks_riverpod` + `riverpod_generator`)
- Routing: GoRouter (entry: `/home` → `HomeShell`)
- Network: plain Dio + `fpdart` `Either<Failure, T>` at repository boundary
- Storage: `flutter_secure_storage` (tokens, locale), Hive reserved for cache
- Codegen: `freezed` + `json_serializable` + `build_runner`
- UI: Material 3, Inter font, custom theme in `lib/core/theme/`
- API base: `https://evair.zhhwxt.cn/api` — `/v1/app` (Flutter guard) and `/v1/h5` (legacy web) — both accept the same Sanctum token

## Run Commands

```bash
# Web (for preview in Cursor Simple Browser)
flutter run -d web-server --web-port=8080 --web-hostname=localhost

# iOS Simulator
flutter run -d ios

# Codegen
dart run build_runner build --delete-conflicting-outputs

# Clean
flutter clean && flutter pub get
```

## Architecture (clean, strict layering)

- `lib/domain/entities/*` — Freezed models, no framework deps
- `lib/domain/repositories/*` — abstract contracts
- `lib/data/datasources/remote/*_api.dart` — thin Dio wrappers
- `lib/data/repositories/*_impl.dart` — `ResponseEnvelope` + mapping
- `lib/presentation/providers/*` — Riverpod providers
- `lib/presentation/controllers/*` — StateNotifiers for multi-step flows
- `lib/presentation/pages/*` — page widgets (hooks/consumer)
- `lib/presentation/widgets/*` — reusable UI atoms
- `lib/core/*` — theme, router, network, i18n, error

## Product Scope (current — April 21 2026, post-pivot-reversal)

Jordan reversed the April 2026 "no eSIM marketplace" decision. The Flutter
APP is now product-parity with the H5 marketplace for eSIM, while keeping
the physical-SIM activation flow as-is.

1. **eSIM marketplace = PRIMARY in-app** (H5 parity).
   - `EsimShopPage` (`lib/presentation/pages/shop/esim_shop_page.dart`)
     renders inside `HomeShell` whenever the SIM-type toggle is on `eSIM`.
   - Browse by country, hot packages grid, tap → `/checkout` → existing
     Stripe-based checkout pipeline (`CheckoutPage` → `OrderConfirmationPage`).
   - "Connect existing eSIM" remains as a SECONDARY link inside the shop
     for customers who received an eSIM by email (the legacy bind flow at
     `/connect-esim`).
2. **PCCW physical SIM** — bind by ICCID/barcode → top up. Sold on
   Amazon / Temu, no in-app shipping.
3. **Catalog API**: `/v1/h5/packages/locations`, `/v1/h5/packages?location=`,
   `/v1/h5/packages/hot` (already wired through `PackageRepository` +
   `shop_providers`).
4. **Top-up packages still come from admin portal** for already-bound SIMs:
   - `GET /v1/app/recharge-packages`
   - `POST /v1/app/recharge`
   - `POST /v1/app/recharge/{id}/pay`
5. **Payment platform decision (open)**:
   - iOS: Apple IAP planned (App Store rejection risk for Stripe digital
     goods). Will require an `in_app_purchase` integration before ship.
   - Android: Stripe stays.
   - Current `CheckoutPage` is Stripe-only — fine for web/Android preview,
     fine for TestFlight internal testing, MUST be replaced with IAP before
     App Store submission.

## Gotchas

- `flutter_localizations` requires `intl: ^0.20.2` — do NOT downgrade.
- `library_private_types_in_public_api` ignore required on `AppStrings.t()`.
- `build_runner` inside a sandboxed shell fails on engine stamp — run unsandboxed.
- Platform detection via `defaultTargetPlatform`, NOT `dart:io Platform` (web-compat).
- `useRootNavigator: true` for all bottom sheets so they overlay the bottom nav.
- No hardcoded `Colors.white`/`Colors.black` — only `AppColors` tokens.
