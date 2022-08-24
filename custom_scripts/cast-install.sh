#!/bin/bash

CAST_VERSION="0.10.1"
COSIGN_VERSION="1.11.1"

curl -o /tmp/cast.deb -L "https://github.com/ekristen/cast/releases/download/v${CAST_VERSION}/cast_v${CAST_VERSION}_linux_amd64.deb"
dpkg -i /tmp/cast.deb
rm -f /tmp/cast.deb


curl -o /tmp/cosign -L "https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64"
mv /tmp/cosign /usr/local/bin/cosign
chmod +x /usr/local/bin/cosign