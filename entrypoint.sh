#!/bin/bash

BIN="/opt/snell-server/snell-server"
CONF="/etc/snell-server.conf"

run() {
  # 打印作者和版本信息
  echo -e "Snell-Server\n"
  echo -e "Image: https://hub.docker.com/r/funnyzak/snell-server"
  echo -e "GitHub: https://github.com/funnyzak/snell-server\n"

  echo -e "Starting snell-server ${VERSION}...\n"

  if [ ! -f ${CONF} ]; then
    PSK=${PSK:-$(tr -dc A-Za-z0-9 </dev/urandom | head -c 31)}
    PORT=${PORT:-6180}
    IPV6=${IPV6:-false}
    EGRESS_INTERFACE=${EGRESS_INTERFACE:-}

    echo "Using PSK: ${PSK}"
    echo "Using port: ${PORT}"
    echo "Using ipv6: ${IPV6}"
    if [ -n "${EGRESS_INTERFACE}" ]; then
      echo "Using egress-interface: ${EGRESS_INTERFACE}"
    fi

    echo "Generating new config..."
    cat << EOF > ${CONF}
[snell-server]
listen = 0.0.0.0:${PORT}
psk = ${PSK}
ipv6 = ${IPV6}
EOF

    if [ -n "${EGRESS_INTERFACE}" ]; then
      echo "egress-interface = ${EGRESS_INTERFACE}" >> ${CONF}
    fi
  fi

  echo "Config:"
  cat ${CONF}
  echo ""

  ${BIN} -c ${CONF}
}

run
