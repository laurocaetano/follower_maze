defmodule FollowerMaze.Registries.Events do
  use GenServer

  alias FollowerMaze.Types.Event

  # Public interface

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def put(raw_event) do
    GenServer.cast(__MODULE__, {:put, raw_event})
  end

  def pop(sequence) do
    GenServer.call(__MODULE__, {:pop, sequence})
  end

  # Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:put, raw_event}, state) do
    event = Event.from(raw_event)

    {:noreply, Map.put(state, event.sequence, event)}
  end

  def handle_call({:pop, sequence}, _from, state) when is_integer(sequence) do
    {event, remaining} = Map.pop(state, Integer.to_string(sequence))

    {:reply, event, remaining}
  end

  def handle_call({:pop, sequence}, _from, state) when is_binary(sequence) do
    {event, remaining} = Map.pop(state, sequence)

    {:reply, event, remaining}
  end
end
