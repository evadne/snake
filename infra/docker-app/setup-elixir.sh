#!/usr/bin/env bash
set -euxo pipefail

case $ELIXIR_SOURCE in
  hex-precompiled)
    apt-get install -yqq --no-install-recommends wget ca-certificates
    apt-get install -yqq --no-install-recommends unzip
    TemporaryDirectory=$(mktemp -d)
    PackageURL="https://repo.hex.pm/builds/elixir/v${ELIXIR_VERSION}.zip"
    cd $TemporaryDirectory
    wget -q -O elixir.zip "$PackageURL"
    echo "$ELIXIR_SHA256  elixir.zip" | sha256sum -c -
    unzip elixir.zip -d /usr/local 'bin/*' 'lib/*'
    rm -rf $TemporaryDirectory
    ;;
  github-precompiled)
    apt-get install -yqq --no-install-recommends wget ca-certificates
    apt-get install -yqq --no-install-recommends unzip
    TemporaryDirectory=$(mktemp -d)
    PackageURL="https://github.com/elixir-lang/elixir/releases/download/v${ELIXIR_VERSION}/Precompiled.zip"
    cd $TemporaryDirectory
    wget -q -O elixir.zip "$PackageURL"
    echo "$ELIXIR_SHA256  elixir.zip" | sha256sum -c -
    unzip elixir.zip -d /usr/local 'bin/*' 'lib/*'
    rm -rf $TemporaryDirectory
    ;;
  github)
    apt-get install -yqq --no-install-recommends wget ca-certificates make
    TemporaryDirectory=$(mktemp -d)
    PackageURL="https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz"
    cd $TemporaryDirectory
    wget -q -O elixir.tar.gz "$PackageURL"
    echo "$ELIXIR_SHA256  elixir.tar.gz" | sha256sum -c -
    tar -xzf elixir.tar.gz -C . --strip-components=1
    make install
    rm -rf $TemporaryDirectory
    ;;
  *)
    echo "ELIXIR_SOURCE must be specified"
    exit 1
    ;;
esac
