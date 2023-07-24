FROM alpine:3.18
ARG TARGETARCH
ARG TEDGE_VERSION=0.11.0

# Notes: ca-certificates is required for the initial connection with c8y, otherwise the c8y cert is not trusted
# to test out the connection. But this is only needed for the initial connection, so it seems unnecessary
RUN apk update \
    && apk add --no-cache \
        ca-certificates \
        runit \
        mosquitto \
        curl

# Install tedge
RUN case ${TARGETARCH} in \
        "amd64")   TEDGE_ARCH=x86_64-unknown-linux-musl;  ;; \
        "arm64")   TEDGE_ARCH=aarch64-unknown-linux-musl;  ;; \
        "arm/v6")  TEDGE_ARCH=armv7-unknown-linux-musleabihf;  ;; \
        "arm/v7")  TEDGE_ARCH=armv7-unknown-linux-musleabihf;  ;; \
    esac \
    && curl https://github.com/thin-edge/thin-edge.io/releases/download/${TEDGE_VERSION}/tedge_${TEDGE_VERSION}_${TEDGE_ARCH}.tar.gz -L -s --output /tmp/tedge.tar.gz \
    && tar -C /usr/bin/ -xzf /tmp/tedge.tar.gz

# Configure runit
ENV SVDIR="/etc/service"
RUN mkdir -p "$SVDIR"

RUN adduser -D -H -s /sbin/nologin tedge

COPY output/tedge-runit_*.apk /tmp/
RUN apk add --allow-untrusted /tmp/tedge-runit_*.apk

COPY ./images/setup.sh /usr/bin/

CMD [ "runsvdir", "-P", "/etc/service" ]
