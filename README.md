# OpenVidu Community Docker Compose Deployment

> [!WARNING]
> Work in progress.

OpenVidu Community Plain Docker Compose deployment

## Usage

### Normal mode (bridge networking)

```bash
docker compose up -d
```

All services communicate over the internal `openvidu-docker-compose` bridge network.

### Host network mode for openvidu

Runs the `openvidu` container with `network_mode: host`, which can improve WebRTC performance by removing NAT layers for the media server.

```bash
docker compose -f docker-compose.yml -f docker-compose.host.yaml up -d
```

In this mode:
- `openvidu` binds directly to the host network interfaces.
- Redis and MongoDB publish their ports (`6379`, `27017`) so `openvidu` can reach them via `127.0.0.1`.
- All other services remain on the bridge network and reach `openvidu` via `host.docker.internal`.
