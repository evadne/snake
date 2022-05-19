FROM debian:stretch-slim as snake-base
RUN apt-get -yqq update && \
    apt-get -yqq install --no-install-recommends locales && \
    echo "Etc/UTC" > /etc/timezone && \
    dpkg-reconfigure --frontend=noninteractive tzdata && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=C.UTF-8
ENV LANG="C.UTF-8"
ENV LANGUAGE="en_US"
ENV LC_ALL="C.UTF-8"
ENV ERLANG_SOURCE="erlang-solutions"
ENV ERLANG_VERSION="24.3.3"
ENV ERLANG_SHA256="8025d4f27094daa2d7f9cdecf13fec7c3c183aecf12949e4707515a5d6b8a6a8"
ENV ELIXIR_SOURCE="github-precompiled"
ENV ELIXIR_VERSION="1.13.4"
ENV ELIXIR_SHA256="e74eee9d4e1c64e7add0e2b4e2fb41aaaa7450522f46f8e922b9bf6a27587606"
ENV NODEJS_VERSION="12.5.0"
ENV NODEJS_SHA256="9ef0ad71d6196205fb69ac80907b01435d53c6e1510eab33b1c8f1826a8a7f6c"
ENV MIX_HOME="/usr/local/share/mix"
ENV MIX_ENV=prod
COPY infra/docker-app/setup-packages.sh /setup/
RUN /setup/setup-packages.sh

FROM snake-base as snake-build
COPY infra/docker-app/setup-erlang.sh /setup/
COPY infra/docker-app/setup-elixir.sh /setup/
COPY infra/docker-app/setup-nodejs.sh /setup/
RUN /setup/setup-erlang.sh
RUN /setup/setup-elixir.sh
RUN /setup/setup-nodejs.sh
RUN mix local.hex --force && mix local.rebar --force

FROM snake-build as snake-build-release
RUN apt-get install -yqq --no-install-recommends git clang make
COPY mix.exs mix.lock /app/
COPY apps/snake/mix.exs /app/apps/snake/
COPY apps/snake_data/mix.exs /app/apps/snake_data/
COPY apps/snake_environment/mix.exs /app/apps/snake_environment/
COPY apps/snake_proxy/mix.exs /app/apps/snake_proxy/
COPY apps/snake_web/mix.exs /app/apps/snake_web/
WORKDIR /app
RUN mix deps.get --only prod
COPY config/config.exs config/releases.exs config/prod.exs /app/config/
RUN mix deps.compile
COPY apps /app/apps
RUN mix compile
RUN for f in apps/*/assets; do echo $f; done | \
      xargs -P $(nproc) -I '{}' -- sh -c 'cd {} && npm ci && npm run deploy'
RUN mix phx.digest
COPY rel /app/rel
RUN mix release

FROM snake-base
RUN touch /etc/authbind/byport/80 && \
    chmod 777 /etc/authbind/byport/80
COPY infra/docker-app/setup-user.sh /setup/
RUN /setup/setup-user.sh
USER deployer
COPY --chown=deployer:deployer --from=snake-build-release /app/_build/prod/rel/snake /app/_build/prod/rel/snake
COPY --chown=deployer:deployer infra/docker-app/start.sh /app/
COPY --chown=deployer:deployer infra/docker-app/console.sh /app/
COPY --chown=deployer:deployer infra/docker-app/migrate.sh /app/
WORKDIR /app
CMD ./start.sh
