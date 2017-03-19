defmodule FollowerMaze.Server.EventHandlerTest do
  use ExUnit.Case

  alias FollowerMaze.Registries.Events
  alias FollowerMaze.Types.Event

  test "when receiving a new event, adds to the EventRegistry" do
    raw_event = "666|F|60|50\n"
    event = Event.from(raw_event)

    {:ok, source} = :gen_tcp.connect('localhost', 9090, [])
    :gen_tcp.send(source, raw_event)

    :timer.sleep(100) # wait until we send the tcp event

    assert Events.pop(event.sequence) == event
  end
end
