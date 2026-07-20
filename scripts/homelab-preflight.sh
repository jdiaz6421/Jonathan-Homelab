#!/usr/bin/env bash

# Basic checks I run before starting the Docker stack.

STORAGE_PATH="${SHARED_STORAGE_PATH:-/mnt/homelab-data}"
MIN_FREE_GB="${MIN_FREE_GB:-20}"
FAILED=0

echo "Homelab preflight check"
echo "-----------------------"

for cmd in docker findmnt df; do
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $cmd is installed"
  else
    echo "[FAIL] $cmd is missing"
    FAILED=1
  fi
done

if docker info >/dev/null 2>&1; then
  echo "[OK] Docker is running"
else
  echo "[FAIL] Docker is not running"
  FAILED=1
fi

if findmnt "$STORAGE_PATH" >/dev/null 2>&1; then
  echo "[OK] Shared storage is mounted at $STORAGE_PATH"
  findmnt "$STORAGE_PATH"
else
  echo "[FAIL] Shared storage is not mounted at $STORAGE_PATH"
  FAILED=1
fi

FREE_GB=$(df -BG / | awk 'NR==2 {gsub("G", "", $4); print $4}')

echo "[INFO] Root filesystem has ${FREE_GB} GB free"

if [ "$FREE_GB" -lt "$MIN_FREE_GB" ]; then
  echo "[WARN] Free space is below ${MIN_FREE_GB} GB"
fi

if [ "$FAILED" -ne 0 ]; then
  echo
  echo "Preflight check failed. Fix the items above before starting the stack."
  exit 1
fi

echo
echo "Preflight check passed."
