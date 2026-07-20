#!/usr/bin/env bash

# Shows Docker disk usage and optionally removes unused data.

echo "Current Docker disk usage"
echo "-------------------------"
docker system df

if [ "$1" != "cleanup" ]; then
  echo
  echo "No cleanup was run."
  echo "Use: $0 cleanup"
  exit 0
fi

echo
read -r -p "Remove unused images, networks, and build cache? Type yes: " ANSWER

if [ "$ANSWER" != "yes" ]; then
  echo "Cleanup cancelled."
  exit 0
fi

docker system prune -a

echo
echo "Docker disk usage after cleanup"
echo "-------------------------------"
docker system df
