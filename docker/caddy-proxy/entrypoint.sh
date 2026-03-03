#!/bin/sh
set -e

if [ -z "$DOMAIN_NAME" ]; then
    echo "ERROR: DOMAIN_NAME environment variable is not set" >&2
    exit 1
fi

sed "s/__DOMAIN_NAME__/${DOMAIN_NAME}/g" /etc/caddy/caddy.yaml > /tmp/caddy-resolved.yaml

exec caddy run --config /tmp/caddy-resolved.yaml --adapter yaml
