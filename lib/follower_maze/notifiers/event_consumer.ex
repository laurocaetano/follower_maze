defmodule FollowerMaze.Notifiers.EventConsumer do
  alias FollowerMaze.Registries.Events
  alias FollowerMaze.Registries.Followers
  alias FollowerMaze.Types.Event
  alias FollowerMaze.Notifiers.EventForwarder

  def start_link(sequence) do
    pid = spawn_link(fn -> init(sequence) end)

    {:ok, pid}
  end

  def init(sequence) do
    handle_demand(sequence)
  end

  defp handle_demand(sequence) do
    event = Events.pop(sequence)

    if event do
      notify_clients(event)
      handle_demand(sequence + 1)
    else
      handle_demand(sequence)
    end
  end

  defp notify_clients(%Event{type: "F"} = event) do
    Followers.follow(event.to, event.from)
    EventForwarder.follow(event)
  end

  defp notify_clients(%Event{type: "P"} = event) do
    EventForwarder.private_message(event)
  end

  defp notify_clients(%Event{type: "B"} = event) do
    EventForwarder.broadcast(event)
  end

  defp notify_clients(%Event{type: "U"} = event) do
    Followers.unfollow(event.to, event.from)
  end

  defp notify_clients(%Event{type: "S"} = event) do
    EventForwarder.status_update(event)
  end
end
