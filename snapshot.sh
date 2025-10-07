#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
export DEBCONF_NONINTERACTIVE_SEEN=true
export PATH="$HOME/.local/bin:$PATH"

echo "==> Snapshot: Installing system packages"
sudo -E apt-get update -qq
sudo -E apt-get install -y -qq --no-install-recommends \
  build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev libpq-dev libvips-dev \
  postgresql redis-tools redis

echo "==> Snapshot: Configure bash and mise"
sudo -E update-alternatives --install /bin/sh sh /bin/bash 100
sudo -E update-alternatives --set sh /bin/bash
sudo -E chsh -s /bin/bash "$USER"
curl -fsSL https://mise.run | sh

cat >> ~/.bashrc <<'EOF'
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"
export MISE_AUTO_INSTALL=1
export MISE_YES=1
EOF

# Also add to .bash_profile for login shells
cat >> ~/.bash_profile <<'EOF'
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
EOF

source ~/.bashrc

echo "==> Snapshot: Configure PostgreSQL"
sudo service postgresql start
sudo -u postgres psql -tAc "ALTER USER postgres WITH PASSWORD 'postgres';"

cat > "$HOME/.pgpass" <<'EOF'
localhost:5432:*:postgres:postgres
127.0.0.1:5432:*:postgres:postgres
EOF
chmod 0600 "$HOME/.pgpass"

echo "==> Snapshot: Start services"
sudo service redis-server start

echo "Done! Install editor extensions and capture snapshot."
