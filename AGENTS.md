# AGENTS.md

## Cursor Cloud specific instructions

### Environment

- **Flutter SDK**: Installed at `/opt/flutter/bin`. Must be on PATH: `export PATH="/opt/flutter/bin:$PATH"`.
- **Flutter version**: 3.38.6 (Dart 3.10.7). Satisfies `sdk: '>=3.8.0 <4.0.0'` in `pubspec.yaml`.
- **No test directory**: This is a thin WebView shell — there is no `test/` directory. `flutter test` will report "Test directory not found", which is expected.

### Running the app

```bash
# Web preview (development)
flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0

# Lint
flutter analyze
```

- On Flutter Web, the app shows a branded splash then **redirects the browser tab** to the production H5 URL (`https://evairdigital.com/app`). The actual WebView shell code (native bridge, pull-to-refresh, deep links) only executes on iOS/Android.
- To test against a local H5 dev server, pass `--dart-define=H5_URL=http://localhost:3000/app`.

### Gotchas for cloud agents

- The `cupertino_icons` font warning during `flutter build web` is cosmetic — the app does not use Cupertino icons and the build succeeds.
- `flutter run -d chrome` opens a Chrome window with DevTools; `flutter run -d web-server` is headless and preferred for CI/cloud.
- No Docker, no database, no backend services are needed locally — the app hits the production API at `https://evair.zhhwxt.cn/api` via the H5 site.
- There are no pre-commit hooks or lint-staged configuration in this repository.

### Key commands (see also CLAUDE.md § Run Commands)

| Task | Command |
|------|---------|
| Install deps | `flutter pub get` |
| Lint | `flutter analyze` |
| Build web | `flutter build web` |
| Run web (dev) | `flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0` |
