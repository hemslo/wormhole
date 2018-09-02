defmodule WormholeClient.Worker do
  def start_link(ref, acceptors, transport, transport_opts, protocol, protocol_opts) do
    {:ok, _} =
      :ranch.start_listener(ref, acceptors, transport, transport_opts, protocol, protocol_opts)
  end
end
