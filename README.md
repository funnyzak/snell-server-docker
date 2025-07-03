# Snell Server

> This repository is no longer maintained. The latest built images can be found in the [Docker Release](https://github.com/funnyzak/docker-release?tab=readme-ov-file#snell-server). You can [create a new issue](https://github.com/funnyzak/docker-release/issues) on the repository if you have any questions.

[![Image Size](https://img.shields.io/docker/image-size/funnyzak/snell-server)](https://hub.docker.com/r/funnyzak/snell-server/)
[![Docker Stars](https://img.shields.io/docker/stars/funnyzak/snell-server.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/snell-server/)
[![Docker Pulls](https://img.shields.io/docker/pulls/funnyzak/snell-server.svg?style=flat-square)](https://hub.docker.com/r/funnyzak/snell-server/)
[![Docker Tags](https://img.shields.io/docker/v/funnyzak/snell-server?sort=semver&style=flat-square)](https://hub.docker.com/r/funnyzak/snell-server/)

This image is built for [snell server](https://manual.nssurge.com/others/snell.html), which is a lean encrypted proxy protocol. If you want to use **Snell Client**, please download from [NSSurge](https://nssurge.com/).

This image supports `linux/amd64`, `linux/arm64`, `linux/arm/v7` and `linux/386` architecture. The latest version is `v5.0.0b1`.

> The latest surge-server version is v4, which is not compatible with the previous versions like before. Please upgrade both the client (Surge iOS & Surge Mac) and the server binary.

## Docker Pull

```bash
docker pull funnyzak/snell-server
# GHCR
docker pull ghcr.io/funnyzak/snell-server
# Aliyun
docker pull registry.cn-beijing.aliyuncs.com/funnyzak/snell-server
```

## Docker Run

Your can run this image with the following command:

```bash
# One line command
docker run -d --name snell-server --restart always -p 12303:6180 -e PSK="5G0H4qdf32mEZx32t" funnyzak/snell-server

# Or with environment variables
docker run -d --name snell-server --restart always \
  -e PSK="5G0H4qdf32mEZx32t" \
  -e TZ="Asia/Shanghai" \
  -e IPV6="false" \
  -e PORT=6180 \
  -e EGRESS_INTERFACE="eth0" \
  -p 12303:6180 funnyzak/snell-server:latest
  
# Echo config file
docker exec -it snell-server cat /etc/snell-server.conf
```

Or you can use docker-compose to run this image:

```yaml
version: '3'
services:
  snell:
    image: funnyzak/snell-server
    container_name: snell-server
    environment:
      PSK: 5G0H4qdf32mEZx32t
      TZ: Asia/Shanghai
      IPV6: false
      PORT: 6180
      EGRESS_INTERFACE: eth0  # Optional: specify network interface for outbound connections
    restart: always
    ports:
      - 12303:6180
```


## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PSK` | Auto-generated | Pre-shared key for authentication |
| `PORT` | `6180` | Port number for the server to listen on |
| `IPV6` | `false` | Enable IPv6 support |
| `EGRESS_INTERFACE` | - | Network interface name for outbound connections (e.g., `eth0`, `wlan0`) |

## Surge Configuration

```ini
[Proxy]
Proxy = snell, 1.2.3.4, 6333, psk=RANDOM_KEY_HERE, version=4
```

## Reference

- [Snell Server](https://manual.nssurge.com/others/snell.html)
- [Snell Knowledge](https://kb.nssurge.com/surge-knowledge-base/zh/release-notes/snell)

## License

[MIT](LICENSE)