defmodule FollowerMaze.Notifiers.EventForwarderTest do
  use ExUnit.Case

  import FollowerMaze.TestHelpers

  alias FollowerMaze.Registries.Followers
  alias FollowerMaze.Notifiers.EventForwarder
  alias FollowerMaze.Types.Event

  test "broadcasts the event to all connected clients" do
    event = Event.from("542532|B\n")
    awaiting_message = connect_client_and_wait_for_messages("123")

    EventForwarder.broadcast(event)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "send follow events to the user being followed" do
    event = Event.from("666|F|60|50\n")
    awaiting_message = connect_client_and_wait_for_messages(event.to)

    EventForwarder.follow(event)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "send private message to a specific user" do
    event = Event.from("43|P|32|56\n")
    awaiting_message = connect_client_and_wait_for_messages(event.to)

    EventForwarder.private_message(event)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "send status update to the user's followers" do
    event = Event.from("634|S|32\n")
    follower_id = "11"
    Followers.follow(event.from, follower_id)
    awaiting_message = connect_client_and_wait_for_messages(follower_id)

    EventForwarder.status_update(event)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end
end
