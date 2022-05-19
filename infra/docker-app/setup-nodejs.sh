#!/usr/bin/env bash
set -euxo pipefail
apt-get install -yqq --no-install-recommends wget ca-certificates python-minimal

PackageURL="https://deb.nodesource.com/node_12.x/pool/main/n/nodejs/nodejs_${NODEJS_VERSION}-1nodesource1_amd64.deb"
TemporaryDirectory=$(mktemp -d)

cd $TemporaryDirectory
wget -q -O node.deb "$PackageURL"
echo "$NODEJS_SHA256  node.deb" | sha256sum -c -
dpkg -i node.deb
rm -rf $TemporaryDirectory
