defmodule FollowerMaze.Types.EventTest do
  use ExUnit.Case, async: true

  alias FollowerMaze.Types.Event

  test "constructing an Event from a raw 'Follow' event" do
    raw_event = "666|F|60|50\n"

    event = Event.from(raw_event)

    assert %Event{sequence: "666", type: "F", from: "60", to: "50", raw_event: raw_event} == event
  end

  test "constructing an Event from a raw 'Unfollow' event" do
    raw_event = "321|U|10|20\n"

    event = Event.from(raw_event)

    assert %Event{sequence: "321", type: "U", from: "10", to: "20", raw_event: raw_event} == event
  end

  test "constructing an Event from a raw 'Private' event" do
    raw_event = "16|P|2|10\n"

    event = Event.from(raw_event)

    assert %Event{sequence: "16", type: "P", from: "2", to: "10", raw_event: raw_event} == event
  end

  test "constructing an Event from a raw 'Status' event" do
    raw_event = "88|S|9\n"

    event = Event.from(raw_event)

    assert %Event{sequence: "88", type: "S", from: "9", to: nil, raw_event: raw_event} == event
  end

  test "constructing an Event from a raw 'Broadcast' event" do
    raw_event = "100|B\n"

    event = Event.from(raw_event)

    assert %Event{sequence: "100", type: "B", from: nil, to: nil, raw_event: raw_event} == event
  end
end
