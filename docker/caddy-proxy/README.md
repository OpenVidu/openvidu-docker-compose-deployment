# OpenVidu Caddy Proxy

This directory contains the Dockerfile to build a custom Caddy proxy image for OpenVidu Community Edition.

## Overview

This Caddy image is built with additional modules required by OpenVidu:

- **caddy-l4**: Layer 4 (TCP/UDP) proxy support

## Building the Image

### Using Docker Compose (Recommended)

The image will be built automatically when you run:

```bash
docker compose up -d
```

### Manual Build

If you want to build the image manually:

```bash
cd docker/caddy-proxy
docker build -t caddy-layer4 .
```

### Multi-platform Build

To build for multiple platforms (e.g., for both AMD64 and ARM64):

```bash
cd docker/caddy-proxy
docker buildx build --platform linux/amd64,linux/arm64 -t caddy-layer4 .
```

## Configuration

The Caddy proxy is configured via the `Caddyfile` in the project root directory. It acts as a reverse proxy for:

- LiveKit WebSocket server (port 7880)
- OpenVidu Dashboard (path: /dashboard)
- OpenVidu Meet (path: /meet)
- MinIO Console (path: /minio-console)

## Versions

The Dockerfile pins specific versions for reproducibility:

- Caddy: v2.11.1
- xcaddy: v0.4.5
- caddy-l4: v0.0.0-20260216070754-eca560d759c9

## Base Image

- **Builder**: golang:1.26.0-alpine
- **Runtime**: alpine (latest)

## Notes

- This is the Community Edition (CE) version without licensing modules
- The image includes tzdata for timezone support
