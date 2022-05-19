#!/usr/bin/env bash
set -euxo pipefail

mkdir --parents /home/deployer
groupadd --system deployer
useradd --system --create-home --gid deployer --groups audio,video deployer
chown --recursive --changes deployer:deployer /home/deployer
