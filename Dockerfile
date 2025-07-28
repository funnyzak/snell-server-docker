FROM --platform=$BUILDPLATFORM alpine AS builder

ARG VERSION=5.0.0
ARG TARGETPLATFORM

WORKDIR /opt/snell-server

RUN apk add --no-cache wget unzip && \
    case "${TARGETPLATFORM}" in \
        "linux/amd64") ARCH="amd64" ;; \
        "linux/arm64") ARCH="aarch64" ;; \
        "linux/arm/v7") ARCH="armv7l" ;; \
        "linux/386") ARCH="i386" ;; \
        *) echo "unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac && \
    wget --no-check-certificate -O snell.zip "https://dl.nssurge.com/snell/snell-server-v${VERSION}-linux-${ARCH}.zip" && \
    unzip snell.zip

FROM debian:stable-slim

ARG BUILD_DATE
ARG VERSION=5.0.0b1
ARG VCS_REF

LABEL org.label-schema.name="snell-server" \
      org.label-schema.description="snell server is a lean encrypted proxy protocol." \
      org.label-schema.version="${VERSION}" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.vendor="Leon<silenceace@gmail.com>" \
      org.label-schema.url="https://github.com/funnyzak/docker-release"

WORKDIR /opt/snell-server

COPY --from=builder /opt/snell-server/snell-server .
COPY entrypoint.sh .

RUN chmod +x snell-server entrypoint.sh

ENV LANG=C.UTF-8 \
    VERSION=${VERSION} \
    TZ=Asia/Shanghai \
    PORT=6180 \
    IPV6=false \
    PSK= \
    EGRESS_INTERFACE=

EXPOSE ${PORT}/tcp

ENTRYPOINT ["/opt/snell-server/entrypoint.sh"]
