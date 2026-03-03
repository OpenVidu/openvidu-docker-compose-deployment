# OpenVidu Community Docker Compose Deployment

> [!WARNING]
> Work in progress.

This is a less opinionated and production ready version of the **OpenVidu Community Edition** Docker Compose deployment. It includes a custom-built Caddy reverse proxy with TLS termination and TURN multiplexing, and a pre-configured Prometheus + Grafana observability stack.

> [!NOTE]
> For more advanced setups take a look to [Deployment Types](https://openvidu.io/latest/docs/self-hosting/deployment-types/). These deployments support more dynamic configurations and multinode setups.

## Prerequisites

- **CPU**: 4 cores minimum
- **RAM**: 4 GB minimum
- **Storage**: 100 GB recommended if you plan to record rooms
- **Network**: Public IP address and a Fully Qualified Domain Name (FQDN) pointing to it
- **OS**: Linux
- **Software**: [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/) installed

### Port Rules

The following inbound ports must be open on your firewall:

**Mandatory**

| Protocol | Port | Purpose |
|----------|------|---------|
| TCP | 80 | HTTP to HTTPS redirect and Let's Encrypt certificate validation |
| TCP | 443 | LiveKit API, Dashboard, Meet, WHIP API, TURN with TLS |
| UDP | 443 | STUN/TURN over UDP |

**Optional**

| Protocol | Port | Purpose |
|----------|------|---------|
| TCP | 1935 | RTMP stream ingestion via Ingress |
| TCP | 7881 | WebRTC traffic over TCP |
| UDP | 7885 | WebRTC ingestion via WHIP protocol through Ingress |
| TCP | 9000 | MinIO API public access |

**Optimal performance**

| Protocol | Port | Purpose |
|----------|------|---------|
| UDP | 50000–60000 | Direct WebRTC UDP media traffic |

> [!NOTE]
> The UDP 50000–60000 range requires running OpenVidu in host network mode (see [Host network mode](#host-network-mode-for-openvidu) below).

Outbound traffic is typically unrestricted and requires no special configuration.

## Configuration

Configure all the following environment variables in the `.env` file before starting the deployment. All are mandatory except `MEET_INITIAL_API_KEY` and `MEET_BASE_PATH`, which have defaults.

**Mandatory variables**

| Variable | Description |
|----------|-------------|
| `DOMAIN_NAME` | Your FQDN (e.g. `example.com`) |
| `LIVEKIT_API_KEY` | LiveKit/OpenVidu API key |
| `LIVEKIT_API_SECRET` | LiveKit/OpenVidu API secret |
| `REDIS_PASSWORD` | Password for the Redis instance |
| `MINIO_ACCESS_KEY` | MinIO root username / S3 access key |
| `MINIO_SECRET_KEY` | MinIO root password / S3 secret key |
| `MONGO_ADMIN_USERNAME` | MongoDB admin username |
| `MONGO_ADMIN_PASSWORD` | MongoDB admin password |
| `DASHBOARD_ADMIN_USERNAME` | Username for the OpenVidu Dashboard |
| `DASHBOARD_ADMIN_PASSWORD` | Password for the OpenVidu Dashboard |
| `MEET_INITIAL_ADMIN_PASSWORD` | Initial admin password for OpenVidu Meet |
| `GRAFANA_ADMIN_USERNAME` | Grafana admin username |
| `GRAFANA_ADMIN_PASSWORD` | Grafana admin password |

**Optional variables**

| Variable | Default | Description |
|----------|---------|-------------|
| `MEET_INITIAL_API_KEY` | _(empty)_ | Initial API key for OpenVidu Meet. By default, no API key is set. |
| `MEET_BASE_PATH` | `/meet` | Base path where OpenVidu Meet is served |

## Usage

Clone the repository and enter the directory:

```bash
git clone https://github.com/OpenVidu/openvidu-docker-compose-deployment.git --branch <version>
cd openvidu-docker-compose-deployment
```

### Normal mode (bridge networking)

```bash
docker compose up -d
```

### Host network mode for openvidu

Runs the `openvidu` container with `network_mode: host`, which can improve WebRTC performance by removing NAT layers for the media server.

```bash
docker compose -f docker-compose.yml -f docker-compose.host.yaml up -d
```

## Further Reading

- [TLS / Certificate Configuration](docs/tls-configuration.md)
- [Data Persistence](docs/data-persistence.md)
