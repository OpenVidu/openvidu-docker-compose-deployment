# OpenVidu Caddy Proxy

This directory contains the Dockerfile to build a custom Caddy proxy image for OpenVidu Community Edition.

## Overview

This Caddy image is built with additional modules required by OpenVidu:

- **caddy-l4**: Layer 4 (TCP/UDP) proxy support
- **caddy-yaml**: YAML configuration support

## Building the Image

### Using Docker Compose (Recommended)

The image will be built automatically when you run:

```bash
docker compose up -d
```

### Manual Build

If you want to build the image manually:

```bash
cd docker/openvidu-caddy
docker build -t openvidu-caddy .
```

### Multi-platform Build

To build for multiple platforms (e.g., for both AMD64 and ARM64):

```bash
cd docker/openvidu-caddy
docker buildx build --platform linux/amd64,linux/arm64 -t openvidu-caddy .
```

## Configuration

The Caddy proxy is configured via `caddy.yaml` in the project root directory. It acts as a reverse proxy for:

- LiveKit WebSocket server (port 7880)
- OpenVidu Dashboard (path: /dashboard)
- OpenVidu Meet (path: /meet)
- MinIO Console (path: /minio-console)

## Notes

- This is the Community Edition (CE) version without licensing modules
- The image includes tzdata for timezone support
