FROM alpine:3.18

RUN apk add util-linux openrc rsyslog curl mosquitto
ARG TEDGE_VERSION=0.11.0

VOLUME /sys/fs/cgroup

RUN rc-update add rsyslog default \
  && mkdir /run/openrc \
  && touch /run/openrc/softlevel

# Install tedge
RUN case ${TARGETARCH} in \
        "amd64")   TEDGE_ARCH=x86_64-unknown-linux-musl;  ;; \
        "arm64")   TEDGE_ARCH=aarch64-unknown-linux-musl;  ;; \
        "arm/v6")  TEDGE_ARCH=arm-unknown-linux-musleabihf;  ;; \
        "arm/v7")  TEDGE_ARCH=armv7-unknown-linux-musleabihf;  ;; \
        *)  TEDGE_ARCH=aarch64-unknown-linux-musl;  ;; \
    esac \
    && curl "https://github.com/thin-edge/thin-edge.io/releases/download/${TEDGE_VERSION}/tedge_${TEDGE_VERSION}_${TEDGE_ARCH}.tar.gz" -L -s --output /tmp/tedge.tar.gz \
    && tar -C /usr/bin/ -xzf /tmp/tedge.tar.gz

RUN adduser -D -H -s /sbin/nologin tedge

COPY dist/tedge-openrc_*.apk /tmp/
RUN apk add --allow-untrusted /tmp/tedge-openrc_*.apk

COPY ./images/setup.sh /usr/bin/

ENTRYPOINT [ "/sbin/init" ]
