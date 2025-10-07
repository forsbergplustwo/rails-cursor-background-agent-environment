#!/usr/bin/env bash
set -euo pipefail

echo "==> Snapshot: Running .cursor/snapshot.sh"
echo "==> Snapshot: Reference: https://gorails.com/setup/ubuntu/24.04"

SUDO="sudo"
export DEBIAN_FRONTEND=noninteractive

echo "==> Snapshot: Update apt"
$SUDO apt update -y
$SUDO apt-get update -y

echo "==> Snapshot: Install required apt libraries"
$SUDO apt install -y build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev libpq-dev libvips-dev

echo "==> Snapshot: Install PostgreSQL"
$SUDO apt install -y postgresql
echo "==> Snapshot: Start PostgreSQL"
$SUDO service postgresql start || true

echo "==> Snapshot: Install Redis"
$SUDO apt install -y redis-tools redis
echo "==> Snapshot: Start Redis"
$SUDO service redis-server start || true

echo "==> Snapshot: Set default postgres user password to 'postgres'"
$SUDO -u postgres psql -tAc "ALTER USER postgres WITH PASSWORD 'postgres';" || true
export PGPASSWORD=postgres

echo
echo "==> Snapshot: Manual steps"
echo "- Install editor extensions (install in background if prompted): Ruby LSP, StandardRB, Prettier, ESLint."
echo "- Click the "Capture Snapshot" button in the Cursor interactive sidebar."
echo
echo "Done."
