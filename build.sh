#!/bin/bash

set -e

apt update
apt install -y qbittorrent-nox unzip wget
wget https://github.com/VueTorrent/VueTorrent/releases/download/v2.18.0/vuetorrent.zip

mkdir -p /home/metal_deploy_qbittorrent/.config

mkdir -p ./build/vuetorrent
unzip vuetorrent.zip -d ./build/vuetorrent
rm vuetorrent.zip

cat <<'EOF' > ./build/run.sh
#!/bin/bash

exec yes y | qbittorrent-nox
EOF

chmod +x ./build/run.sh
chown -R metal_deploy_qbittorrent:metal_deploy_qbittorrent /home/metal_deploy_qbittorrent
chown -R metal_deploy_qbittorrent:metal_deploy_qbittorrent /home/metal_deploy_qbittorrent/.config
echo "Build complete. Run './build/run.sh' to start qBittorrent with VueTorrent UI."
