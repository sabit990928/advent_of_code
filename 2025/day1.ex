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

  def decipher() do
    movements = load()

    initial_position = 50

    {count_zero_positions(movements, initial_position, 0),
     count_all_zero_positions(movements, initial_position, 0)}
  end

  # Part 1
  # 578 too low
  def count_zero_positions([], _position, sum), do: sum

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

  # Part 2
  # 7398 too high
  def count_all_zero_positions([], _position, sum), do: sum

  def count_all_zero_positions(movements, position, sum) do
    {direction, steps} = hd(movements)
    round_touches = div(steps, 100)
    steps = if(steps > 100, do: rem(steps, 100), else: steps)

    {next_position, move_touch} =
      case direction do
        "L" when position > steps -> {position - steps, 0}
        "L" -> {rem(100 + position - steps, 100), 1}
        "R" when position + steps > 100 -> {rem(position + steps, 100), 1}
        "R" -> {position + steps, 0}
      end

    move_touch = if(position == 0 || next_position == 0, do: 0, else: move_touch)
    next_position = if next_position == 100, do: 0, else: next_position

    total_zero_touches = round_touches + move_touch

    new_sum = if next_position == 0, do: sum + 1, else: sum
    new_sum = new_sum + total_zero_touches

    count_all_zero_positions(tl(movements), next_position, new_sum)
  end
end
