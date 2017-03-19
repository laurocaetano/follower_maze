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
end
