defmodule FollowerMaze.Notifiers.EventConsumerTest do
  use ExUnit.Case

  alias FollowerMaze.Types.Event
  alias FollowerMaze.Registries.Events
  alias FollowerMaze.Registries.Followers
  alias FollowerMaze.Notifiers.EventConsumer

  test "consumes Follow events and notify the users" do
    event = Event.from("1|F|12|9\n")

    awaiting_message = connect_client(event.to)
    emit_event(event)

    EventConsumer.start_link(1)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "consumes Unfollow events but dont notify the users" do
    follow_event = Event.from("1|F|12|9\n")
    unfollow_event = Event.from("2|U|9|12\n")

    emit_event(follow_event)
    emit_event(unfollow_event)
    EventConsumer.start_link(1)

    followers = Followers.followers_of(unfollow_event.to)
    refute MapSet.member?(followers, unfollow_event.from)
  end

  test "consumes Private Message events and notify the users" do
    event = Event.from("1|P|32|56\n")

    awaiting_message = connect_client(event.to)
    emit_event(event)

    EventConsumer.start_link(1)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "consumes Broadcast events and notify the users" do
    connected_client_id = "333"
    event = Event.from("1|B\n")

    awaiting_message = connect_client(connected_client_id)
    emit_event(event)

    EventConsumer.start_link(1)

    data = Task.await(awaiting_message)
    assert data == event.raw_event
  end

  test "consumes Status Update events but dont notify the users" do
    follow_event = Event.from("1|F|12|9\n")
    status_update = Event.from("2|S|9\n")
    awaiting_message = connect_client(follow_event.from)

    emit_event(follow_event)
    emit_event(status_update)
    EventConsumer.start_link(1)

    data = Task.await(awaiting_message)
    assert data == status_update.raw_event
  end

  defp emit_event(event) do
    Events.put(event.raw_event)
    :timer.sleep(100)
  end

  defp connect_client(id) do
    server = Socket.TCP.connect!("localhost", 9099, packet: :line)
    Socket.Stream.send!(server, "#{id}\n")
    :timer.sleep(100) # wait until we send the tcp event
    Task.async(fn() -> Socket.Stream.recv!(server) end)
  end
end
