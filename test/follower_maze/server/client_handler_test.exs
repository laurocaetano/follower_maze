defmodule FollowerMaze.Server.ClientHandlerTest do
  use ExUnit.Case

  import FollowerMaze.TestHelpers

  alias FollowerMaze.Registries.ConnectedClients

  test "add the connection to the ConnectedClientRegistry" do
    client_id = "666"

    connect_client(client_id)

    assert ConnectedClients.get(client_id) != nil
  end

  test "when the client disconects, remove its entry from the Registry" do
    client_id = "111"

    client = connect_client(client_id)
    disconnect(client)

    assert ConnectedClients.get(client_id) == nil
  end
end
