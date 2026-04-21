# Scenarios

Scenario files live in `scenarios/` and define the environment variables for each test run.

## Scenario contract

### Required

| Variable | Description | Example |
|----------|-------------|---------|
| `SMU_BLUEPRINT` | GitHub repo to clone | `dotbrains/set-me-up-blueprint` |
| `SMU_BLUEPRINT_BRANCH` | Branch to check out | `master`, `main` |

### Optional

| Variable | Description | Default |
|----------|-------------|---------|
| `SMU_BLUEPRINT_SHA` | Exact commit to pin to after install | _(none)_ |
| `SMU_MODULES` | Space or comma-separated module names | _(none)_ |
| `SMU_RUN_IDEMPOTENCY` | Re-run provision to check idempotency | `true` |
| `SMU_EXPECTED_SYMLINKS` | Space or comma-separated paths that must be symlinks | _(none)_ |
| `SMU_HOME_DIR` | Install directory inside the container | `$HOME/set-me-up` |

## Built-in scenarios

### `default`

Uses the official `dotbrains/set-me-up-blueprint` on the `master` branch with the `example` module. Idempotency is enabled.

### `dotfiles`

Uses `nicholasadamou/dotfiles` on `main` with the `base` module. Idempotency is disabled (dotfiles are not designed for repeated runs).

## Adding a new scenario

Create a `.env` file in `scenarios/`:

```bash
SMU_BLUEPRINT=your-org/your-repo
SMU_BLUEPRINT_BRANCH=main
SMU_MODULES=base,php
SMU_RUN_IDEMPOTENCY=true
SMU_EXPECTED_SYMLINKS=/home/smu/.bashrc,/home/smu/.vimrc
```

Run it by name:

```bash
./scripts/run-scenario.sh your-scenario
```
