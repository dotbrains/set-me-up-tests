#!/usr/bin/env bash

fail() {
    local message="${1:-assertion failed}"
    echo "❌ ${message}" >&2
    exit 1
}

assert_path_exists() {
    local path="$1"
    [[ -e "$path" ]] || fail "expected path to exist: $path"
}

assert_git_repo() {
    local path="$1"
    git -C "$path" rev-parse --git-dir >/dev/null 2>&1 || fail "expected git repo at: $path"
}

assert_symlink() {
    local path="$1"
    [[ -L "$path" ]] || fail "expected symlink: $path"
}

assert_log_contains() {
    local log_file="$1"
    local token="$2"
    grep -Fq "$token" "$log_file" || fail "expected log to contain: $token"
}
