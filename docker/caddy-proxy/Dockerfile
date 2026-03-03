FROM golang:1.26.0-alpine AS builder

ARG TARGETOS
ARG TARGETPLATFORM
ARG TARGETARCH

# --------------------
# By default xcaddy always uses the latest commit to build its modules.
# Context:
# https://caddy.community/t/question-regarding-caddy-xcaddy-modules-and-versioning/24584/2
#
# The following declared versions allows to build caddy with fixed versions
# which is useful for reproducibility and stability.
ARG CADDY_VERSION="v2.11.1"
ARG XCADDY_VERSION="v0.4.5"
# Modules versions
ARG CADDY_YAML="v0.0.0-20210522210701-64fbdd07cf02"
ARG CADDY_L4="v0.0.0-20260216070754-eca560d759c9"
ENV CADDY_VERSION=$CADDY_VERSION \
    XCADDY_VERSION=$XCADDY_VERSION \
    CADDY_YAML=$CADDY_YAML \
    CADDY_L4=$CADDY_L4

RUN echo building caddy $CADDY_VERSION for "$TARGETOS"
# ---------------------

WORKDIR /workspace

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@"$XCADDY_VERSION"

RUN GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
    --with github.com/abiosoft/caddy-yaml@"$CADDY_YAML" \
    --with github.com/mholt/caddy-l4@"$CADDY_L4"

FROM alpine

RUN apk add --no-cache \
	ca-certificates \
	curl \
	libcap \
	mailcap \
    tzdata

RUN set -eux; \
    mkdir -p \
        /config/caddy \
        /data/caddy \
        /etc/caddy \
        /usr/share/caddy

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

COPY --from=builder /workspace/caddy /bin/caddy

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp

WORKDIR /srv

# Run the binary.
CMD ["caddy", "run", "--config", "/etc/caddy/caddy.yaml", "--adapter", "yaml"]
