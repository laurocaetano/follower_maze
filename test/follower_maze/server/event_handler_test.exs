defmodule FollowerMaze.Server.EventHandlerTest do
  use ExUnit.Case

  import FollowerMaze.TestHelpers

  alias FollowerMaze.Registries.Events
  alias FollowerMaze.Types.Event

  test "when receiving a new event, adds to the EventRegistry" do
    raw_event = "666|F|60|50\n"
    event = Event.from(raw_event)

    emit_event(event)

    assert Events.pop(event.sequence) == event
  end
end
