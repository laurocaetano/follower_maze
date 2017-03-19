defmodule FollowerMaze.Registries.ConnectedClientsTest do
  use ExUnit.Case

  alias FollowerMaze.Registries.ConnectedClients

  test "register a new user" do
    user = %{}
    id = "123"

    ConnectedClients.register(id, user)

    assert ConnectedClients.get(id) == user
  end

  test "unregistry a new user" do
    user = %{}
    id = "123"

    ConnectedClients.register(id, user)
    ConnectedClients.unregister(id)

    assert ConnectedClients.get(id) == nil
  end

  test "returns all connected users" do
    user_1 = %{}
    id_1 = "123"
    user_2 = %{}
    id_2 = "321"

    ConnectedClients.register(id_1, user_1)
    ConnectedClients.register(id_2, user_2)

    assert ConnectedClients.all == [user_1, user_2]
  end
end
