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

# Configure qBittorrent with Web UI settings
if ! grep -q "WebUI\\AlternativeUIEnabled=" "$CONFIG_FILE"; then
    echo '[Preferences]' > "$CONFIG_FILE"
    echo 'WebUI\Password_PBKDF2=@ByteArray(ARQ77eY1NUZaQsuDHbIMCA==:0WMRkYTUWVT9wVvdDtHAjU9b3b7uB8NR1Gur2hmQCvCDpm39Q+PsJRJPaCU51dEiz+dTzh8qbPsL8WkFljQYFQ==)' >> "$CONFIG_FILE"
    echo 'WebUI\AlternativeUIEnabled=true' >> "$CONFIG_FILE"
    echo "WebUI\RootFolder=/home/metal_deploy_qbittorrent/build/vuetorrent" >> "$CONFIG_FILE"
else
    sed -i 's|^WebUI\\AlternativeUIEnabled=.*|WebUI\\AlternativeUIEnabled=true|' "$CONFIG_FILE"
    sed -i "s|^WebUI\\RootFolder=.*|WebUI\\RootFolder=/home/metal_deploy_qbittorrent/build/vuetorrent|" "$CONFIG_FILE"
fi

cat <<'EOF' > ./build/run.sh
#!/bin/bash

exec yes y | qbittorrent-nox
EOF

chmod +x ./build/run.sh
chown -R metal_deploy_qbittorrent:metal_deploy_qbittorrent /home/metal_deploy_qbittorrent
chown -R metal_deploy_qbittorrent:metal_deploy_qbittorrent /home/metal_deploy_qbittorrent/.config
echo "Build complete. Run './build/run.sh' to start qBittorrent with VueTorrent UI."
