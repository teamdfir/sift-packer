#!/bin/bash

CAST_VERSION="0.14.0"

curl -o /tmp/cast.deb -L "https://github.com/ekristen/cast/releases/download/v${CAST_VERSION}/cast_v${CAST_VERSION}_linux_amd64.deb"
dpkg -i /tmp/cast.deb
rm -f /tmp/cast.deb
