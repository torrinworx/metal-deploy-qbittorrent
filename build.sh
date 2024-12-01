#!/bin/bash

set -e
apt update
apt install -y build-essential pkg-config libboost-system-dev \
	libboost-chrono-dev libboost-random-dev libssl-dev \
	qt6-base-dev qt6-tools-dev qt6-tools-dev-tools qt6-svg-dev \
	zlib1g-dev python3 libtorrent-rasterbar-dev cmake

rm -rf qBittorrent
rm -rf qBittorrent-release-5.0.2

wget https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-5.0.2.tar.gz -O ./qBittorrent.tar.gz
tar -xvzf ./qBittorrent.tar.gz -C ./
mv qBittorrent-release-5.0.2 qBittorrent

mkdir -p qBittorrent/build
cd qBittorrent
cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu/cmake
cmake --build build

cd ..
mkdir -p ./build/
cat <<'EOF' > ./build/run.sh
#!/bin/bash

exec "./qBittorrent/build/src/app/qbittorrent"
EOF

chmod +x ./build/run.sh
rm ./qBittorrent.tar.gz
echo "Build complete. Run './build/run.sh' to start qBittorrent."
