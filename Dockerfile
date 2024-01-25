FROM --platform=$BUILDPLATFORM funnyzak/alpine-glibc

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG SNELL_SERVER_VERSION=4.0.1

ENV SNELL_SERVER_DOWNLOAD_LINK=

RUN case "${TARGETPLATFORM}" in \
    "linux/amd64") wget --no-check-certificate -O snell.zip "https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-amd64.zip" ;; \
    "linux/arm64") wget --no-check-certificate -O snell.zip "https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-aarch64.zip" ;; \
    "linux/arm/v7") wget --no-check-certificate -O snell.zip "https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-armv7l.zip" ;; \
    *) echo "unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac

COPY entrypoint.sh /usr/bin/

RUN unzip snell.zip && \
    rm -f snell.zip && \
    chmod +x snell-server && \
    mv snell-server /usr/bin/ && \
    chmod +x /usr/bin/entrypoint.sh

ENV LANG=C.UTF-8

ENV SNELL_SERVER_VERSION=${SNELL_SERVER_VERSION}
ENV PORT=6180
ENV IPV6=false
ENV PSK=

ENTRYPOINT ["entrypoint.sh"]