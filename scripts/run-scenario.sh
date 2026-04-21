#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

NATIVE=false
SCENARIO_INPUT=""

# Parse flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        --native)
            NATIVE=true
            shift
            ;;
        *)
            SCENARIO_INPUT="$1"
            shift
            ;;
    esac
done

if [[ -z "${SCENARIO_INPUT:-}" ]]; then
    SCENARIO_INPUT="default"
fi

SCENARIO_FILE=""

if [[ -f "${REPO_ROOT}/scenarios/${SCENARIO_INPUT}.env" ]]; then
    SCENARIO_FILE="${REPO_ROOT}/scenarios/${SCENARIO_INPUT}.env"
elif [[ -f "${SCENARIO_INPUT}" ]]; then
    SCENARIO_FILE="${SCENARIO_INPUT}"
else
    echo "❌ Scenario not found: ${SCENARIO_INPUT}" >&2
    echo "Available scenarios:" >&2
    ls -1 "${REPO_ROOT}/scenarios" >&2
    exit 1
fi

if [[ "${NATIVE}" == "true" ]]; then
    echo "▶ Running scenario natively: ${SCENARIO_FILE}"
    set -a
    # shellcheck disable=SC1090
    source "${SCENARIO_FILE}"
    set +a
    exec "${SCRIPT_DIR}/in-container-run.sh"
fi

IMAGE_TAG="${SMU_TEST_IMAGE_TAG:-set-me-up-tests:local}"

echo "▶ Building Docker image: ${IMAGE_TAG}"
docker build -t "${IMAGE_TAG}" -f "${REPO_ROOT}/docker/Dockerfile" "${REPO_ROOT}"

declare -a ENV_OVERRIDES=()
if [[ "${SMU_PASS_HOST_ENV:-false}" == "true" ]]; then
    for var in SMU_BLUEPRINT SMU_BLUEPRINT_BRANCH SMU_BLUEPRINT_SHA SMU_MODULES SMU_RUN_IDEMPOTENCY SMU_EXPECTED_SYMLINKS SMU_HOME_DIR; do
        if [[ -n "${!var:-}" ]]; then
            ENV_OVERRIDES+=(-e "${var}=${!var}")
        fi
    done
fi

echo "▶ Running scenario: ${SCENARIO_FILE}"
if (( ${#ENV_OVERRIDES[@]} > 0 )); then
    docker run --rm --env-file "${SCENARIO_FILE}" "${ENV_OVERRIDES[@]}" "${IMAGE_TAG}"
else
    docker run --rm --env-file "${SCENARIO_FILE}" "${IMAGE_TAG}"
fi
