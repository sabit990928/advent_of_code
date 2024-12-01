defmodule Day1 do
  @moduledoc """
  https://adventofcode.com/2024/day/1

  Run in the terminal with:
    `iex day1.ex`

  Load example: `Day1.load "input1.txt"`
  """

  @doc """
  Returns two lists. One for each column.
  """
  def load() do
    case File.read("input1.txt") do
      {:ok, body} ->
        body
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, " ", trim: true))
        |> Enum.map(&List.to_tuple(&1))
        |> Enum.unzip()

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end

  def total_distance() do
    {first_historians, second_historians} = load()
    first_historians = Enum.sort(first_historians) |> Enum.map(&String.to_integer(&1))
    second_historians = Enum.sort(second_historians) |> Enum.map(&String.to_integer(&1))

    Enum.zip(first_historians, second_historians)
    |> Enum.map(fn {left_number, right_number} ->
      distance = Kernel.abs(left_number - right_number)

      distance
    end)
    |> Enum.sum()
  end
end
