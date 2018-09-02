FROM elixir:1.7.3-alpine

RUN apk add --no-cache bash

RUN mix local.hex --force && \
    mix local.rebar --force

COPY . /usr/src/wormhole/

WORKDIR /usr/src/wormhole

ENV MIX_ENV prod

RUN mix deps.get

RUN mix release --name=wormhole_client --verbose

RUN mix release --name=wormhole_server --verbose
