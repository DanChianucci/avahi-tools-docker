#!/usr/bin/env sh
set -e

if [ ! -z "$AVAHI_HOST" ]; then
  sed -i -e "s/^#host-name=.*/host-name=${AVAHI_HOST}/" /etc/avahi/avahi-daemon.conf
fi
if [ ! -z "$AVAHI_DOMAIN" ]; then
  sed -i -e "s/^#domain-name=.*/domain-name=${AVAHI_DOMAIN}/" /etc/avahi/avahi-daemon.conf
fi

if [ ! -z "$AVAHI_HOST" ]; then
  HOSTNAME=$AVAHI_HOST
else
  HOSTNAME=$(hostname)
fi

if [ -z "$NO_DHCP" ] || [ "$NO_DHCP" -eq 0 ] || [ "$NO_DHCP" = "false" ]; then
  echo "Waiting for network interface eth0..."
  while ! ip link show eth0 | grep -q 'state UP' >/dev/null 2>&1; do
      sleep 1
  done

  echo "Flushing existing IP addresses on eth0..."
  ip addr flush dev eth0

  echo "Requesting a DHCP lease for eth0..."
  udhcpc -i eth0 -x "hostname:$HOSTNAME" -q -n
fi



if [ -z "$NO_AVAHI" ] || [ "$NO_AVAHI" -eq 0 ] || [ "$NO_AVAHI" = "false" ]; then
  echo "Starting DBUS"
  dbus-daemon --system

  echo "Starting AVAHI"
  rm -f /run/avahi-daemon/pid
  avahi-daemon "$@"
fi

echo "Complete"