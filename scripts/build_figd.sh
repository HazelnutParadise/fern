#!/bin/bash
set -e

echo "[FIG] Checking Go installation..."
if ! command -v go &>/dev/null; then
    echo "[X] Go is not installed. Please run install_go.sh first."
    exit 1
fi

cd "$(dirname "$0")/../figd"

echo "[FIG] Building figd..."
GOOS=linux GOARCH=arm GOARM=6 go build -o figd main.go

echo "[FIG] figd built at figd/figd"
