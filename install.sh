#!/usr/bin/env bash
set -euo pipefail

# Ensure we run from repo root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Install: Running .cursor/install.sh"
# Install language/toolchain via mise based on version files
echo "==> Install: Installing mise"
export PATH="$HOME/.local/bin:$PATH"
if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
# Auto-install any missing tools defined in .mise.toml/.tool-versions or language files (.ruby-version, .node-version, etc.)
export MISE_AUTO_INSTALL=1
export MISE_YES=1
# Activate mise for this shell
echo "==> Install: Activating mise"
if command -v mise >/dev/null 2>&1; then
  eval "export PGPASSWORD=postgres" || true
  eval "$(mise activate bash)"
  # Enable idiomatic version files like .ruby-version, .node-version
  eval "mise settings set idiomatic_version_file true" || true
  eval "mise settings add idiomatic_version_file_enable_tools node" || true
  eval "mise settings add idiomatic_version_file_enable_tools ruby" || true
  eval "mise settings add idiomatic_version_file_enable_tools yarn" || true
  eval "mise install" || true
  hash -r || true
fi
# Ensure services are started
echo "==> Install: Starting postgres and redis"
sudo service postgresql start || true
sudo service redis-server start || true

# Install dependencies and run rails setup and seeds
echo "==> Install: bin/setup"
eval "bin/setup" || true
echo "==> Install: bin/rails db:seed"
eval "bin/rails db:seed" || true
