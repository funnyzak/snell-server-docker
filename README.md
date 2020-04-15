# Snell Server Docker

## [Docker hub image: funnyzak/snell-server](https://hub.docker.com/r/funnyzak/snell-server)


### Pull Command: `docker pull funnyzak/snell-server`

---

## Docker Compose

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
      PORT: 1002
      PSK: 5G0H4qdf32mEZx32t
      OBFS: tls
    tty: true
    restart: always
    ports:
      - 1002:1002
    volumes:
      - ./conf:/etc/snell
```

---

## Link

* https://github.com/surge-networks/snell
