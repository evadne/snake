#!/usr/bin/env bash

export ROLE="CONSOLE"
export SHELL=`which sh`
cd /app && exec -- authbind --deep -- ./_build/prod/rel/snake/bin/snake eval "SnakeData.Release.migrate()"
