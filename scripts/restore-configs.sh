#!/usr/bin/env bash

# Extracts a backup into a folder for review.
# I restore to a separate location first instead of overwriting live files.

BACKUP_FILE="$1"
RESTORE_DIR="${2:-./restored-backup}"

if [ -z "$BACKUP_FILE" ]; then
  echo "Usage: $0 BACKUP_FILE [RESTORE_FOLDER]"
  exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
  echo "Backup file not found: $BACKUP_FILE"
  exit 1
fi

echo "Files in backup:"
tar -tzf "$BACKUP_FILE" | head -40

echo
read -r -p "Extract this backup to $RESTORE_DIR? Type yes: " ANSWER

if [ "$ANSWER" != "yes" ]; then
  echo "Restore cancelled."
  exit 0
fi

mkdir -p "$RESTORE_DIR"
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"

echo "Backup extracted to $RESTORE_DIR"
echo "Review the files before copying anything into the live configuration."
