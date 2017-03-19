defmodule FollowerMaze.Server.EventHandler do
  require Logger

  alias FollowerMaze.Registries.Events

  @connection_options [:binary, packet: :line, active: false, reuseaddr: true]

  def start_link(port) do
    pid = spawn_link(fn -> init(port) end)

    {:ok, pid}
  end

  def init(port) do
    {:ok, server} = :gen_tcp.listen(port, @connection_options)
    {:ok, event_source} = :gen_tcp.accept(server)

    Logger.info("Listening for events.")

    receive_events(event_source)
  end

  defp receive_events(event_source) do
    case :gen_tcp.recv(event_source, 0) do
      {:ok, raw_event} ->
	Events.put(raw_event)
	receive_events(event_source)
      _ ->
	Logger.info("Event source disconnected.")
	:gen_tcp.close(event_source)
    end
  end
end
