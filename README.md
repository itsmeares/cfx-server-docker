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

Prepare the data directory and seccomp profile:

```bash
sudo install -d -o 1000 -g 1000 /DATA/AppData/cfx-server-docker/txData
sudo curl -fsSL https://raw.githubusercontent.com/itsmeares/cfx-server-docker/main/seccomp.json \
  -o /DATA/AppData/cfx-server-docker/seccomp.json
```

Then import `casaos-compose.yaml` through CasaOS Custom Install.

## Ports

| Port | Protocol | Purpose |
| --- | --- | --- |
| `30120` | TCP/UDP | FiveM server |
| `40120` | TCP | txAdmin |

## Important

`seccomp.json` is required for the Enhanced txAdmin build. Docker's default seccomp profile blocks the two `io_uring` syscalls it currently uses.

This is an experimental community project and is not affiliated with or endorsed by Cfx.re or Rockstar Games. Repository code is MIT licensed. Cfx Server and bundled third-party components retain their respective licenses.
