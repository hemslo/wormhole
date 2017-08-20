defmodule Wormhole.Application do
  @moduledoc """
  The Wormhole Application Service.

  The wormhole system business domain lives in this application.

  Exposes API to clients such as the `WormholeWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: Wormhole.Supervisor)
  end
end
