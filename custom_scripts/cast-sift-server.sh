#!/bin/bash

cast install --log-level debug --mode server teamdfir/sift-saltstack

cat /var/cache/cast/installer/logs/results.yaml