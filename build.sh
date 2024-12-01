#!/bin/bash

set -e

# Update system and install necessary dependencies
apt update
apt install -y curl qttools5-dev-tools build-essential pkg-config automake libtool libssl-dev libboost-dev libboost-system-dev libboost-chrono-dev libboost-random-dev qtbase5-dev qt5-qmake zlib1g-dev

# Function to determine architecture
arch=$(dpkg --print-architecture)
case $arch in
	amd64) arch="x86_64" ;;
	arm|armf|armhf) arch="arm" ;;
	arm64) arch="aarch64" ;;
	*) echo "Unsupported architecture: $arch" && exit 1 ;;
esac

# Download and extract qBittorrent source code
wget "https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-5.0.2.tar.gz" -O ./qBittorrent.tar.gz
tar -xvzf ./qBittorrent.tar.gz -C ./
cd qBittorrent-release-4.5.0

# Build qBittorrent
./configure --prefix=$HOME/.local
make
make install

# Setup directories
cd ..
mkdir -p ./build/
mv ./qBittorrent-release-4.5.0 ./build/qbittorrent/
mkdir -p ~/.qbittorrent-data

# Create a run script
cat <<'EOF' > ./build/run.sh
#!/bin/bash

DATA_DIR=$(readlink -f "$HOME/.qbittorrent-data")
exec "$HOME/.local/bin/qbittorrent" --profile="$DATA_DIR"
EOF

chmod +x ./build/run.sh
rm ./qBittorrent.tar.gz

echo "Build complete. Run './build/run.sh' to start qBittorrent."
