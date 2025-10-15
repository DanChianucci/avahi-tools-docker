This container is a utility for MACVLAN networks in DOCKER.

Rather than getting assigned an ip address from docker it will (optionally) request a
DHCP lease from the real network (using udhcpc)

It will then (optionally) launch avahi (and dbus) using a default configuration.


To disbale either the DHCP or AVAHI portions simply set
    NO_DHCP=1 or NO_AVAHI=1





To make simple use acases easier, the user can override a
few config values using environment variables:

  AVAHI_HOST   :  Overrides the published hostname (and dhcp hostname) [defaults to containers hostname]
  AVAHI_DOMAIN :  Overrides the avahi domain name [defaults to local]

For more advanced configurations, a custom config file can be bound to /etc/avahi/avahi-daemon.conf


To tell avahi to publish a static service a volume containing avahi
static service definition files can can be bound to /etc/avahi/services


Note:  Due to a limitiation with MACVLAN networks the host will not be able to see the containers mDNS results by default.
https://blog.oddbit.com/post/2018-03-12-using-docker-macvlan-networks/
