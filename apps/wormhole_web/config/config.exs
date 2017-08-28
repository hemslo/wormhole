# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wormhole_web,
  namespace: WormholeWeb

# Configures the endpoint
config :wormhole_web, WormholeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DHBgouph7urv6lMdeMBCr0AXRu71oau/Xm6ZQQ7DpRW6+RWiJuVD5CDwvJ8dCg7s",
  render_errors: [view: WormholeWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: WormholeWeb.PubSub,
           adapter: Phoenix.PubSub.PG2],
  http: [dispatch: [
    {:_, [
        {"/ws",  Phoenix.Endpoint.CowboyWebSocket, {WormholeWeb.WebsocketHandler, %{host: "localhost", port: 1080}}},
        {:_, Plug.Adapters.Cowboy.Handler, {WormholeWeb.Endpoint, []}}
      ]}]]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :wormhole_web, :generators,
  context_app: :wormhole

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
