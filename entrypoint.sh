#!/bin/ash

BIN="/usr/bin/snell-server"
CONF="/etc/snell/snell-server.conf"

run() {
  if [ ! -f ${CONF} ]; then
    if [ -z ${PSK} ]; then
      PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 31)
      echo "Using generated PSK: ${PSK}"
    else
      echo "Using predefined PSK: ${PSK}"
    fi
    if [ -z ${PORT} ]; then
      PORT=6180
      echo "Using default port: ${PORT}"
    else
      echo "Using predefined port: ${PORT}"
    fi
    if [ -z ${IPV6} ]; then
      IPV6=false
      echo "Using default ipv6: ${IPV6}"
    else
      echo "Using predefined ipv6: ${IPV6}"
    fi
    echo "Generating new config..."
    mkdir /etc/snell/
    echo "[snell-server]" >> ${CONF}
    echo "listen = 0.0.0.0:${PORT}" >> ${CONF}
    echo "psk = ${PSK}" >> ${CONF}
    echo "ipv6 = ${IPV6}" >> ${CONF}
  fi
  echo -e "Starting snell-server...\n"
  echo "Config:"
  cat ${CONF}
  echo ""
  ${BIN} -c ${CONF}
}

run