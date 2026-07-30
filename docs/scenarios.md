# Scenarios

Scenario files live in `scenarios/` and define the environment variables for each test run.
Each scenario bootstraps the blueprint, verifies the installer refuses dirty
blueprint updates by default, checks the `smu update` dry-run commands, verifies
`smu update blueprint` fast-forwards from a local test remote, then runs the
configured provisioning modules. It also verifies `smu update blueprint
--force-reset` discards a local-only commit in a controlled checkout.

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
| `SMU_INSTALLER_REF` | Installer GitHub ref used by the bootstrap URL | `main` |
| `SMU_INSTALLER_URL` | Full installer URL, for candidate branches or forks | `https://raw.githubusercontent.com/dotbrains/set-me-up-installer/$SMU_INSTALLER_REF/install.sh` |

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

To validate a candidate installer branch before it is merged to `main`, pass
the installer ref through to Docker:

```bash
SMU_PASS_HOST_ENV=true SMU_INSTALLER_REF=my-branch ./scripts/run-scenario.sh default
```

The GitHub Actions `CI` workflow exposes matching `installer_ref` and
`installer_url` dispatch inputs.
Scheduled CI also runs the `default` scenario with `SMU_INSTALLER_REF=candidate`
so the candidate channel is continuously checked.
