# OpenVidu Community Docker Compose Deployment

> [!WARNING]
> Work in progress.

OpenVidu Community Plain Docker Compose deployment

## Usage

### Normal mode (bridge networking)

```bash
docker compose up -d
```

### Host network mode for openvidu

Runs the `openvidu` container with `network_mode: host`, which can improve WebRTC performance by removing NAT layers for the media server.

```bash
docker compose -f docker-compose.yml -f docker-compose.host.yaml up -d
```
