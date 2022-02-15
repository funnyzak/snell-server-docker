FROM funnyzak/alpine-glibc

ARG BUILD_DATE
ARG VCS_REF
ARG SNELL_SERVER_DOWNLOAD_VERSION=v3.0.1
ARG SNELL_SERVER_VERSION=v3.0.1

LABEL org.label-schema.vendor="funnyzak<silenceace@gmail.com>" \
    org.label-schema.name="Snell Server" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.description="This image is based on Alpine Linux image, which is only a 9MB image, and contains Snell Server." \
    org.label-schema.url="https://yycc.me" \
    org.label-schema.version="${SNELL_SERVER_VERSION}" \
    org.label-schema.schema-version="1.0"	\
    org.label-schema.docker.cmd="docker run -d --name snell-server --restart always -p 1002:12345 -e PSK=\"5G0H4qdf32mEZx32t\" -e OBFS=\"tls\" funnyzak/snell-server" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-ref="${VCS_REF}" \
    org.label-schema.vcs-url="https://github.com/funnyzak/snell-server-docker" 


ENV LANG=C.UTF-8
ENV PORT=12345
ENV PSK=
ENV OBFS=tls

COPY entrypoint.sh /usr/bin/

ARG SNELL_SERVER_PACKAGE=https://github.com/surge-networks/snell/releases/download/${SNELL_SERVER_VERSION}/snell-server-${SNELL_SERVER_DOWNLOAD_VERSION}-linux-amd64.zip

RUN wget --no-check-certificate -O snell.zip $SNELL_SERVER_PACKAGE && \
    unzip snell.zip && \
    rm -f snell.zip && \
    chmod +x snell-server && \
    mv snell-server /usr/bin/ && \
    chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]