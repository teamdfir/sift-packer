#!/bin/bash

CAST_VERSION="0.15.0"
ARCH=$(dpkg --print-architecture)

curl -o /tmp/cast.deb -L "https://github.com/ekristen/cast/releases/download/v${CAST_VERSION}/cast-v${CAST_VERSION}-linux-${ARCH}.deb"
dpkg -i /tmp/cast.deb
rm -f /tmp/cast.deb
