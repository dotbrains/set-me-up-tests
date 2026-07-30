# set-me-up-tests

[![CI](https://github.com/dotbrains/set-me-up-tests/actions/workflows/ci.yml/badge.svg)](https://github.com/dotbrains/set-me-up-tests/actions/workflows/ci.yml) [![License: PolyForm Shield 1.0.0](https://img.shields.io/badge/License-PolyForm%20Shield%201.0.0-blue.svg)](https://polyformproject.org/licenses/shield/1.0.0)

[![Docker](https://img.shields.io/badge/-Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/) [![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/) [![Linux](https://img.shields.io/badge/-Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](https://www.linux.org/) [![Ubuntu](https://img.shields.io/badge/-Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com/) [![macOS](https://img.shields.io/badge/-macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)

Scenario-driven Docker tests for validating [`set-me-up`](https://github.com/dotbrains/set-me-up) provisioning on portable Linux containers.

## Quick start

```bash
# Run the default scenario (Docker/Linux)
./scripts/run-scenario.sh default

# Run the dotfiles scenario (Docker/Linux)
./scripts/run-scenario.sh dotfiles

# Run the headless VPS scenario (Docker/Linux)
./scripts/run-scenario.sh vps

# Run the dotfiles scenario on macOS (native)
./scripts/run-scenario.sh --native dotfiles-macos
```

## Scenarios

| Scenario | Blueprint | Modules | Platform |
|----------|-----------|---------|----------|
| `default` | `dotbrains/set-me-up-blueprint` (master) | `example` | Linux (Docker) |
| `dotfiles` | `nicholasadamou/dotfiles` (main) | `base` | Linux (Docker) |
| `vps` | `dotbrains/set-me-up-blueprint` (master) | `server/headless` | Linux (Docker) |
| `dotfiles-macos` | `nicholasadamou/dotfiles` (main) | `base` | macOS (native) |

## Requirements

- [Docker](https://www.docker.com/)

## Reproducible dev environment (Flox)

A [Flox](https://flox.dev) manifest at `.flox/env/manifest.toml` pins the harness toolchain (`bash`, `shellcheck`) used by CI. Activating it gives you the same versions GitHub Actions runs:

```bash
# From the tests/ directory:
flox activate

# Inside the activated shell:
shellcheck scripts/run-scenario.sh scripts/in-container-run.sh scripts/lib/assertions.sh
```

Docker is intentionally not pinned in the manifest — install it via your OS package manager or Docker Desktop.

To test installer changes before they are published to `main`, pass the
candidate ref into the scenario runner:

```bash
SMU_PASS_HOST_ENV=true SMU_INSTALLER_REF=my-branch ./scripts/run-scenario.sh default
```

The `CI` workflow also accepts `installer_ref` and `installer_url` inputs when
run manually from GitHub Actions.
On the scheduled run, CI also exercises the stable `candidate` installer branch
against the default scenario.

## Documentation

- [Scenario contract and environment variables](docs/scenarios.md)
- [Advanced usage](docs/usage.md)

## License

This project is licensed under the [PolyForm Shield License 1.0.0](https://polyformproject.org/licenses/shield/1.0.0) — see [LICENSE](LICENSE) for details.
