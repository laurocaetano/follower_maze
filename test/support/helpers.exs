defmodule FollowerMaze.TestHelpers do
  alias FollowerMaze.Registries.Events

  def emit_event(event) do
    Events.put(event.raw_event)
    :timer.sleep(100) # time required to consume the event
  end

  def connect_client_and_wait_for_messages(id) do
    server = connect_client(id)
    Task.async(fn() -> Socket.Stream.recv!(server) end)
  end

  def connect_client(id) do
    server = Socket.TCP.connect!("localhost", 9099, packet: :line)
    Socket.Stream.send!(server, "#{id}\n")
    :timer.sleep(100) # wait until we send the tcp event
    server
  end

  def disconnect(socket) do
    :gen_tcp.close(socket)
    :timer.sleep(100) # wait until the connection is closed
  end
end
