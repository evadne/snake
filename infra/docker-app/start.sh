#!/usr/bin/env bash

export ROLE="WEB"

if [ ! -z "${FLY_APP_NAME+x}" ]; then
  # Running on Fly.io
  # Use IPv6 Distribution
  ip=$(grep fly-local-6pn /etc/hosts | cut -f 1)
  export NODE_NAME="$FLY_APP_NAME@$ip"
  export ELIXIR_ERL_OPTIONS="-proto_dist inet6_tcp"
else
  # Running on AWS / IPv4 System
  # Use IPv4 Distribution
  nonce=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  hostname=$(ip -family inet addr show label 'eth*' | grep -Po 'inet \K[\d.]+' | head -n 1)
  export NODE_NAME="$ROLE-$nonce@$hostname"
fi

export SHELL=`which sh`
cd /app && exec -- authbind --deep -- ./_build/prod/rel/snake/bin/snake start
