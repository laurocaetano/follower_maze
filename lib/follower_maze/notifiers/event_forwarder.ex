defmodule FollowerMaze.Notifiers.EventForwarder do
  alias FollowerMaze.Registries.ConnectedClients
  alias FollowerMaze.Registries.Followers

  def broadcast(event) do
    connected_clients = ConnectedClients.all

    Enum.map(connected_clients, fn(client) -> send_event(event.raw_event, client) end)
  end

  def follow(event) do
    send_event(event.raw_event, ConnectedClients.get(event.to))
  end

  def private_message(event) do
    send_event(event.raw_event, ConnectedClients.get(event.to))
  end

  def status_update(event) do
    followers = Followers.followers_of(event.from)
    clients_to_notify = Enum.map(followers, fn(follower) -> ConnectedClients.get(follower) end)

    Enum.map(clients_to_notify, fn(client) -> send_event(event.raw_event, client) end)
  end

  defp send_event(event_data, client) do
    if client do
      :gen_tcp.send(client, event_data)
    end
  end
end
