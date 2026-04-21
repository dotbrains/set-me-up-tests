# set-me-up-tests

[![CI](https://github.com/dotbrains/set-me-up-tests/actions/workflows/ci.yml/badge.svg)](https://github.com/dotbrains/set-me-up-tests/actions/workflows/ci.yml) [![License: PolyForm Shield 1.0.0](https://img.shields.io/badge/License-PolyForm%20Shield%201.0.0-blue.svg)](https://polyformproject.org/licenses/shield/1.0.0/)

[![Docker](https://img.shields.io/badge/-Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/) [![Bash](https://img.shields.io/badge/-Bash-4EAA25?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/) [![Linux](https://img.shields.io/badge/-Linux-FCC624?style=flat-square&logo=linux&logoColor=black)](https://www.linux.org/) [![Ubuntu](https://img.shields.io/badge/-Ubuntu-E95420?style=flat-square&logo=ubuntu&logoColor=white)](https://ubuntu.com/) [![macOS](https://img.shields.io/badge/-macOS-000000?style=flat-square&logo=apple&logoColor=white)](https://www.apple.com/macos/)

Scenario-driven Docker tests for validating [`set-me-up`](https://github.com/dotbrains/set-me-up) provisioning on portable Linux containers.

## Quick start

```bash
# Run the default scenario (Docker/Linux)
./scripts/run-scenario.sh default

# Run the dotfiles scenario (Docker/Linux)
./scripts/run-scenario.sh dotfiles

# Run the dotfiles scenario on macOS (native)
./scripts/run-scenario.sh --native dotfiles-macos
```

## Scenarios

| Scenario | Blueprint | Modules | Platform |
|----------|-----------|---------|----------|
| `default` | `dotbrains/set-me-up-blueprint` (master) | `example` | Linux (Docker) |
| `dotfiles` | `nicholasadamou/dotfiles` (main) | `base` | Linux (Docker) |
| `dotfiles-macos` | `nicholasadamou/dotfiles` (main) | `base` | macOS (native) |

## Requirements

- [Docker](https://www.docker.com/)

## Documentation

- [Scenario contract and environment variables](docs/scenarios.md)
- [Advanced usage](docs/usage.md)

## License

This project is licensed under the [PolyForm Shield License 1.0.0](https://polyformproject.org/licenses/shield/1.0.0/) — see [LICENSE](LICENSE) for details.
