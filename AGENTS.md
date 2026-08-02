# AGENTS.md

## Project Snapshot

This repository owns scenario-driven validation for `set-me-up` installers,
blueprints, VPS flows, and productized smoke surfaces. It is the integration
test harness, not the implementation home for installer or module behavior.

## Where To Add Things

- Add or update scenario metadata in `scenarios/index.tsv`.
- Add scenario behavior under `scenarios/`, `scripts/`, or `docs/` following
  the existing runner patterns.
- Keep Docker/Linux scenarios portable and keep native macOS coverage explicit.
- Do not edit sibling repositories from this checkout unless the routed task
  explicitly spans multiple repos.

## Validation

Run the native validator before finishing:

```bash
scripts/validate.sh --all
```

For focused scenario checks:

```bash
./scripts/run-scenario.sh default
./scripts/run-scenario.sh vps
./scripts/run-scenario.sh vps-ubuntu
./scripts/run-scenario.sh vps-debian
```

Use the opt-in real VPS smoke only when Docker and runtime budget are
available:

```bash
SMU_RUN_REAL_VPS_SMOKE=true ./scripts/validate.sh
```

## Git

- Use conventional commits.
- Do not add `Co-Authored-By` or AI attribution footers.
- Never force-push `main`.
