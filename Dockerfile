FROM alpine:3.22

#DBUS is optional, as Avahi can run without it, but some features won't work
ARG WITH_DBUS=false

RUN apk add --no-cache avahi  avahi-tools dbus supervisor

# Copy a default configuration file
COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf
COPY supervisord.conf  /etc/supervisord.conf
COPY --chmod=0755 entrypoint.sh /

RUN mkdir -p /run/avahi-daemon /run/dbus;

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
