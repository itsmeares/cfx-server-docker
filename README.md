# Cfx Server Docker

Minimal Docker image for **Cfx Server / FiveM for GTAV Enhanced (early access)**.

- Cfx Server build `98-ea`
- txAdmin included
- Runs as non-root UID/GID `1000`
- Uses a narrow seccomp profile that permits only `io_uring_setup` and `io_uring_enter` beyond Docker's default profile

## Quick start

```bash
git clone https://github.com/itsmeares/cfx-server-docker.git
cd cfx-server-docker
mkdir -p txData
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

## CasaOS

The CasaOS compose uses host ports `30121` and `40121` so it can coexist with a Legacy server on `30120` and `40120`.

Prepare the data directory and seccomp profile:

```bash
sudo install -d -o 1000 -g 1000 /DATA/AppData/cfx-server-docker/txData
sudo curl -fsSL https://raw.githubusercontent.com/itsmeares/cfx-server-docker/main/seccomp.json \
  -o /DATA/AppData/cfx-server-docker/seccomp.json
```

Then import `casaos-compose.yaml` through CasaOS Custom Install.

## Ports

| Setup | FiveM | txAdmin |
| --- | --- | --- |
| Standard Compose | `30120` TCP/UDP | `40120` TCP |
| CasaOS Compose | `30121` TCP/UDP | `40121` TCP |

## Important

`seccomp.json` is required for the Enhanced txAdmin build. Docker's default seccomp profile blocks the two `io_uring` syscalls it currently uses.

This is an experimental community project and is not affiliated with or endorsed by Cfx.re or Rockstar Games. Repository code is MIT licensed. Cfx Server and bundled third-party components retain their respective licenses.
