defmodule Wormhole.Forwarder do
  use GenServer

  def start_link(opts, args) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def send_data(server, data) do
    GenServer.cast(server, {:data, data})
  end

  def init(%{host: host, port: port, client_pid: client_pid}) do
    {:ok, socket} = :gen_tcp.connect(host |> String.to_charlist(), port, [:binary, packet: 0, active: :once])
    {:ok, %{socket: socket, client_pid: client_pid}}
  end

  def handle_cast({:data, data}, %{socket: socket} = state) do
    :gen_tcp.send(socket, data)
    {:noreply, state}
  end

  def handle_info({:tcp, socket, msg}, %{socket: socket, client_pid: client_pid} = state) do
    send client_pid, {:data, msg}
    :inet.setopts(socket, active: :once)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, %{socket: socket} = state) do
    {:noreply, state}
  end
end
