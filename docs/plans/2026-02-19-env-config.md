# Plan: Environment config + HTTP client

## Approach
`--dart-define` flags at build/run time → read by `AppConfig` via `String.fromEnvironment`.
No `.env` files, no extra packages for config.

## Config value
- `API_BASE_URL` — default `http://localhost:3000`

## Files to create
- `lib/core/config/app_config.dart` — const config from `--dart-define`
- `lib/core/network/api_client.dart` — Dio wrapper configured with `AppConfig.apiBaseUrl`

## Files to modify
- `pubspec.yaml` — add `dio: ^5.x`
- `lib/features/auth/data/repositories/auth_repository_impl.dart` — accept ApiClient; keep stub for now
- `.vscode/launch.json` — dev run config with `--dart-define=API_BASE_URL=http://localhost:3000`

## Run command
```
flutter run --dart-define=API_BASE_URL=https://api.dev.tickon.com
```

## Rollback
Remove dio, delete `app_config.dart` + `api_client.dart`, revert `auth_repository_impl.dart`.
