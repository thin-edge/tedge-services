FROM debian:bullseye-slim

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    sysvinit-core \
    rsyslog \
    procps \
    mosquitto

ARG TEDGE_VERSION=0.11.0

VOLUME /sys/fs/cgroup

# Install tedge
RUN case ${TARGETARCH} in \
        "amd64")   TEDGE_ARCH=x86_64-unknown-linux-musl;  ;; \
        "arm64")   TEDGE_ARCH=aarch64-unknown-linux-musl;  ;; \
        "arm/v6")  TEDGE_ARCH=armv7-unknown-linux-musleabihf;  ;; \
        "arm/v7")  TEDGE_ARCH=armv7-unknown-linux-musleabihf;  ;; \
        *)  TEDGE_ARCH=aarch64-unknown-linux-musl;  ;; \
    esac \
    && curl "https://github.com/thin-edge/thin-edge.io/releases/download/${TEDGE_VERSION}/tedge_${TEDGE_VERSION}_${TEDGE_ARCH}.tar.gz" -L -s --output /tmp/tedge.tar.gz \
    && tar -C /usr/bin/ -xzf /tmp/tedge.tar.gz

RUN useradd --shell /usr/sbin/nologin tedge

# Copy functions script used by yocto
COPY images/sysvinit/functions /etc/init.d/

COPY output/tedge-sysvinit_*.deb /tmp/
RUN dpkg -i /tmp/tedge-sysvinit_*.deb

COPY ./images/setup.sh /usr/bin/

ENTRYPOINT [ "/sbin/init" ]
