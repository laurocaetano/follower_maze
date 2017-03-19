defmodule FollowerMaze.Registries.Followers do
  use GenServer

  # Public interface

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def follow(user, follower) do
    GenServer.cast(__MODULE__, {:follow, user, follower})
  end

  def unfollow(user, follower) do
    GenServer.cast(__MODULE__, {:unfollow, user, follower})
  end

  def followers_of(user) do
    GenServer.call(__MODULE__, {:followers_of, user})
  end

  # Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:follow, user, follower}, state) do
    current_followers = Map.get(state, user, MapSet.new)
    new_followers = MapSet.put(current_followers, follower)

    {:noreply, Map.put(state, user, new_followers)}
  end

  def handle_cast({:unfollow, user, follower}, state) do
    current_followers = Map.get(state, user, MapSet.new)
    new_followers = MapSet.delete(current_followers, follower)

    {:noreply, Map.put(state, user, new_followers)}
  end

  def handle_call({:followers_of, user}, _from, state) do
    followers = Map.get(state, user, MapSet.new)

    {:reply, followers, state}
  end
end
