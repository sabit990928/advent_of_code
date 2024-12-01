defmodule Day1 do
  @moduledoc """
  https://adventofcode.com/2024/day/1

  Run in the terminal with:
    `iex day1.ex`

  Recompile: `r Day1`
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

  # Part 1
  # 1112031679111 - 222
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

  # Part 2
  # 416 is too low
  # 11119678534111 - 222
  def total_frequency() do
    {first_historians, second_historians} = load()

    Enum.frequencies_by(
      first_historians,
      &Enum.filter(second_historians, fn right -> &1 == right end)
    )
    |> Map.to_list()
    |> Enum.map(fn {similars_left, frequency} ->
      if length(similars_left) > 0 do
        similar_left = hd(similars_left) |> String.to_integer()

        frequency * similar_left * length(similars_left)
      else
        0
      end
    end)
    |> Enum.sum()
  end
end
