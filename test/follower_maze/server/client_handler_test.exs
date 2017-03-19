defmodule FollowerMaze.Server.ClientHandlerTest do
  use ExUnit.Case

  alias FollowerMaze.Registries.ConnectedClients

  test "add the connection to the ConnectedClientRegistry" do
    client_id = "666"

    {:ok, source} = :gen_tcp.connect('localhost', 9099, [])
    :gen_tcp.send(source, "#{client_id}\n")

    :timer.sleep(100) # wait until we send the tcp event

    assert ConnectedClients.get(client_id) != nil
  end

  test "when the client disconects, remove its entry from the Registry" do
    client_id = "111"

    {:ok, source} = :gen_tcp.connect('localhost', 9099, [])
    :gen_tcp.send(source, "#{client_id}\n")
    :gen_tcp.close(source)

    :timer.sleep(100) # wait until we send the tcp event

    assert ConnectedClients.get(client_id) == nil
  end
end
