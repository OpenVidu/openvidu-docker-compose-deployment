#!/bin/sh
set -e

# If non opinionated compose mode, launch with entrypoint
if [ "$NON_OPINIONATED_COMPOSE_MODE" = "true" ]; then
    if [ -z "$DOMAIN_NAME" ]; then
        echo "ERROR: DOMAIN_NAME environment variable is not set" >&2
        exit 1
    fi
    sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" /etc/caddy/caddy.yaml > /tmp/caddy-resolved.yaml

    exec caddy run --config /tmp/caddy-resolved.yaml --adapter yaml
fi

# Otherwise, launch with command line arguments (Community Single Node)
exec caddy "$@"