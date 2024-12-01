#!/bin/bash

set -e

apt update
apt install -y qbittorrent-nox unzip wget
wget https://github.com/VueTorrent/VueTorrent/releases/download/v2.18.0/vuetorrent.zip

mkdir -p /home/metal_deploy_qbittorrent/.config/qBittorrent

mkdir -p ./build/vuetorrent
unzip vuetorrent.zip -d ./build/vuetorrent
rm vuetorrent.zip

# Path to the qBittorrent config
CONFIG_FILE="/home/metal_deploy_qbittorrent/.config/qBittorrent/qBittorrent.conf"

# Set default username and password if they do not exist
if ! grep -q "WebUI\\Username=" "$CONFIG_FILE"; then
	echo "WebUI\\Username=admin" >> "$CONFIG_FILE"
fi

if ! grep -q "WebUI\\Password_ha1=" "$CONFIG_FILE"; then
	# SHA1 hash for the password "password"
	echo "WebUI\\Password_ha1=5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8" >> "$CONFIG_FILE"
fi

cat <<'EOF' > ./build/run.sh
#!/bin/bash

exec yes y | qbittorrent-nox
EOF

chmod +x ./build/run.sh
chown -R metal_deploy_qbittorrent:metal_deploy_qbittorrent /home/metal_deploy_qbittorrent
chown -R metal_deploy_qbittorrent:metal_deploy_qbittorrent /home/metal_deploy_qbittorrent/.config
echo "Build complete. Run './build/run.sh' to start qBittorrent with VueTorrent UI."
