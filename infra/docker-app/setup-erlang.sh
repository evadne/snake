#!/usr/bin/env bash
set -euxo pipefail

case $ERLANG_SOURCE in
  erlang-solutions)
    apt-get install -yqq --no-install-recommends wget ca-certificates
    apt-get install -yqq --no-install-recommends libprocps6 libsctp1 procps libwxgtk3.0 libncurses5-dev libncursesw5-dev
    TemporaryDirectory=$(mktemp -d)
    PackageURL="https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_${ERLANG_VERSION}-1~debian~stretch_amd64.deb"
    cd $TemporaryDirectory
    wget -q -O erlang.deb "$PackageURL"
    echo "$ERLANG_SHA256  erlang.deb" | sha256sum -c -
    dpkg -i erlang.deb
    rm -rf $TemporaryDirectory
    ;;
  github)
    # See https://elixirforum.com/t/erlang-otp-24-0-released/39630/13
    # - OTP-17254 - The way Erlang finds OpenSSL has been changed, but since we use clang
    #   we have to explicitly tell it to find OpenSSL at the right place
    apt-get install -yqq --no-install-recommends wget ca-certificates
    apt-get install -yqq --no-install-recommends libssl-dev autoconf clang make
    TemporaryDirectory=$(mktemp -d)
    PackageURL="https://github.com/erlang/otp/archive/OTP-${ERLANG_VERSION}.tar.gz"
    PackageOptions="--without-termcap --without-observer --without-javac --without-odbc --with-ssl --enable-dynamic-ssl-lib --with-ssl-lib-subdir=lib/x86_64-linux-gnu"
    cd $TemporaryDirectory
    wget -q -O erlang.tar.gz "$PackageURL"
    echo "$ERLANG_SHA256  erlang.tar.gz" | sha256sum -c -
    tar -xzf erlang.tar.gz -C . --strip-components=1
    ./otp_build autoconf
    ./configure --build=x86_64-linux-gnu $PackageOptions
    make -j$(nproc)
    make install
    rm -rf $TemporaryDirectory
    ;;
  *)
    echo "ERLANG_SOURCE must be specified"
    exit 1
    ;;
esac
