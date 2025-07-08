#!/bin/sh

# Note: for some reason this just doesn't work properly inside vmware
# everyone recommends just disabling it, there's never anything wrong with the network
systemctl mask systemd-networkd-wait-online.service