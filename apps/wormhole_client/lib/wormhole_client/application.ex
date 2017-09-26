defmodule WormholeClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # List all child processes to be supervised

    params = Application.get_env(:wormhole_client, Worker)

    children = [
      # Starts a worker by calling: WormholeClient.Worker.start_link(arg)
      worker(WormholeClient.Worker, [
               :wormhole_client,
               params[:num_acceptors],
               params[:transport],
               params[:trans_opts],
               params[:protocol],
               params[:proto_opts],
             ])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WormholeClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
