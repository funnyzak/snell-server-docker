# Snell Server Docker

[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/snell-server.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/snell-server/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/snell-server.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/snell-server/)

This image is based on Alpine Linux image, which is only a 9MB image, and contains Snell Server (**v2.1.0b1**).

Download size of this image is only:

[![](https://images.microbadger.com/badges/image/funnyzak/snell-server.svg)](http://microbadger.com/images/funnyzak/snell-server "Get your own image badge on microbadger.com")

[Docker hub image: funnyzak/snell-server](https://hub.docker.com/r/funnyzak/snell-server)

Docker Pull Command: `docker pull funnyzak/snell-server`

---

## Display Conf

```sh
docker exec snell-server cat /etc/snell/snell-server.conf
```

---

## Usage Example

Here is an example configuration of Docker and Docker Compse.

### Docker Run

```Docker
docker run -d --name snell-server --restart always \
-p 1002:12345 -e PSK="5G0H4qdf32mEZx32t" -e OBFS="tls" funnyzak/snell-server
```

### Compose

```docker
version: '3'
services:
  server:
    image: funnyzak/snell-server
    container_name: snell-server
    logging:
      driver: "json-file"
      options:
        max-size: "1g"
    environment:
      PSK: 5G0H4qdf32mEZx32t
      OBFS: tls
    tty: true
    restart: always
    ports:
      - 1002:12345
    volumes:
      - ./conf:/etc/snell
```

---

## Related Link

* https://github.com/surge-networks/snell
