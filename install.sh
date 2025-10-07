#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Install: Configure mise and install Ruby/Node"
source ~/.bashrc
mise settings set idiomatic_version_file true
mise settings add idiomatic_version_file_enable_tools node
mise settings add idiomatic_version_file_enable_tools ruby
mise settings add idiomatic_version_file_enable_tools yarn
mise install

echo "==> Install: Start services and setup Rails"
sudo service postgresql start
sudo service redis-server start
if [ -n "${RAILS_MASTER_KEY:-}" ]; then
  bin/setup
  bin/rails seed:load
else
  echo "==> Install: Skipping Rails setup (RAILS_MASTER_KEY not set)"
fi
