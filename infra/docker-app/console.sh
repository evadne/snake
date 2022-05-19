#!/usr/bin/env bash

export ROLE="CONSOLE"

nonce=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
hostname=$(ip -family inet addr show label 'eth*' | grep -Po 'inet \K[\d.]+')
export NODE_NAME="$ROLE-$nonce@$hostname"

export SHELL=`which sh`
cd /app && ./_build/prod/rel/snake/bin/snake start_iex
