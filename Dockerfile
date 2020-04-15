FROM funnyzak/alpine-glibc

LABEL org.label-schema.vendor="potato<silenceace@gmail.com>" \
    org.label-schema.name="Snell Server" \
    org.label-schema.description="This image is based on Alpine Linux image, which is only a 9MB image, and contains Snell Server." \
    org.label-schema.url="https://yycc.me" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/funnyzak/snell-server-docker" 


ARG SNELL_SERVER_PACKAGE=https://github.com/surge-networks/snell/releases/download/v2.0.1/snell-server-v2.0.1-linux-amd64.zip

ENV LANG=C.UTF-8
ENV PORT=12345
ENV PSK=
ENV OBFS=tls

COPY entrypoint.sh /usr/bin/

RUN wget --no-check-certificate -O snell.zip $SNELL_SERVER_PACKAGE && \
    unzip snell.zip && \
    rm -f snell.zip && \
    chmod +x snell-server && \
    mv snell-server /usr/bin/ && \
    chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]