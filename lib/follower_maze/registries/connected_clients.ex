defmodule FollowerMaze.Registries.ConnectedClients do
  use GenServer

  # Public interface

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def register(id, client) do
    GenServer.cast(__MODULE__, {:register, id, client})
  end

  def unregister(id) do
    GenServer.cast(__MODULE__, {:unregister, id})
  end

  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  # Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:register, id, client}, state) do
    {:noreply, Map.put(state, id, client)}
  end

  def handle_cast({:unregister, id}, state) do
    {:noreply, Map.delete(state, id)}
  end

  def handle_call({:get, id}, _from, state) do
    {:reply, Map.get(state, id), state}
  end
end
