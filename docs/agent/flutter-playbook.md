# Flutter playbook (project conventions)

## Goals
- Predictable structure, testable code, boring architecture.
- Keep UI dumb, keep business logic in services/state.
- Prefer fewer dependencies; add packages only when they pay rent.

## Suggested folder structure (lib/)
- `lib/app/` app entry, routing, theming
- `lib/features/<feature>/` feature modules (ui, state, service)
- `lib/core/` cross-cutting: http, errors, logging, config
- `lib/domain/` entities/value objects (booking, ticket, venue, user)
- `lib/data/` DTOs, API clients, repositories (if used)

## State management (decision later)
If no decision exists yet, do not pick one silently.
- Write an ADR if proposing Riverpod/BLoC/etc.
- Default until decided: keep state local to widgets + simple ChangeNotifier where needed.

## Error handling
- Never swallow exceptions.
- Convert low-level errors into user-meaningful failures at the boundary (API/service layer).
- Ensure UI has explicit loading/error/empty states.

## UI principles
- Accessibility: sensible text scaling, tappable sizes.
- Deterministic layouts: avoid magic numbers when possible.
