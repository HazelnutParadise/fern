#!/bin/bash
set -e

echo "[FIG] Detecting architecture..."
ARCH=$(uname -m)

# 判斷適用的 Go 架構名稱
case "$ARCH" in
armv6l)
    GOARCH="armv6l"
    GOURLARCH="armv6l"
    ;;
armv7l)
    GOARCH="armv6l" # armv7l 也可用 armv6l binary，確保最大相容
    GOURLARCH="armv6l"
    ;;
aarch64)
    GOARCH="arm64"
    GOURLARCH="arm64"
    ;;
*)
    echo "[X] Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

GO_VERSION="1.24.4"
GO_TAR="go${GO_VERSION}.linux-${GOURLARCH}.tar.gz"
GO_URL="https://go.dev/dl/${GO_TAR}"

echo "[FIG] Downloading Go ${GO_VERSION} for ${GOURLARCH}..."
wget -q "$GO_URL"

echo "[FIG] Extracting Go..."
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$GO_TAR"
rm "$GO_TAR"

echo "[FIG] Setting up Go PATH..."
if ! grep -q '/usr/local/go/bin' ~/.profile; then
    echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.profile
fi

export PATH=$PATH:/usr/local/go/bin

echo "[FIG] Go installation complete."
go version
