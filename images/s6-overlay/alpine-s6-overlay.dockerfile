# Use alpine 3.16 as it uses the more stable mosquitto 2.0.14 version rather than 2.0.15
# which is included in newer versions of alpine
FROM alpine:3.18
ARG TARGETARCH
ARG TEDGE_VERSION=0.11.0
ARG S6_OVERLAY_VERSION=3.1.5.0

# Notes: ca-certificates is required for the initial connection with c8y, otherwise the c8y cert is not trusted
# to test out the connection. But this is only needed for the initial connection, so it seems unnecessary
RUN apk update \
    && apk add --no-cache \
        ca-certificates \
        mosquitto \
        curl \
        # GNU sed
        sed

# Install s6-overlay
# Based on https://github.com/just-containers/s6-overlay#which-architecture-to-use-depending-on-your-targetarch
RUN case ${TARGETARCH} in \
        "amd64")  S6_ARCH=x86_64  ;; \
        "arm64")  S6_ARCH=aarch64  ;; \
        "arm/v6")  S6_ARCH=armhf  ;; \
        "arm/v7")  S6_ARCH=arm  ;; \
    esac \
    && curl https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -L -s --output /tmp/s6-overlay-noarch.tar.xz \
    && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
    && curl https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz -L -s --output /tmp/s6-overlay-${S6_ARCH}.tar.xz \
    && tar -C / -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz

# Install tedge
RUN case ${TARGETARCH} in \
        "amd64")   TEDGE_ARCH=x86_64-unknown-linux-musl;  ;; \
        "arm64")   TEDGE_ARCH=aarch64-unknown-linux-musl;  ;; \
        "arm/v6")  TEDGE_ARCH=armv7-unknown-linux-musleabihf;  ;; \
        "arm/v7")  TEDGE_ARCH=armv7-unknown-linux-musleabihf;  ;; \
    esac \
    && curl https://github.com/thin-edge/thin-edge.io/releases/download/${TEDGE_VERSION}/tedge_${TEDGE_VERSION}_${TEDGE_ARCH}.tar.gz -L -s --output /tmp/tedge.tar.gz \
    && tar -C /usr/bin/ -xzf /tmp/tedge.tar.gz

COPY output/tedge-s6overlay_*.apk /tmp/
RUN apk add --allow-untrusted /tmp/tedge-s6overlay_*.apk

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV TEDGE_RUN_LOCK_FILES=false
ENV TEDGE_MQTT_BIND_ADDRESS=0.0.0.0
ENV TEDGE_MQTT_PORT=1883
ENV S6_CMD_WAIT_FOR_SERVICES_MAXTIME=30000

# RUN tedge --init \
#     && tedge-agent --init \
#     && tedge-mapper --init c8y \
#     && tedge-mapper --init az \
#     && tedge-mapper --init aws \
#     && c8y-log-plugin --init \
#     && c8y-configuration-plugin --init \
#     && c8y-remote-access-plugin --init \
#     && chown -R "${CONTAINER_USER}:${CONTAINER_GROUP}" /etc/tedge


# USER "$CONTAINER_USER"
ENTRYPOINT ["/init"]
