#!/bin/ash

BIN="/usr/bin/snell-server"
CONF="/etc/snell/snell-server.conf"

# reuse existing config when the container restarts
run() {
  if [ -f ${CONF} ]; then
    echo "Found existing config..."
  else
    if [ -z ${PSK} ]; then
      PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 31)
      echo "Using generated PSK: ${PSK}"
    else
      echo "Using predefined PSK: ${PSK}"
    fi
    echo "Generating new config..."
    mkdir /etc/snell/
    echo "[snell-server]" >> ${CONF}
    echo "listen = 0.0.0.0:${PORT}" >> ${CONF}
    echo "psk = ${PSK}" >> ${CONF}
    echo "obfs = tls" >> ${CONF}
  fi
  ${BIN} -c ${CONF}
}

run