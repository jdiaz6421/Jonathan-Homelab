#!/usr/bin/env bash

# Creates a simple backup of the repo files and Docker configuration folders.

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_DIR=$(dirname "$SCRIPT_DIR")
BACKUP_DIR="${BACKUP_DIR:-$REPO_DIR/backups}"
DOCKER_CONFIG_DIR="${CONFIG_ROOT:-/srv/docker}"
DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_FILE="$BACKUP_DIR/homelab-config-$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "Creating backup..."

tar -czf "$BACKUP_FILE" \
  --exclude='*.log' \
  --exclude='cache' \
  -C "$REPO_DIR" compose config docs \
  "$DOCKER_CONFIG_DIR" 2>/dev/null

if [ $? -ne 0 ]; then
  echo "Backup failed. Check that the listed folders exist and are readable."
  exit 1
fi

sha256sum "$BACKUP_FILE" > "$BACKUP_FILE.sha256"

echo "Backup created:"
echo "$BACKUP_FILE"
