defmodule FollowerMaze.Registries.EventsTest do
  use ExUnit.Case

  alias FollowerMaze.Registries.Events
  alias FollowerMaze.Types.Event

  test "puts Event" do
    raw_event = "666|F|60|50\n"
    event = Event.from(raw_event)

    Events.put(raw_event)

    assert Events.pop(event.sequence) == event
  end

  test "pops Event when sequence is a String" do
    raw_event = "666|F|60|50\n"
    event = Event.from(raw_event)

    Events.put(raw_event)

    assert Events.pop(event.sequence) == event
    assert Events.pop(event.sequence) == nil
  end

  test "pops Event when sequence is an Integer" do
    raw_event = "666|F|60|50\n"
    event = Event.from(raw_event)
    sequence = String.to_integer(event.sequence)

    Events.put(raw_event)

    assert Events.pop(sequence) == event
    assert Events.pop(sequence) == nil
  end
end
