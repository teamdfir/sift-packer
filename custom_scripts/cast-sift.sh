#!/bin/bash

set -e

# Function to cat the files
function cat_files {
    cat /var/cache/cast/installer/logs/results.yaml
}

trap cat_files EXIT

cast install --log-level debug --mode desktop --pre-release teamdfir/sift-saltstack
