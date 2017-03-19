defmodule FollowerMaze.Types.Event do
  defstruct [:sequence, :type, :from, :to, :raw_event]

  def from(raw_event) do
    [sequence, type, from, to] = parse(raw_event)

    %__MODULE__{sequence: sequence, type: type, from: from, to: to, raw_event: raw_event}
  end

  defp parse(raw_event) do
    parsed = String.replace(raw_event, "\n", "") |> String.split("|")
    [Enum.at(parsed, 0), Enum.at(parsed, 1), Enum.at(parsed, 2), Enum.at(parsed, 3)]
  end
end
