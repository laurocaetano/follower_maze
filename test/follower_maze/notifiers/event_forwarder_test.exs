defmodule FollowerMaze.Notifiers.EventForwarderTest do
  use ExUnit.Case

  alias FollowerMaze.Registries.Followers
  alias FollowerMaze.Notifiers.EventForwarder
  alias FollowerMaze.Types.Event

  test "broadcasts the event to all connected clients" do
    event = Event.from("542532|B\n")
    awaiting_message = connect_client("123")

    EventForwarder.broadcast(event)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "send follow events to the user being followed" do
    event = Event.from("666|F|60|50\n")
    awaiting_message = connect_client(event.to)

    EventForwarder.follow(event)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "send private message to a specific user" do
    event = Event.from("43|P|32|56\n")
    awaiting_message = connect_client(event.to)

    EventForwarder.private_message(event)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "send status update to the user's followers" do
    event = Event.from("634|S|32\n")
    follower_id = "11"
    Followers.follow(event.from, follower_id)
    awaiting_message = connect_client(follower_id)

    EventForwarder.status_update(event)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  def connect_client(id) do
    server = Socket.TCP.connect!("localhost", 9099, packet: :line)
    Socket.Stream.send!(server, "#{id}\n")
    :timer.sleep(100) # wait until we send the tcp event
    Task.async(fn() -> Socket.Stream.recv!(server) end)
  end
end
