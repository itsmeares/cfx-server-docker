# syntax=docker/dockerfile:1.7

ARG ALPINE_VERSION=3.22

FROM alpine:${ALPINE_VERSION} AS download

ARG CFX_ARTIFACT_URL=https://downloads.cfx-services.net/prod/019fc7df-a2ad-76aa-866a-92f4c228ef7b/cfx-server_linux_x64.tar.xz
ARG CFX_ARTIFACT_SHA256=5ab15fccf4fb475845485b1fafb7f9134374d9aa234b3462c5980f333be4c2d1

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
