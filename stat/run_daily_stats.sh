#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN="${PYTHON_BIN:-$HOME/.venv/docker-images/bin/python}"

echo "Running daily stats fetcher with Python binary: $PYTHON_BIN"
exec "$PYTHON_BIN" "$SCRIPT_DIR/fetch_docker_stats.py" "$@"
