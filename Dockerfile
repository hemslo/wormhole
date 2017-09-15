FROM elixir:1.5.1-alpine

RUN apk add --no-cache bash

RUN mkdir /usr/src/wormhole

WORKDIR /usr/src/wormhole

COPY . /usr/src/wormhole

RUN mix local.hex --force && \
    mix local.rebar --force

RUN mix deps.get

RUN mix release --name=wormhole_client --verbose

RUN mix release --name=wormhole_server --verbose
