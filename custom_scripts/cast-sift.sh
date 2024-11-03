#!/bin/bash

set -e

cast install --log-level debug --mode desktop teamdfir/sift-saltstack

cat /var/cache/cast/installer/logs/results.yaml
cat /var/cache/cast/installer/logs/results.yaml