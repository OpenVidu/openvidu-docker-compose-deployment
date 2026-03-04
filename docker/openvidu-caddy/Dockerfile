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

# Add support for timezone configuration
RUN apk add --no-cache tzdata

COPY --from=builder /workspace/caddy /bin/caddy

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Run the binary.
ENTRYPOINT ["/entrypoint.sh"]
