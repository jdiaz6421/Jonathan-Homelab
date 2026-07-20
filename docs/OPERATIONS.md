# Operations Runbook

This runbook captures the sequence I use for routine validation, deployment, and recovery.

## Safe deployment sequence

1. Confirm the NAS and Docker host are reachable.
2. Run `sudo mount -a`.
3. Run `./scripts/homelab-preflight.sh`.
4. Validate the Compose file.
5. Start the required stack.
6. Run `./scripts/stack-health.sh`.

```bash
sudo mount -a
./scripts/homelab-preflight.sh
docker compose --env-file .env -f compose/core-services.yml config --quiet
docker compose --env-file .env -f compose/core-services.yml up -d
./scripts/stack-health.sh
```

## Routine checks

```bash
findmnt /mnt/homelab-data
df -h /
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'
docker system df
```

## Recovery priority

1. Restore network connectivity and DNS.
2. Confirm the NAS and NFS export are available.
3. Restore the Docker host mount points.
4. Restore configuration data.
5. Start foundational services before dependent services.
6. Validate permissions, ports, and application health.

## Change procedure

Before changing a running stack, I create a configuration backup, validate the proposed Compose configuration, and document any environment or port changes.

```bash
./scripts/backup-configs.sh
docker compose --env-file .env -f compose/core-services.yml config --quiet
```
