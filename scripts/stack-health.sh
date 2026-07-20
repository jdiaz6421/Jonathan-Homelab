#!/usr/bin/env bash

# Quick status report for the Docker host.

STORAGE_PATH="${SHARED_STORAGE_PATH:-/mnt/homelab-data}"

echo "Filesystem usage"
echo "----------------"
df -h / "$STORAGE_PATH" 2>/dev/null

echo
echo "Shared storage"
echo "--------------"
if findmnt "$STORAGE_PATH" >/dev/null 2>&1; then
  findmnt "$STORAGE_PATH"
else
  echo "$STORAGE_PATH is not mounted"
fi

echo
echo "Containers"
echo "----------"
docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'

echo
echo "Docker disk usage"
echo "-----------------"
docker system df
