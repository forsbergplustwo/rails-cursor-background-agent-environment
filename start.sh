#!/usr/bin/env bash
set -euo pipefail

# Starts the app locally without Docker. Handles env, services, and commands.
# Usage: .cursor/start.sh [dev|test]

MODE="${1:-test}"

echo "==> Start: Running .cursor/start.sh"
# Ensure services are started
echo "==> Start: export PGPASSWORD=postgres"
eval "export PGPASSWORD=postgres" || true

# Activate mise for Ruby version management
echo "==> Start: Activate mise"
eval "$(mise activate bash)" || true

eval "sudo service postgresql start" || true
eval "sudo service redis-server start" || true

# Environment selection
case "$MODE" in
  dev|development)
    echo "==> Start: export RAILS_ENV=development"
    eval "export RAILS_ENV=development" || true
    eval "export NODE_ENV=development" || true
    ;;
  test)
    echo "==> Start: export RAILS_ENV=test"
    eval "export RAILS_ENV=test" || true
    eval "export NODE_ENV=test" || true
    ;;
  *)
    echo "Unknown mode: $MODE (expected: dev|test)" >&2
    exit 1
    ;;
esac

# Ensure dependencies
echo "==> Start: bin/setup"
eval "bin/setup" || true
