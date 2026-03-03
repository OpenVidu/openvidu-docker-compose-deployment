# Data Persistence

All stateful data is stored in standard Docker named volumes:

| Volume | Service | Contents |
|--------|---------|----------|
| `caddy-data` | caddy-proxy | TLS certificates and ACME account data |
| `caddy-config` | caddy-proxy | Caddy runtime configuration |
| `redis-data` | redis | LiveKit runtime state |
| `minio-data` | minio | **Critical** — recordings produced by egress and application data |
| `minio-certs` | minio | MinIO TLS certificates |
| `mongo-data` | mongo | **Critical** — OpenVidu Meet data and all data shown in the Dashboard |
| `egress-data` | egress | Temporary egress output files |
| `prometheus-data` | prometheus | Metrics time-series data (useful for observability) |
| `loki-data` | loki | Aggregated container logs (useful for observability) |
| `grafana-data` | grafana | Dashboards and Grafana configuration (useful for observability) |

> [!WARNING]
> Do not remove these volumes unless you intend to permanently delete all data. Avoid running `docker compose down -v`. Back up `minio-data` and `mongo-data` regularly to prevent loss of recordings and application data.
