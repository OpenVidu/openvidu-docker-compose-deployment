# TLS / Certificate Configuration

TLS is handled by the Caddy reverse proxy. Edit `caddy.yaml` to choose one of the following modes:

## Let's Encrypt (default)

Caddy automatically obtains and renews a certificate from Let's Encrypt. Port 80 must be open for the ACME HTTP challenge. No changes needed — this is the default configuration.

## Custom certificate

If you have your own certificate, place the files in the `owncert/` directory and uncomment the `load_files` block in `caddy.yaml`:

```yaml
tls:
  certificates:
    load_files:
      - certificate: "/owncert/fullchain.pem"
        key: "/owncert/privkey.pem"
        tags:
          - "{$DOMAIN_NAME}"
```

## Self-signed certificate

Not recommended for production. Uncomment the `internal` issuer block in `caddy.yaml`:

```yaml
tls:
  certificates:
    automate:
      - "{$DOMAIN_NAME}"
    automation:
      policies:
        - issuers:
            - module: internal
```
