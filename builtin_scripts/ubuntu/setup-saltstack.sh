#!/bin/bash

export DEBIAN_FRONTEND="noninteractive"

echo "==> Installing saltstack"

salt_version="3003"
os_version=$(lsb_release -sr)
os_codename=$(lsb_release -sc)

apt-get install -y curl
curl -fsSL -o /usr/share/keyrings/salt-archive-keyring.gpg "https://repo.saltproject.io/py3/ubuntu/$os_version/amd64/$salt_version/salt-archive-keyring.gpg"
echo "deb [signed-by=/usr/share/keyrings/salt-archive-keyring.gpg] https://repo.saltproject.io/py3/ubuntu/$os_version/amd64/$salt_version $os_codename main" | sudo tee /etc/apt/sources.list.d/salt.list
apt-get update
apt-get install -y salt-common