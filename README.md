# Cfx Server Docker

Minimal Docker image for **Cfx Server / FiveM for GTAV Enhanced (early access)**.

- Cfx Server build `118-ea`
- txAdmin included
- MariaDB `12.3.2` included in the Compose setup
- DbGate `7.2.3-alpine` included for browser-based database administration
- Runs as non-root UID/GID `1000`
- Uses a narrow seccomp profile that permits only `io_uring_setup` and `io_uring_enter` beyond Docker's default profile

## Quick start

```bash
git clone https://github.com/itsmeares/cfx-server-docker.git
cd cfx-server-docker
cp .env.example .env
mkdir -p txData mariadb dbgate
```

Replace the password placeholders in `.env`, then start the stack:

```bash
docker compose up -d
```

Open txAdmin at:

```text
http://localhost:40120
```

Open DbGate at:

```text
http://localhost:3000
```

The default Compose configuration binds DbGate to `127.0.0.1`. To access it from another device on the LAN, set `DBGATE_BIND_ADDRESS` in `.env` to the server's LAN address. Do not expose DbGate through router port forwarding or a public reverse proxy.

Get the txAdmin registration PIN:

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
| Database Username | Value of `MARIADB_USER` (`cfxserver` by default) |
| Database Password | Value of `MARIADB_PASSWORD` |
| Database Name | Value of `MARIADB_DATABASE` (`cfxserver` by default) |
| Delete Database | Off |

Framework recipes import their own SQL files. This repository only provides the database service.

## DbGate

DbGate is preconfigured with a single MariaDB connection restricted to the configured database. Sign in with `DBGATE_LOGIN` and `DBGATE_PASSWORD`, then enter `MARIADB_PASSWORD` when opening the database connection.

DbGate data, including saved scripts and application settings, is stored in the `dbgate` volume directory.

## CasaOS

Prepare the data directories and seccomp profile:

```bash
sudo install -d -o 1000 -g 1000 /DATA/AppData/cfx-server-docker/txData
sudo install -d /DATA/AppData/cfx-server-docker/mariadb
sudo install -d /DATA/AppData/cfx-server-docker/dbgate
sudo curl -fsSL https://raw.githubusercontent.com/itsmeares/cfx-server-docker/main/seccomp.json \
  -o /DATA/AppData/cfx-server-docker/seccomp.json
```

Import `casaos-compose.yaml` through CasaOS Custom Install. Before submitting, replace these values with long random passwords:

- `REPLACE_WITH_A_LONG_RANDOM_ROOT_PASSWORD`
- `REPLACE_WITH_A_LONG_RANDOM_DATABASE_PASSWORD`
- `REPLACE_WITH_A_LONG_RANDOM_DBGATE_PASSWORD`

The CasaOS Compose publishes DbGate on its default host port `3000`. Keep it accessible only from the trusted LAN and change the left-hand side of the mapping if the port is already in use.

The CasaOS Compose uses the standard FiveM and txAdmin host ports by default. Change the left-hand side of the port mappings before installation when those ports are already in use.

## Ports

| Port | Protocol | Purpose |
| --- | --- | --- |
| `30120` | TCP/UDP | FiveM server |
| `40120` | TCP | txAdmin |
| `3000` | TCP | DbGate web interface |

MariaDB does not publish a host port.

## Important

`seccomp.json` is required for the Enhanced txAdmin build. Docker's default seccomp profile blocks the two `io_uring` syscalls it currently uses.

DbGate is an administration interface, not a database backup or availability-monitoring service. Keep the MariaDB healthcheck enabled and configure database backups separately.

This is an experimental community project and is not affiliated with or endorsed by Cfx.re or Rockstar Games. Repository code is MIT licensed. Cfx Server and bundled third-party components retain their respective licenses.
