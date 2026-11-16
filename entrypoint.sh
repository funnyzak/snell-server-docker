#!/bin/bash
set -eu

BIN="/opt/snell-server/snell-server"
CONF="/etc/snell-server.conf"

printf 'Starting Snell Server %s\n' "${VERSION:-unknown}"
printf 'Source: https://github.com/funnyzak/snell-server-docker\n'

if [ ! -f "$CONF" ]; then
  PSK=${PSK:-$(od -An -N16 -tx1 /dev/urandom | tr -d ' \n')}
  PORT=${PORT:-6180}
  IPV6=${IPV6:-false}
  EGRESS_INTERFACE=${EGRESS_INTERFACE:-}

  # Environment values must not inject additional configuration lines.
  for value in "$PSK" "$PORT" "$IPV6" "$EGRESS_INTERFACE"; do
    case "$value" in
      *$'\n'*|*$'\r'*) echo "Configuration values must be single-line" >&2; exit 1 ;;
    esac
  done
  umask 077
  cat > "$CONF" <<CONFIG
[snell-server]
listen = 0.0.0.0:${PORT}
psk = ${PSK}
ipv6 = ${IPV6}
CONFIG
  if [ -n "$EGRESS_INTERFACE" ]; then
    printf 'egress-interface = %s\n' "$EGRESS_INTERFACE" >> "$CONF"
  fi
  echo "Created configuration. Keep the PSK secure and persist it before recreating the container."
else
  echo "Using existing configuration; environment settings do not override it."
fi

# Never write the PSK or complete configuration into container logs.
exec "$BIN" -c "$CONF" "$@"
