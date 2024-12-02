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

  # Part 1
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

  # Part 2
  # 550 is too high
  def count_tolerated_progressions() do
    reports = load()

    Enum.map(reports, fn level ->
      maybe_find_tolerated_level(level)
    end)
    |> Enum.filter(&(&1 == true))
    |> length()
  end

  def maybe_find_tolerated_level(level) do
    current = hd(level)
    [next | tail] = tl(level)

    increasing? = tolerated_increasing?(current, next, tail, false)
    decreasing? = tolerated_decreasing?(current, next, tail, false)

    increasing? || decreasing?
  end

  def tolerated_increasing?(current, next, [], skipped?) do
    if skipped? == false do
      true
    else
      cond do
        current >= next -> false
        next - current > 3 -> false
        true -> true
      end
    end
  end

  def tolerated_increasing?(current, next, tail, skipped?) do
    usual? =
      cond do
        current >= next -> false
        next - current > 3 -> false
        true -> true
      end

    pick_next? =
      cond do
        skipped? == false and next >= hd(tail) -> false
        skipped? == false and hd(tail) - next > 3 -> false
        true -> true
      end

    pick_current? =
      cond do
        skipped? == false and current >= hd(tail) -> false
        skipped? == false and hd(tail) - current > 3 -> false
        true -> true
      end

    case {usual?, pick_next?, pick_current?} do
      {true, _, _} -> tolerated_increasing?(next, hd(tail), tl(tail), skipped?)
      {false, true, _} -> tolerated_increasing?(next, hd(tail), tl(tail), true)
      {false, _, true} -> tolerated_increasing?(current, hd(tail), tl(tail), true)
      {_, _, _} -> false
    end
  end

  def tolerated_decreasing?(current, next, [], skipped?) do
    if skipped? == false do
      true
    else
      cond do
        current <= next -> false
        current - next > 3 -> false
        true -> true
      end
    end
  end

  def tolerated_decreasing?(current, next, tail, skipped?) do
    usual? =
      cond do
        current <= next -> false
        current - next > 3 -> false
        true -> true
      end

    pick_next? =
      cond do
        skipped? == false and next <= hd(tail) -> false
        skipped? == false and next - hd(tail) > 3 -> false
        true -> true
      end

    pick_current? =
      cond do
        skipped? == false and current <= hd(tail) -> false
        skipped? == false and current - hd(tail) > 3 -> false
        true -> true
      end

    case {usual?, pick_next?, pick_current?} do
      {true, _, _} -> tolerated_decreasing?(next, hd(tail), tl(tail), skipped?)
      {false, true, _} -> tolerated_decreasing?(next, hd(tail), tl(tail), true)
      {false, _, true} -> tolerated_decreasing?(current, hd(tail), tl(tail), true)
      {_, _, _} -> false
    end
  end
end
