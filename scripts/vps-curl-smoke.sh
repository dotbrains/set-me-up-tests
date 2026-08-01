#!/usr/bin/env bash

set -euo pipefail

installer_ref="${SMU_INSTALLER_REF:-main}"
installer_url="${SMU_INSTALLER_URL:-https://raw.githubusercontent.com/dotbrains/set-me-up-installer/${installer_ref}/install.sh}"

if ! command -v docker >/dev/null 2>&1; then
    echo "SKIP vps curl smoke: docker unavailable"
    exit 0
fi

for image in ubuntu:24.04 debian:stable-slim; do
    echo "vps curl smoke ${image}"
    docker run --rm \
        -e "SMU_INSTALLER_URL=${installer_url}" \
        -e SMU_BLUEPRINT=dotbrains/set-me-up-blueprint \
        -e SMU_BLUEPRINT_BRANCH=master \
        "$image" \
        bash -lc '
            set -euo pipefail
            apt-get update >/dev/null
            apt-get install -y bash curl git ca-certificates python3 >/dev/null
            bash <(curl -fsSL "$SMU_INSTALLER_URL") --profile vps --plan --no-header --skip-confirm
        '
done
