#!/bin/bash

set -e

apt update
apt install -y qbittorrent-nox unzip wget
wget https://github.com/VueTorrent/VueTorrent/releases/download/v2.18.0/vuetorrent.zip

mkdir -p ./build/vuetorrent
unzip vuetorrent.zip -d ./build/vuetorrent
rm vuetorrent.zip

CONFIG_DIR="/home/metal_deploy_qbittorrent/.config/qBittorrent"
mkdir -p "$CONFIG_DIR/qBittorrent/cache"
chown -R metal_deploy_qbittorrent: "$CONFIG_DIR"
chmod -R 755 "$CONFIG_DIR"

cat <<'EOF' > ./build/run.sh
#!/bin/bash

CONFIG_DIR="/home/metal_deploy_qbittorrent/.config/qBittorrent"
mkdir -p "$CONFIG_DIR/qBittorrent/cache"

exec qbittorrent-nox --webui-root=./vuetorrent
EOF

chmod +x ./build/run.sh
echo "Build complete. Run './build/run.sh' to start qBittorrent with VueTorrent UI."
