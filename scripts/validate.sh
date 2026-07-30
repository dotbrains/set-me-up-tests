#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

shellcheck scripts/run-scenario.sh scripts/in-container-run.sh \
    scripts/lib/assertions.sh

test -f scenarios/index.tsv
grep -q '^vps	' scenarios/index.tsv
