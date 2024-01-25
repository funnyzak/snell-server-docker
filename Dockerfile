FROM --platform=$BUILDPLATFORM alpine:3.19.0

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG SNELL_SERVER_VERSION=4.0.1
ARG SNELL_SERVER_DOWNLOAD_LINK

RUN case "${TARGETPLATFORM}" in \
    "linux/amd64") SNELL_SERVER_DOWNLOAD_LINK="https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-amd64.zip" ;; \
    "linux/arm64") SNELL_SERVER_DOWNLOAD_LINK="https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-aarch64.zip" ;; \
    "linux/arm/v7") SNELL_SERVER_DOWNLOAD_LINK="https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-armv7l.zip" ;; \
    *) echo "unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac


COPY entrypoint.sh /usr/bin/

ENV LANG=C.UTF-8
ENV PORT=12345
ENV PSK=
ENV OBFS=tls

RUN wget --no-check-certificate -O snell.zip ${SNELL_SERVER_DOWNLOAD_LINK} && \
    unzip snell.zip && \
    rm -f snell.zip && \
    chmod +x snell-server && \
    mv snell-server /usr/bin/ && \
    chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]