#!/usr/bin/env bash
set -euo pipefail

# Starts the app locally without Docker. Handles env, services, and commands.
# Usage: .cursor/start.sh [dev|test]

source ~/.bashrc

MODE="${1:-test}"

case "$MODE" in
  dev|development)
    echo "==> Start: Setting environment to development"
    export RAILS_ENV=development
    export NODE_ENV=development
    ;;
  test)
    echo "==> Start: Setting environment to test"
    export RAILS_ENV=test
    export NODE_ENV=test
    ;;
  *)
    echo "Unknown mode: $MODE (expected: dev|test)" >&2
    exit 1
    ;;
esac

echo "==> Start: Starting services (${RAILS_ENV})"
sudo service postgresql start
sudo service redis-server start

echo "==> Start: Running setup"
if [ -n "${RAILS_MASTER_KEY:-}" ]; then
  bin/setup
else
  echo "==> Start: Skipping setup (RAILS_MASTER_KEY not set)"
fi
