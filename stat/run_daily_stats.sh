#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN="${PYTHON_BIN:-python3}"
export DOCKER_STATS_DB_PATH="${DOCKER_STATS_DB_PATH:-$SCRIPT_DIR/docker_image_stats.duckdb}"

if [[ -z "${DOCKER_STATS_DB_PATH:-}" ]]; then
    echo "ERROR: DOCKER_STATS_DB_PATH env var is required." >&2
    echo "Example: DOCKER_STATS_DB_PATH=/var/lib/chumaky/docker_image_stats.duckdb $0" >&2
    exit 2
fi

exec "$PYTHON_BIN" "$SCRIPT_DIR/fetch_docker_stats.py" "$@"
