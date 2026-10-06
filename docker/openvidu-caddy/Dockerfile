FROM golang:1.26.8-alpine AS builder

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
ARG CADDY_VERSION="v2.11.4"
ARG XCADDY_VERSION="v0.4.7"

# Modules versions
ARG CADDY_YAML="v0.0.0-20210522210701-64fbdd07cf02"
# Fork of mholt/caddy-l4 (v0.1.2) that sends a TCP FIN after close_notify when
# the proxy half-closes a TLS connection, and adds the proxy half_close_timeout
# and tls handshake_timeout options. The version is the pseudo-version of
# OpenVidu/caddy-l4 main.
ARG CADDY_L4="v0.0.0-20261005191601-680d23b981d4"
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
    --with github.com/mholt/caddy-l4=github.com/OpenVidu/caddy-l4@"$CADDY_L4"

FROM alpine

# Add support for timezone configuration
RUN apk add --no-cache tzdata

COPY --from=builder /workspace/caddy /bin/caddy

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run the binary.
ENTRYPOINT ["/entrypoint.sh"]
