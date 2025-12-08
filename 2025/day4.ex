defmodule Day do
  def load() do
    {:ok, body} = File.read("input4.txt")

    body
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes(&1))
  end
end
