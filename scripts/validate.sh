#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

shellcheck scripts/run-scenario.sh scripts/in-container-run.sh \
    scripts/lib/assertions.sh scripts/vps-curl-smoke.sh

test -f scenarios/index.tsv
grep -q '^vps	' scenarios/index.tsv
grep -q 'install.sh | bash -s -- --profile vps --plan' docs/ubuntu-vps-first-run-transcript.md
grep -q 'install.sh | bash -s -- --profile vps' docs/ubuntu-vps-first-run-transcript.md
grep -q 'smu doctor --strict --json' docs/ubuntu-vps-first-run-transcript.md

if [[ "${SMU_RUN_REAL_VPS_SMOKE:-false}" == "true" ]]; then
    scripts/vps-curl-smoke.sh
fi
