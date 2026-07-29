# Cfx Server Docker

Minimal Docker image for **Cfx Server / FiveM for GTAV Enhanced (early access)**.

- Cfx Server build `98-ea`
- txAdmin included
- MariaDB `12.3.2` included in the Compose setup
- Runs as non-root UID/GID `1000`
- Uses a narrow seccomp profile that permits only `io_uring_setup` and `io_uring_enter` beyond Docker's default profile

## Quick start

```bash
git clone https://github.com/itsmeares/cfx-server-docker.git
cd cfx-server-docker
cp .env.example .env
mkdir -p txData mariadb
```

Replace both password placeholders in `.env`, then start the stack:

```bash
docker compose up -d
```

Open txAdmin at:

```text
http://localhost:40120
```

Get the registration PIN:

```bash
docker compose logs cfx-server
```

## Database

MariaDB is available only on the internal Compose network. Port `3306` is not published to the host.

Use these values when a txAdmin recipe asks for database details:

| Field | Value |
| --- | --- |
| Database Host | `mariadb` |
| Database Port | `3306` |
| Database Username | Value of `MARIADB_USER` (`qbox` by default) |
| Database Password | Value of `MARIADB_PASSWORD` |
| Database Name | Value of `MARIADB_DATABASE` (`qbox` by default) |
| Delete Database | Off |

Framework recipes such as QBox import their own SQL files. This repository only provides the database service.

## CasaOS

Prepare the data directories and seccomp profile:

```bash
sudo install -d -o 1000 -g 1000 /DATA/AppData/cfx-server-docker/txData
sudo install -d /DATA/AppData/cfx-server-docker/mariadb
sudo curl -fsSL https://raw.githubusercontent.com/itsmeares/cfx-server-docker/main/seccomp.json \
  -o /DATA/AppData/cfx-server-docker/seccomp.json
```

Import `casaos-compose.yaml` through CasaOS Custom Install. Before submitting, replace these two values under the `mariadb` service with long random passwords:

- `REPLACE_WITH_A_LONG_RANDOM_ROOT_PASSWORD`
- `REPLACE_WITH_A_LONG_RANDOM_DATABASE_PASSWORD`

The CasaOS compose uses the standard host ports by default. Change the left-hand side of the port mappings before installation when those ports are already in use.

## Ports

| Port | Protocol | Purpose |
| --- | --- | --- |
| `30120` | TCP/UDP | FiveM server |
| `40120` | TCP | txAdmin |

MariaDB does not publish a host port.

## Important

`seccomp.json` is required for the Enhanced txAdmin build. Docker's default seccomp profile blocks the two `io_uring` syscalls it currently uses.

This is an experimental community project and is not affiliated with or endorsed by Cfx.re or Rockstar Games. Repository code is MIT licensed. Cfx Server and bundled third-party components retain their respective licenses.
