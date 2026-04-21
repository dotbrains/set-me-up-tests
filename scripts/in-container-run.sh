#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "/opt/harness/scripts/lib/assertions.sh" ]]; then
    # shellcheck disable=SC1091
    source /opt/harness/scripts/lib/assertions.sh
else
    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/lib/assertions.sh"
fi

require_env() {
    local var_name="$1"
    [[ -n "${!var_name:-}" ]] || fail "missing required env var: $var_name"
}

normalize_list() {
    local raw="${1:-}"
    raw="${raw//,/ }"
    # shellcheck disable=SC2206
    local list=($raw)
    printf "%s\n" "${list[@]}"
}

run_installer() {
    export SMU_HOME_DIR="${SMU_HOME_DIR:-${HOME}/set-me-up}"
    export SMU_BLUEPRINT
    export SMU_BLUEPRINT_BRANCH
    export smu_home_dir="${SMU_HOME_DIR}"
    export TERM="${TERM:-xterm}"

    echo "▶ Running installer for ${SMU_BLUEPRINT}@${SMU_BLUEPRINT_BRANCH}"
    bash <(curl -s -L https://raw.githubusercontent.com/dotbrains/set-me-up-installer/main/install.sh) --no-header --skip-confirm

    assert_path_exists "${SMU_HOME_DIR}"
    assert_git_repo "${SMU_HOME_DIR}"
    assert_path_exists "${SMU_HOME_DIR}/set-me-up-installer/smu"
}

pin_sha_if_requested() {
    if [[ -z "${SMU_BLUEPRINT_SHA:-}" ]]; then
        return 0
    fi

    echo "▶ Pinning blueprint checkout to SHA ${SMU_BLUEPRINT_SHA}"
    git -C "${SMU_HOME_DIR}" fetch --all --tags --quiet
    git -C "${SMU_HOME_DIR}" checkout "${SMU_BLUEPRINT_SHA}"
    git -C "${SMU_HOME_DIR}" submodule update --init --recursive
}

run_provision() {
    local smu_cmd="${SMU_HOME_DIR}/set-me-up-installer/smu"
    export smu_home_dir="${SMU_HOME_DIR}"
    chmod +x "$smu_cmd"

    local -a modules=()
    while IFS= read -r module; do
        [[ -n "$module" ]] && modules+=("$module")
    done < <(normalize_list "${SMU_MODULES:-}")

    local -a cmd=("$smu_cmd" --provision)
    if (( ${#modules[@]} > 0 )); then
        cmd+=(--modules "${modules[@]}")
    fi

    local log_file
    log_file="$(mktemp)"
    echo "▶ Running provision command: ${cmd[*]}"
    "${cmd[@]}" | tee "$log_file"

    if [[ "${SMU_RUN_IDEMPOTENCY:-true}" == "true" ]]; then
        echo "▶ Re-running provision command for idempotency check"
        "${cmd[@]}" | tee -a "$log_file"
    fi

    for module in "${modules[@]}"; do
        assert_log_contains "$log_file" "$module"
    done

    rm -f "$log_file"
}

assert_expected_symlinks() {
    local -a symlinks=()
    while IFS= read -r path; do
        [[ -n "$path" ]] && symlinks+=("$path")
    done < <(normalize_list "${SMU_EXPECTED_SYMLINKS:-}")

    if (( ${#symlinks[@]} == 0 )); then
        echo "ℹ No explicit symlink assertions configured."
        return 0
    fi

    for path in "${symlinks[@]}"; do
        assert_symlink "$path"
    done
}

main() {
    require_env "SMU_BLUEPRINT"
    require_env "SMU_BLUEPRINT_BRANCH"

    run_installer
    pin_sha_if_requested
    run_provision
    assert_expected_symlinks

    echo "✅ Scenario completed successfully."
}

main "$@"
