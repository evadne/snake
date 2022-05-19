#!/usr/bin/env bash
set -euxo pipefail

export MAKEFLAGS=-j8
export TemporaryDirectory=$(mktemp -d)

apt-get -yqq install --no-install-recommends \
  authbind \
  ca-certificates \
  iproute2 \
  libssl1.1 \
  openssl

ldconfig
rm -rf "$TemporaryDirectory"
