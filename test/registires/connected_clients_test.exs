defmodule FollowerMaze.Registries.ConnectedClientsTest do
  use ExUnit.Case, async: true

  alias FollowerMaze.Registries.ConnectedClients

  setup do
    ConnectedClients.start_link
    :ok
  end

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
