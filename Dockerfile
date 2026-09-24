# syntax=docker/dockerfile:1.7

ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION} AS download

ARG CFX_ARTIFACT_URL=https://downloads.cfx-services.net/prod/01a0d3c8-c28a-7df0-8c51-4d910f4de3bd/cfx-server_linux_x64.tar.xz
ARG CFX_ARTIFACT_SHA256=b3546e9524dbece4dbfa1c4d53b8398f3eaa83bfcbd8739dd6273b0ba489a333

RUN apk add --no-cache ca-certificates curl xz \
    && curl -fsSL "${CFX_ARTIFACT_URL}" -o /tmp/cfx-server.tar.xz \
    && echo "${CFX_ARTIFACT_SHA256}  /tmp/cfx-server.tar.xz" | sha256sum -c - \
    && mkdir -p /server \
    && tar -xJf /tmp/cfx-server.tar.xz -C /server \
    && test -x /server/run.sh \
    && test -r /server/alpine/opt/cfx-server/cfx-server

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache bash ca-certificates openssl tzdata \
    && addgroup -g 1000 -S cfx \
    && adduser -u 1000 -S cfx -G cfx \
    && mkdir -p /txData \
    && chown cfx:cfx /txData

COPY --from=download --chown=cfx:cfx /server /server

USER cfx
WORKDIR /server

VOLUME ["/txData"]

EXPOSE 30120/tcp 30120/udp 40120/tcp

ENTRYPOINT ["/server/run.sh"]
