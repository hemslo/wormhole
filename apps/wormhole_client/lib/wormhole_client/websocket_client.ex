defmodule WormholeClient.WebsocketClient do
  @behaviour :websocket_client

  def start_link(sender, url) do
    :crypto.start()
    :ssl.start()
    :websocket_client.start_link(url |> String.to_charlist(), __MODULE__, [sender])
  end

  def init([sender]) do
    {:reconnect, %{sender: sender}}
  end

  def send_data(pid, data) do
    send(pid, {:send, data})
  end

  def onconnect(_req, state) do
    send(state.sender, :connected)
    {:ok, state}
  end

  def ondisconnect({:remote, :closed}, state) do
    send(state.sender, :disconnected)
    {:reconnect, state}
  end

  def websocket_handle({:binary, msg}, _conn_state, state) do
    send(state.sender, {:recv, msg})
    {:ok, state}
  end

  def websocket_handle(_msg, _conn_state, state) do
    {:ok, state}
  end

  def websocket_info({:send, data}, __conn_state, state) do
    {:reply, {:binary, data}, state}
  end

  def websocket_terminate(_reason, _conn_state, _state) do
    :ok
  end
end
