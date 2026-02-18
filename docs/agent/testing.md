# Testing & validation

## TDD (required for new behavior)
For new logic/state behavior:
1) write a failing test
2) implement minimal code to pass
3) refactor with tests green

UI: prefer behavior-driven widget tests; avoid brittle layout assertions.

## Minimum validation for every PR
- `flutter analyze` is clean.
- `flutter test` is green.
- New logic has unit tests; new widgets have widget tests.

## Testing pyramid
- Unit tests: domain logic, services, parsing, validation
- Widget tests: UI behavior, state transitions
- Integration tests: happy-path booking flow (added once we have stable flows)

## When fixing bugs
- Reproduce first.
- Add a failing test that captures the bug.
- Fix only enough to make it pass.
- Add edge-case tests if the bug suggests them.
