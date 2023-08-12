FROM alpine:3.18

# Notes: ca-certificates is required for the initial connection with c8y, otherwise the c8y cert is not trusted
# to test out the connection. But this is only needed for the initial connection, so it seems unnecessary
RUN apk update \
    && apk add --no-cache \
        ca-certificates \
        supervisor \
        mosquitto

# Install tedge
RUN wget -O - thin-edge.io/install.sh | sh -s

COPY images/supervisord/supervisord.conf /etc/
COPY dist/tedge-supervisord_*.apk /tmp/
RUN apk add --allow-untrusted /tmp/tedge-supervisord_*.apk

COPY ./images/check.sh /usr/bin/

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
