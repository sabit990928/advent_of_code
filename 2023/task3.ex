defmodule Task do
  @moduledoc """
  https://adventofcode.com/2023/day/3
  """

  def load(file) do
    case File.read(file) do
      {:ok, body} ->
        body
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, "; ", trim: true))

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end
end

# input = Task.load("input3.txt")
