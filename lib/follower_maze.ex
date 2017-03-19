defmodule FollowerMaze do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(FollowerMaze.Registries.Events, []),
      supervisor(FollowerMaze.Registries.Followers, []),
      supervisor(FollowerMaze.Registries.ConnectedClients, []),
      worker(FollowerMaze.Server.ClientHandler, [9099]),
      worker(FollowerMaze.Server.EventHandler, [9090])
    ]

    opts = [strategy: :one_for_one, name: SoundCloudPrototype.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
