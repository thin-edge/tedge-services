FROM debian:bullseye-slim

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    sysvinit-core \
    rsyslog \
    procps \
    mosquitto

VOLUME /sys/fs/cgroup

# Install tedge
RUN curl -sSLf thin-edge.io/install.sh | sh

# Copy functions script used by yocto
COPY images/sysvinit/functions /etc/init.d/

COPY dist/tedge-sysvinit_*.deb /tmp/
RUN dpkg -i /tmp/tedge-sysvinit_*.deb

COPY ./images/check.sh /usr/bin/

ENTRYPOINT [ "/sbin/init" ]
