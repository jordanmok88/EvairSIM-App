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

## Product Scope (post-April-2026 pivot)

1. **PCCW physical SIM** = PRIMARY — bind by ICCID/barcode → top up
2. **Red Tea eSIM** = SECONDARY — customer "connects" an eSIM they already own (LPA code) → top up
3. **No eSIM marketplace** (`ShopPage` removed; `HomeShell` unifies under `MySimsPage`)
4. **No shipping** — customers buy physical SIMs on Amazon/Temu
5. **Top-up packages come from admin portal**, not supplier API:
   - `GET /v1/app/recharge-packages`
   - `POST /v1/app/recharge`
   - `POST /v1/app/recharge/{id}/pay`

## Gotchas

- `flutter_localizations` requires `intl: ^0.20.2` — do NOT downgrade.
- `library_private_types_in_public_api` ignore required on `AppStrings.t()`.
- `build_runner` inside a sandboxed shell fails on engine stamp — run unsandboxed.
- Platform detection via `defaultTargetPlatform`, NOT `dart:io Platform` (web-compat).
- `useRootNavigator: true` for all bottom sheets so they overlay the bottom nav.
- No hardcoded `Colors.white`/`Colors.black` — only `AppColors` tokens.
