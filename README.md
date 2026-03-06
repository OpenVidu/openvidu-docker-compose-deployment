# OpenVidu Community Docker Compose Deployment

This is the **OpenVidu Community Edition** Single Node deployment based on plain Docker Compose.

## Table of Contents

- [Installer vs Plain Docker Compose](#openvidu-ce-single-node-deployment-with-installer-vs-openvidu-ce-single-node-deployment-based-on-plain-docker-compose)
- [Plain Docker Compose vs Local Deployment](#openvidu-ce-single-node-deployment-with-plain-docker-compose-vs-openvidu-local-deployment)
- [Prerequisites](#prerequisites)
  - [Port Rules](#port-rules)
- [Deployment](#deployment)
- [Configuration](#configuration)
- [Starting the Deployment](#starting-the-deployment)
  - [Launching with Agents](#launching-with-agents)
- [Deploying a Web Application on the Same Server](#deploying-a-web-application-on-the-same-server)
- [What to Do If You Don't Have a Domain Name](#what-to-do-if-you-dont-have-a-domain-name)
- [Advanced Configurations](#advanced-configurations)
  - [Non Network Host Mode for OpenVidu](#non-network-host-mode-for-openvidu)
- [TLS / Certificate Configuration](#tls--certificate-configuration)
  - [Custom Certificate](#custom-certificate)
  - [Self-Signed Certificate](#self-signed-certificate)
- [Data Persistence](#data-persistence)
- [Optimizing Network Buffers](#optimizing-network-buffers)


## OpenVidu CE single node deployment with installer vs OpenVidu CE single node deployment based on plain Docker Compose

The recommended way to deploy OpenVidu CE single node is using the [installers](https://openvidu.io/latest/docs/self-hosting/single-node/), which provides a streamlined experience with a guided setup and configuration process. The installer is ideal for users who want a quick and easy deployment without needing to manage individual components.

The plain Docker Compose deployment, on the other hand, offers more flexibility and control over the individual services and their configurations. It is suitable for users who are comfortable with Docker and want to customize their deployment or integrate additional services.

Features included in OpenVidu CE single node deployment with installer but not in plain Docker Compose deployment:
* Guided setup and configuration process
* OpenVidu is configured as a systemd service for easier management (which implies a better logging and monitoring experience)
* OpenVidu Agents are easier to set (just editing agent.yml file)
* It is more integrated with cloud services (e.g. easier to use cloud storage for recordings)
* Documentation is more focused on the installer deployment, so some features may be better explained in that context.
* It is easier to keep the deployment up to date with the latest OpenVidu releases, as the installer can handle updates more seamlessly using the [upgrade](https://openvidu.io/latest/docs/self-hosting/single-node/on-premises/upgrade/) process, while the plain Docker Compose deployment may require manual updates to the Docker images and configurations.

## OpenVidu CE single node deployment with plain Docker Compose vs OpenVidu Local Deployment

The recommended way to develop with OpenVidu in a local environment is using the [OpenVidu Local Deployment](https://openvidu.io/latest/docs/self-hosting/local/), which is designed for development and testing purposes. It provides a simplified setup and it is easy to test in the local network.

The plain Docker Compose deployment is more suitable for production environments or for users who want to deploy a production setup. It also includes services like Grafana for monitoring, which are not included in the local deployment.

## Prerequisites

- **CPU**: 4 cores minimum
- **RAM**: 4 GB minimum
- **Storage**: 100 GB recommended if you plan to record rooms
- **Network**: Public IP address
- **OS**: Linux (Ubuntu 24.04 or later recommended)
- **Software**: [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/)

### Port Rules

The following inbound ports must be open on your firewall:

**Mandatory**

| Protocol | Port | Purpose |
|----------|------|---------|
| TCP | 80 | HTTP to HTTPS redirect and Let's Encrypt certificate validation |
| TCP | 443 | LiveKit API, Dashboard, Meet, WHIP API, TURN with TLS |
| UDP | 443 | STUN/TURN over UDP |

*Recommended for optimal experience*

| Protocol | Port | Purpose |
|----------|------|---------|
| UDP | 50000–60000 | Direct WebRTC UDP media traffic |
| TCP | 7881 | WebRTC traffic over TCP |

**Depending on used features**

| Protocol | Port | Purpose |
|----------|------|---------|
| TCP | 1935 | RTMP stream ingestion via Ingress |
| UDP | 7885 | WebRTC ingestion via WHIP protocol through Ingress |
| TCP | 9000 | MinIO API public access |

Outbound traffic is typically unrestricted and requires no special configuration.

## Deployment

Clone the repository and enter the directory:

```bash
git clone https://github.com/OpenVidu/openvidu-docker-compose-deployment.git --branch 3.6.0
cd openvidu-docker-compose-deployment
```

For a different version, simply change the branch name in the command above to the desired version (this deployment is available since version 3.6.0 you can check the [releases](https://github.com/OpenVidu/openvidu-docker-compose-deployment/releases) for the available versions).

## Configuration

You must configure the following environment variables in the `.env` file before starting the deployment (or it will fail).

**Mandatory variables**

| Variable | Description |
|----------|-------------|
| `DOMAIN_NAME` | A FQDN pointing your public IP (e.g. `example.com`). If you don't have one check [this section](#what-to-do-if-you-dont-have-a-domain-name) |
| `MEET_INITIAL_ADMIN_PASSWORD` | Initial admin password for OpenVidu Meet |
| `LIVEKIT_API_KEY` | LiveKit/OpenVidu API key |
| `LIVEKIT_API_SECRET` | LiveKit/OpenVidu API secret |
| `REDIS_PASSWORD` | Password for the Redis instance |
| `MINIO_ACCESS_KEY` | MinIO root username |
| `MINIO_SECRET_KEY` | MinIO root password |
| `MONGO_ADMIN_USERNAME` | MongoDB admin username |
| `MONGO_ADMIN_PASSWORD` | MongoDB admin password |
| `DASHBOARD_ADMIN_USERNAME` | Username for the OpenVidu Dashboard |
| `DASHBOARD_ADMIN_PASSWORD` | Password for the OpenVidu Dashboard |
| `GRAFANA_ADMIN_USERNAME` | Grafana admin username |
| `GRAFANA_ADMIN_PASSWORD` | Grafana admin password |

**Optional variables**

| Variable | Default | Description |
|----------|---------|-------------|
| `MEET_INITIAL_API_KEY` | _(empty)_ | Initial API key for OpenVidu Meet. By default, no API key is set. |
| `MEET_BASE_PATH` | `/meet` | Base path where OpenVidu Meet is served |

## Starting the Deployment

Execute the following command to start the deployment in detached mode:

```bash
docker compose up -d
```

> NOTE: If you want an optimal WebRTC performance, it is recommended to optimize the network buffers on the host before starting the stack. Check [this section](#optimizing-network-buffers) for instructions.

Wait until all containers are up and running (you can check with `docker compose ps`).

Then access the OpenVidu Meet at:

```
https://DOMAIN_NAME/
```

Log in with the `admin` user and `MEET_INITIAL_ADMIN_PASSWORD` password you set in `.env` file.

### Launching with Agents

For a full overview of OpenVidu Agents, see the [OpenVidu Agents documentation](https://openvidu.io/latest/docs/ai/openvidu-agents/overview/#basic-concepts).

OpenVidu Agents are optional components that provide additional processing capabilities (e.g. speech-to-text) and can be enabled or disabled independently of the main OpenVidu services.

Every agent is deployed as a service specified in the `docker-compose.agents.yaml` file.

To execute OpenVidu with the default speech-processing agent, you just have to adapt the default configuration for your use case in `agent-speech-processing.yaml` file and specify the docker image to use for the agent in the `docker-compose.agents.yaml` file.

Then, include the agents docker-compose in the launch command:

```bash
docker compose -f docker-compose.yaml -f docker-compose.agents.yaml up -d
```

To add more agents follow these instructions:
* Create a configuration file for the agent (for example `agent-<agent-name>.yaml`).
* Create a new service definition in `docker-compose.agents.yaml` (copy and paste the existing one for the speech-processing agent) and change its name.
* Change the docker image to point to the new agent docker image.
* Adapt the volume to point to the new agent configuration file you created in the first step.

## Deploying a web application on the same server

To deploy a web application you just have to have it listening on **port 6080**. It can be deployed based on Docker or natively on the host.

Then the web application will be accessible in server base path (`/`) and OpenVidu Meet will still be available at `/meet`.

## What to do if you don't have a domain name

If you don't have a domain name, you can use [sslip.io](https://sslip.io), a public DNS service that automatically resolves any hostname containing an embedded IP address back to that IP — no DNS registration or configuration required.

To form your domain name, replace the dots in your server's public IP address with dashes and append `-openvidu.sslip.io`. For example, if your public IP is `1.2.3.4`:

```
DOMAIN_NAME=1-2-3-4-openvidu.sslip.io
```

Set this value in your `.env` file and Let's Encrypt will automatically issue a valid TLS certificate for the domain.

## Advanced Configurations

### Non network host mode for OpenVidu

By default, OpenVidu is deployed with the `host` network mode, which can improve WebRTC performance by removing NAT layers for the media server. However, if you want to run OpenVidu in a more isolated network environment, you can use the default bridge network mode.

Simply execute the following command to start the deployment without host network mode:

```bash
docker compose -f docker-compose.yaml -f docker-compose.bridge.yaml up -d
```

## TLS / Certificate Configuration

By default, OpenVidu uses a certificate generated using Let's Encrypt.

If you want to use your own certificate or a self-signed one, you can configure the Caddy reverse proxy to use it. Edit `caddy.yaml` and follow the instructions in the file to choose the desired TLS mode.

### Custom Certificate

If you have your own certificate:
* Create the folder `owncert` if it doesn't exist.
* Place the certificate files in `owncert/fullchain.pem` and `owncert/privkey.pem` paths.
* Comment the existing `tls` block in `caddy.yaml` to disable Let's Encrypt certificate management.
* Uncomment the `Own certificate` section block in `caddy.yaml`:

```yaml
# Own certificate...
tls:
  certificates:
    load_files:
      - certificate: "/owncert/fullchain.pem"
        key: "/owncert/privkey.pem"
        tags:
          - "__DOMAIN_NAME__"
```

### Self-Signed Certificate

If you want Caddy to generate a self-signed certificate internally (no CA required):
* Comment the existing `tls` block in `caddy.yaml` to disable Let's Encrypt certificate management.
* Uncomment the `Self-signed certificate` section block in `caddy.yaml`:

```yaml
# Self-signed certificate...
tls:
  certificates:
    automate:
      - "__DOMAIN_NAME__"
  automation:
    policies:
      - issuers:
          - module: internal
```

> **Note:** Self-signed certificates are not trusted by browsers and will cause security warnings. This option is not recommended for production use.

## Data Persistence

OpenVidu data is stored in standard Docker named volumes.

The data needed to migrate OpenVidu to a new server or to back up your data is stored in these volumes:

| Volume | Service | Contents |
|--------|---------|----------|
| `minio-data` | minio | Recordings produced by egress and application data |
| `mongo-data` | mongo | OpenVidu Meet data and all data shown in the Dashboard |

Other volumes store data that is not critical for the operation of OpenVidu and will be recreated if removed, but can be useful for observability and monitoring purposes:

| Volume | Service | Contents |
|--------|---------|----------|
| `caddy-data` | openvidu-caddy | TLS certificates and ACME account data |
| `caddy-config` | openvidu-caddy | Caddy runtime configuration |
| `redis-data` | redis | OpenVidu runtime state |
| `minio-certs` | minio | MinIO TLS certificates |
| `egress-data` | egress | Temporary egress output files |
| `prometheus-data` | prometheus | Metrics time-series data (useful for observability) |
| `loki-data` | loki | Aggregated container logs (useful for observability) |
| `grafana-data` | grafana | Dashboards and Grafana configuration (useful for observability) |

## Optimizing Network Buffers

For production deployments, it is recommended to increase the kernel's network buffer sizes on the host before starting the stack. WebRTC relies heavily on UDP for real-time audio and video transport, and the default Linux kernel buffer sizes are tuned for general-purpose workloads. Under high media load this can cause packet drops and jitter.

Run the provided script as root on the host:

```bash
sudo sh config_network_buffer.sh
```

This raises the maximum and default socket buffer sizes and sets a minimum floor for UDP buffers so they cannot shrink under pressure. The settings are applied immediately and persisted across reboots via `/etc/sysctl.d/50-openvidu.conf`. See the inline comments in the script for a description of each parameter.
