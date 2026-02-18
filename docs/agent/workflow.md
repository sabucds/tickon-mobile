# Agent workflow

## Default loop (always)
1) Research: read relevant files. Ask questions if requirements are unclear.
2) Plan: write or update `docs/plans/<date>-<topic>.md`.
3) Implement: execute only the next 2–4 plan tasks.
4) Validate: run the plan's verification steps (`flutter analyze`, tests, etc).

## Chunking rules
- Never attempt an entire feature in one pass.
- After each chunk:
  - ensure analyzers/tests are green (or explain why not),
  - update the plan with a short progress note,
  - stop.

## Two-session pattern (recommended for risky changes)
Use two Claude Code sessions:
- Architect: reviews design/plan quality and later reviews implemented diffs.
- Implementer: executes the plan tasks.

Mechanics:
- Architect produces/edits plan in `docs/plans/`.
- Implementer reads the plan and executes tasks 1–N (small batch).
- Architect reviews the work and requests fixes or signs off.
- Implementer updates plan status.

## Context hygiene
- Prefer `/clear` between phases instead of carrying giant context forward.
- If context is getting big: write state into the plan doc, then `/clear`, then continue.

## Non-negotiables
- No drive-by refactors while implementing a feature. Capture “nice-to-have” refactors as TODOs in the plan instead.
- Don’t invent APIs/packages/configs. Verify by reading repo files or official docs.
