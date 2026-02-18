# Architecture

Clean Architecture, feature-first. Three layers per feature, strict dependency direction.

## Folder structure

```
lib/
├── main.dart
├── app/               # root widget, router, theme, DI bootstrap
├── core/              # shared: errors, network, base usecase, DI setup
└── features/
    └── <feature>/
        ├── domain/    # pure Dart — entities, repository interfaces, usecases
        ├── data/      # models (DTOs), datasources, repository impls
        └── presentation/  # cubit + state, pages, widgets

test/
├── helpers/           # shared mocks, fakes, fixtures
└── features/<feature>/
    ├── domain/
    ├── data/
    └── presentation/
```

## Dependency rule

```
presentation → domain ← data
```

- `domain/` depends on nothing. No Flutter SDK, no packages.
- `data/` depends on `domain/` interfaces only.
- `presentation/` depends on `domain/` (usecases + entities) only. Never imports `data/` directly.

## Layer responsibilities

| Layer | Contains |
|---|---|
| `domain/entities/` | Plain Dart classes, Equatable, no JSON |
| `domain/repositories/` | Abstract interfaces only |
| `domain/usecases/` | One class per action, extends `UseCase<Result, Params>` |
| `data/models/` | DTOs with `fromJson`/`toJson`, map to/from entities |
| `data/datasources/` | Remote (API) and local (secure storage / cache) |
| `data/repositories/` | Implements domain interface, coordinates datasources |
| `presentation/cubit/` | Cubit + sealed state; escalate to Bloc if events get complex |
| `presentation/pages/` | Thin — reads state, delegates to widgets |
| `presentation/widgets/` | Stateless where possible |

## Error handling

- Data layer throws typed `Exception` subclasses.
- Repository catches and maps to `Failure` sealed classes (domain-safe).
- Cubit exposes failures as state variants (never raw exceptions to UI).

## DI

- `get_it` service locator, registered in `core/di/injection.dart`.
- Each feature registers its own datasources, repositories, usecases, cubits.

## State management

- `flutter_bloc` (Cubit by default).
- States are sealed classes with `Equatable`.
- Use `bloc_test` for all cubit tests.

## Testing rules

- Domain usecases: pure unit tests, no mocks needed unless repository involved.
- Repository impls: mock datasources with `mocktail`.
- Cubits: use `bloc_test`, mock usecases.
- Widgets: `WidgetTester`, test behavior not layout.
- TDD order: entity → repository interface → usecase → impl → cubit → UI.
