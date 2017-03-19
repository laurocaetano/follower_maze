defmodule FollowerMaze.Server.ClientHandler do
  alias FollowerMaze.Registries.ConnectedClients

  @connection_options [:binary, packet: :line, active: false, reuseaddr: true]

  def start_link(port) do
    pid = spawn_link(fn -> init(port) end)

    {:ok, pid}
  end

  def init(port) do
    {:ok, server} = :gen_tcp.listen(port, @connection_options)
    accept_connections(server)
  end

  defp accept_connections(server) do
    {:ok, client_connection} = :gen_tcp.accept(server)

    spawn(fn() -> receive_events(client_connection, nil) end)

    accept_connections(server)
  end

  defp receive_events(client_connection, client_id) do
    case :gen_tcp.recv(client_connection, 0) do
      {:ok, raw_id} ->
	client_id = String.replace(raw_id, "\n", "")

	ConnectedClients.register(client_id, client_connection)
	receive_events(client_connection, client_id)
      { :error, :closed } ->
	ConnectedClients.unregister(client_id)
	:gen_tcp.close(client_connection)
      _ ->
	ConnectedClients.unregister(client_id)
	:gen_tcp.close(client_connection)
    end
  end
end
