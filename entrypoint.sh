#!/bin/bash

BIN="/app/snell-server"
CONF="/app/snell-server.conf"

run() {
  if [ ! -f ${CONF} ]; then
    PSK=${PSK:-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 31)}
    PORT=${PORT:-6180}
    IPV6=${IPV6:-false}

    echo "Using PSK: ${PSK}"
    echo "Using port: ${PORT}"
    echo "Using ipv6: ${IPV6}"

    echo "Generating new config..."
    cat << EOF > ${CONF}
[snell-server]
listen = 0.0.0.0:${PORT}
psk = ${PSK}
ipv6 = ${IPV6}
${OBFS:+obfs = ${OBFS}}
${REUSE:+reuse = ${REUSE}}
${OBFSHOST:+obfs-host = ${OBFSHOST}}
${OBFSURI:+obfs-uri = ${OBFSURI}}
EOF
  fi
  echo -e "Starting snell-server...\n"
  echo "Config:"
  cat ${CONF}
  echo ""
  ${BIN} -c ${CONF}
}

run
