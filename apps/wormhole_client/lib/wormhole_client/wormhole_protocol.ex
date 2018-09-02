defmodule WormholeClient.WormholeProtocol do
  use GenServer

  @behaviour :ranch_protocol

  alias WormholeClient.WebsocketClient

  def start_link(ref, socket, transport, opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport, [url]) do
    :ok = :ranch.accept_ack(ref)
    {:ok, websocket_client_pid} = WebsocketClient.start_link(self(), url)

    :gen_server.enter_loop(__MODULE__, [], %{
      socket: socket,
      transport: transport,
      websocket_client_pid: websocket_client_pid
    })
  end

  def init(args) do
    {:ok, args}
  end

  def handle_info(:connected, %{socket: socket, transport: transport} = state) do
    :ok = transport.setopts(socket, [{:active, :once}])
    {:noreply, state}
  end

  def handle_info(:disconnected, %{socket: socket, transport: transport} = state) do
    :ok = transport.setopts(socket, [{:active, false}])
    {:noreply, state}
  end

  def handle_info({:recv, data}, %{socket: socket, transport: transport} = state) do
    transport.send(socket, data)
    {:noreply, state}
  end

  def handle_info(
        {:tcp, socket, data},
        %{socket: socket, transport: transport, websocket_client_pid: websocket_client_pid} =
          state
      ) do
    WebsocketClient.send_data(websocket_client_pid, data)
    :ok = transport.setopts(socket, [{:active, :once}])
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, %{socket: socket, transport: transport} = state) do
    transport.close(socket)
    {:stop, :normal, state}
  end
end
