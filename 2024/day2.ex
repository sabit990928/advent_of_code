defmodule Day2 do
  @moduledoc """
  https://adventofcode.com/2024/day/2

  """

  def load() do
    case File.read("input2.txt") do
      {:ok, body} ->
        body
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, " ", trim: true))
        |> Enum.map(&Enum.map(&1, fn level_element -> String.to_integer(level_element) end))

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end

  def count_progressions() do
    reports = load()

    Enum.map(reports, fn level ->
      level_1 = hd(level)
      level_2 = Enum.at(level, 1)

      cond do
        level_1 < level_2 and level_2 - level_1 <= 3 -> increasing?(level_1, tl(level))
        level_1 > level_2 and level_1 - level_2 <= 3 -> decreasing?(level_1, tl(level))
        true -> false
      end
    end)
    |> Enum.filter(&(&1 == true))
    |> length()
  end

  def increasing?(_index, []), do: true

  def increasing?(index, [next_index | tail]) do
    cond do
      index >= next_index -> false
      next_index - index > 3 -> false
      true -> increasing?(next_index, tail)
    end
  end

  def decreasing?(_index, []), do: true

  def decreasing?(index, [next_index | tail]) do
    cond do
      index <= next_index -> false
      index - next_index > 3 -> false
      true -> decreasing?(next_index, tail)
    end
  end
end
