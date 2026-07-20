#!/bin/bash
set -e
mkdir /tmp/devops-test || echo "Directory already exists"
cd /tmp/devops-test || { echo "Cannot enter /tmp/devops-test"; exit 1; }
touch example.txt
echo "Created example.txt in /tmp/devops-test"
