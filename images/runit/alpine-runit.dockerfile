FROM alpine:3.18
ARG TARGETARCH

# Notes: ca-certificates is required for the initial connection with c8y, otherwise the c8y cert is not trusted
# to test out the connection. But this is only needed for the initial connection, so it seems unnecessary
RUN apk update \
    && apk add --no-cache \
        ca-certificates \
        runit \
        mosquitto \
        curl

# Install tedge
RUN wget -O - thin-edge.io/install.sh | sh

# Configure runit
ENV SVDIR="/etc/service"
RUN mkdir -p "$SVDIR"

COPY dist/tedge-runit_*.apk /tmp/
RUN apk add --allow-untrusted /tmp/tedge-runit_*.apk

COPY ./images/check.sh /usr/bin/

CMD [ "runsvdir", "-P", "/etc/service" ]
