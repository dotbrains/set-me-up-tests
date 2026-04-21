# Usage

## Running scenarios

```bash
# By name (looks in scenarios/)
./scripts/run-scenario.sh default
./scripts/run-scenario.sh dotfiles

# By file path
./scripts/run-scenario.sh ./scenarios/default.env
```

## Environment overrides

By default, host `SMU_*` variables are **not** forwarded — scenario files are the source of truth. Enable forwarding with `SMU_PASS_HOST_ENV=true`:

```bash
SMU_PASS_HOST_ENV=true SMU_BLUEPRINT_BRANCH=main SMU_MODULES=example ./scripts/run-scenario.sh default
```

## Pinning to a commit

```bash
SMU_BLUEPRINT_SHA=abc1234 ./scripts/run-scenario.sh default
```

This checks out the specified SHA after the installer clones the blueprint.

## Custom Docker image tag

```bash
SMU_TEST_IMAGE_TAG=my-registry/set-me-up-tests:v1 ./scripts/run-scenario.sh default
```

## How it works

1. `run-scenario.sh` builds a Docker image from `docker/Dockerfile` (Ubuntu 24.04).
2. It runs the image with the scenario's `.env` file as environment variables.
3. Inside the container, `in-container-run.sh`:
   - Validates required env vars (`SMU_BLUEPRINT`, `SMU_BLUEPRINT_BRANCH`)
   - Downloads and runs the `set-me-up` installer
   - Optionally pins to a specific commit SHA
   - Runs `smu --provision` with the specified modules
   - Optionally re-runs provision for idempotency
   - Asserts expected symlinks exist
4. The container exits with the result.

## Assertions

The harness provides these assertion helpers (in `scripts/lib/assertions.sh`):

| Assertion | Checks |
|-----------|--------|
| `assert_path_exists` | Path exists on disk |
| `assert_git_repo` | Path is a valid git repository |
| `assert_symlink` | Path is a symbolic link |
| `assert_log_contains` | Provision log contains a token |
