# Troubleshooting Notes

## A bind mount writes to the VM disk

A mount point can exist as an ordinary directory even when the NAS is unavailable. Docker will accept that path and write data locally unless the mount is verified first.

```bash
findmnt /mnt/homelab-data
df -h /mnt/homelab-data
mountpoint /mnt/homelab-data
```

I stop affected containers, restore the NFS mount, verify its source, and then restart the stack.

## A container configuration directory is not writable

I check disk capacity before assuming the issue is only permissions. A full root filesystem can produce errors that resemble ownership problems.

```bash
df -h /
ls -ld /srv/docker
test -w /srv/docker && echo writable
```

When ownership is incorrect, I correct only the affected service directory rather than recursively changing the entire host.

```bash
sudo chown -R 1000:1000 /srv/docker/SERVICE_NAME
sudo chmod -R u+rwX /srv/docker/SERVICE_NAME
```

## DNS recursion or query floods

During Pi-hole testing, I keep router WAN DNS independent from Pi-hole. LAN clients can use Pi-hole while Pi-hole uses explicit upstream resolvers. I avoid configurations where the router forwards to Pi-hole and Pi-hole forwards back to the router.

## A container repeatedly restarts

```bash
docker ps -a
docker inspect -f '{{.RestartCount}} {{.State.Status}} {{.State.Error}}' CONTAINER_NAME
docker logs --tail 100 CONTAINER_NAME
```

I check environment variables, port conflicts, bind-mounted permissions, and dependency availability before recreating the container.
