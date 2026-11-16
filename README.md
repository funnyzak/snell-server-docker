# Snell Server Docker

Docker packaging for the official [Snell Server](https://kb.nssurge.com/surge-knowledge-base/zh/release-notes/snell) binaries. This repository contains the Dockerfile and startup script, not the Snell protocol implementation. Published images are built by [docker-release](https://github.com/funnyzak/docker-release/tree/main/Docker/snell-server); changes here must also be synchronized there before they appear in published images.

## Versions and architectures

| Image tag | Channel | Linux architectures |
| --- | --- | --- |
| `5.0.1` | Stable; default build version | `amd64`, `arm64`, `arm/v7`, `386` |
| `latest` | Tracks the stable release, currently `5.0.1` | Same as the stable release |
| `6.0.0` | Explicit opt-in Beta | `amd64`, `arm64`, `386` |

Snell 6 is still **Beta** according to the [upstream release notes](https://kb.nssurge.com/surge-knowledge-base/zh/release-notes/snell). It may receive incompatible protocol changes. Keep the client and server compatible; do not assume a v4/v5 client works with v6. ARMv7 is not available for 6.0.0. Version 6 also removes v5's QUIC Proxy Mode.

Use a fixed version tag for predictable deployments. `latest` is a moving tag; `nightly` is for development and is not a stable release or a guarantee of multi-architecture availability.

Supported registry locations:

```sh
docker pull funnyzak/snell-server:5.0.1
docker pull ghcr.io/funnyzak/snell-server:5.0.1
```

The former Aliyun mirror is not listed because its current version and synchronization status have not been verified.

## Quick start

Generate a unique PSK rather than copying a shared example. Keep it in a password manager or a protected local file. Do not share it in support logs.

```sh
export PSK="$(openssl rand -hex 16)"
docker run -d --name snell-server --restart unless-stopped \
  -e PSK -p 12303:6180/tcp funnyzak/snell-server:5.0.1
```

Configure the client with the same PSK and the host's port **12303**. Snell listens on port **6180 inside the container**. Allow only the required traffic in your host firewall.

## Docker Compose

Create a local `.env` file with a unique `PSK` value, protect its permissions, and exclude it from version control. The image version can be overridden with `SNELL_VERSION`.

```yaml
services:
  snell:
    image: funnyzak/snell-server:${SNELL_VERSION:-5.0.1}
    container_name: snell-server
    environment:
      PSK: ${PSK:?Set a unique PSK in your local environment or .env file}
      TZ: "Asia/Shanghai"
      IPV6: "false"
      PORT: "6180"
      # EGRESS_INTERFACE: "eth0"
    restart: unless-stopped
    ports:
      - "12303:6180/tcp"
```

Run `docker compose up -d`. The rebuilt stable image and builds from this source include Tini to forward stop signals and reap child processes, so an additional `init: true` or `--init` is not required. Environment-based settings apply **only when `/etc/snell-server.conf` does not already exist**. Changing an environment variable does not overwrite an existing configuration file.

## Configuration and persistence

| Variable | Default | Meaning |
| --- | --- | --- |
| `PSK` | Random 32-character hexadecimal value | Authentication key, shared with the client; older images may generate a different length |
| `PORT` | `6180` | IPv4 listen port inside the container |
| `IPV6` | `false` | Snell's IPv6 option; does not change this script's IPv4 listen address |
| `EGRESS_INTERFACE` | Unset | Optional outbound interface inside the container, not the host interface |
| `TZ` | `Asia/Shanghai` | Container timezone setting |

The upstream `egress-interface` option requires suitable privileges and routes. Do not add broad container privileges merely to enable it; validate the required permissions in your deployment.

For persistent, custom settings, create `snell-server.conf` on the host first, with a private random PSK:

```ini
[snell-server]
listen = 0.0.0.0:6180
psk = REPLACE_WITH_YOUR_UNIQUE_PSK
ipv6 = false
```

Then mount that existing file read-only:

```yaml
    volumes:
      - ./snell-server.conf:/etc/snell-server.conf:ro
```

A mounted configuration takes precedence over environment variables. Protect this file, back it up securely, and do not commit it. Without a mounted file or an explicit reusable PSK, **recreating** the container generates a new key and the client must be updated. Restarting the same container preserves its writable configuration.

**The stable `5.0.1` and `latest` images rebuilt on 2026-11-16** omit credentials from startup logs, generate configuration files with mode `600`, and include Tini. Existing containers must be pulled and recreated to receive these changes. Builds from this repository include the same protections.

**The previously published `6.0.0` Beta image has not been rebuilt with these fixes**: it may print the PSK/configuration to logs and does not include Tini. Do not assume the stable image fixes apply to that tag. Prefer stable for deployment; for Beta evaluation, build from this revised source. If an older image exposed a PSK in shared logs, rotate that key and update clients.

If a key was auto-generated, retrieve it locally with `docker exec snell-server cat /etc/snell-server.conf` and store it securely before recreating the container. This command displays a secret; do not paste its output into public logs.

## Surge client

For stable 5.0.1 with a v5-capable client:

```ini
[Proxy]
Proxy-Snell = snell, YOUR_SERVER_HOST, 12303, psk=YOUR_UNIQUE_PSK, version=5
```

v5 servers also support v4 clients (`version=4`), without v5 QUIC Proxy Mode. To use v5 QUIC Proxy Mode, also publish `12303:6180/udp` and allow the required UDP traffic; ordinary UDP forwarding uses UDP over TCP.

For explicit 6.0.0 Beta use `version=6`. The [Surge manual](https://manual.nssurge.com/policies/snell.html) lists v6 support from iOS 5.20.0 and Mac 6.7.0 and warns about incompatible Beta updates. Validate your client version before changing the server. The image leaves v6's encrypted default mode enabled; this guide does not enable `unsafe-raw`.

## Upgrade and rollback

1. Back up your configuration and PSK securely, and record the current image tag or digest.
2. Choose a compatible fixed tag in Compose, then run `docker compose pull && docker compose up -d`.
3. Check `docker compose ps`, startup logs, and an actual client connection.
4. To roll back, restore the previous tag and matching configuration/client protocol, then recreate the container. `docker compose restart` alone does not switch images.

Do not automatically upgrade stable deployments to the v6 Beta tag. A container starting successfully does not prove client connectivity.

## Local build

```sh
# Stable, for the local host architecture
docker build -t snell-server:local .
docker run --rm --entrypoint /opt/snell-server/snell-server snell-server:local --version

# Beta, explicitly selected
docker build --build-arg VERSION=6.0.0 -t snell-server:beta-local .

# Multi-platform validation (no registry push)
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/386 \
  --build-arg VERSION=5.0.1 .
```

For Beta multi-platform builds, omit `linux/arm/v7`. Downloads use HTTPS certificate verification. Upstream binaries and build dependencies still need network access. This repository has no release automation; publishing is managed in `docker-release`.

## License

The [MIT license](LICENSE) covers this repository's original Docker packaging scripts and documentation. Snell Server is an upstream binary from Surge Networks, governed by its own terms; this repository does not grant an MIT license to that binary.
