defmodule WormholeWeb.WebsocketHandler do
  alias Wormhole.Forwarder

  def init(%Plug.Conn{method: "GET"} = conn, opts) do
    {:ok, conn, {__MODULE__, opts}}
  end

  def init(conn, _) do
    {:error, conn}
  end

  def ws_init(%{host: _, port: _} = opts) do
    {:ok, pid} = Forwarder.start_link([], opts |> Map.put(:client_pid, self()))
    {:ok, pid, :infinity}
  end

  def ws_handle(:binary, payload, pid) do
    Forwarder.send_data(pid, payload)
    {:ok, pid}
  end

  def ws_info({:data, data}, pid) do
    {:reply, {:binary, data}, pid}
  end

  def ws_info(_, state) do
    {:ok, state}
  end

  def ws_terminate(_reason, _state) do
    :ok
  end

  def ws_close(_state) do
    :ok
  end
end
