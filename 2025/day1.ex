defmodule Day do
  @moduledoc """
  Solution for day 1.
  https://adventofcode.com/2025/day/1
  """

  @doc """
  Returns a list of tuples with {direction string, steps amount}.
  """
  def load() do
    case File.read("input1.txt") do
      {:ok, body} ->
        body
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split_at(&1, 1))
        |> Enum.map(fn {direction, steps} -> {direction, String.to_integer(steps)} end)

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end

  # 578 too low
  def decipher() do
    movements = load()

    initial_position = 50

    count_zero_positions(movements, initial_position, 0)
  end

  def count_zero_positions([], position, sum), do: sum

  def count_zero_positions(movements, position, sum) do
    {direction, steps} = hd(movements)
    steps = if(steps > 100, do: rem(steps, 100), else: steps)

    next_position =
      case direction do
        "L" when position > steps -> position - steps
        "L" -> rem(100 + position - steps, 100)
        "R" when position + steps >= 100 -> rem(position + steps, 100)
        "R" -> position + steps
      end

    new_sum = if next_position == 0, do: sum + 1, else: sum
    count_zero_positions(tl(movements), next_position, new_sum)
  end
end
