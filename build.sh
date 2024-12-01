#!/bin/bash

set -e

# Update package lists and install dependencies
apt update
apt install -y build-essential pkg-config libboost-system-dev \
	libboost-chrono-dev libboost-random-dev libssl-dev \
	qtbase5-dev qttools5-dev qttools5-dev-tools \
	libqt5svg5-dev zlib1g-dev python3 \
	libtorrent-rasterbar-dev 

# Download qBittorrent source code
wget https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-5.0.2.tar.gz -O ./qBittorrent.tar.gz
tar -xvzf ./qBittorrent.tar.gz -C ./
mv qBittorrent-release-5.0.2 qBittorrent

# Compile qBittorrent
mkdir -p qBittorrent/build
cd qBittorrent
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build

# Create a run script
mkdir -p ../build/
cat <<'EOF' > ../build/run.sh
#!/bin/bash

exec "../qBittorrent/build/src/app/qbittorrent"
EOF

chmod +x ../build/run.sh

# Clean up
cd ..
rm ./qBittorrent.tar.gz

echo "Build complete. Run './build/run.sh' to start qBittorrent."
