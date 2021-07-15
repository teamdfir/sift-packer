#!/bin/bash -eux

echo "==> Giving ${SSH_USERNAME} sudo powers without password"
rm -f "/etc/sudoers.d/${SSH_USERNAME}"
echo "${SSH_USERNAME}        ALL=(ALL)       NOPASSWD: ALL" > "/etc/sudoers.d/${SSH_USERNAME}"
chmod 440 "/etc/sudoers.d/${SSH_USERNAME}"