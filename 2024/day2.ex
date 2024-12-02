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
  # 484 is too high
  # 508 is wrong
  def count_tolerated_progressions() do
    reports = load()
    # Filter equal case?
    # reports =
    #   Enum.map(reports, fn level ->
    #     level_1 = hd(level)
    #     level_2 = Enum.at(level, 1)

    #     cond =
    #       cond do
    #         level_1 < level_2 and level_2 - level_1 <= 3 -> increasing?(level_1, tl(level))
    #         level_1 > level_2 and level_1 - level_2 <= 3 -> decreasing?(level_1, tl(level))
    #         true -> false
    #       end

    #     if cond do
    #       nil
    #     else
    #       level
    #     end
    #   end)
    #   |> Enum.filter(&(&1 != nil))

    Enum.map(reports, fn level ->
      cond = maybe_find_tolerated_level(level)
      # IO.inspect("final: #{cond}")

      # if cond do
      #   IO.inspect(level ++ [""], limit: :infinity)
      # end
    end)
    |> Enum.filter(&(&1 == true))
    |> length()
  end

  def maybe_find_tolerated_level(level) do
    # previous = hd(level)
    # [current | tail] = tl(level)
    # [next | tail] = tl(tail)
    current = hd(level)
    [next | tail] = tl(level)
    # [next | tail] = tl(tail)

    increasing? = tolerated_increasing?(nil, current, next, tail, false)
    decreasing? = tolerated_decreasing?(nil, current, next, tail, false)

    # increasing? = tolerated_increasing?(previous, current, next, tail, false)
    # decreasing? = tolerated_decreasing?(previous, current, next, tail, false)

    increasing? || decreasing?
  end

  def tolerated_increasing?(previous, current, next, [], skipped?) do
    if skipped? == false do
      # Check jump
      true
    else
      cond do
        current >= next -> false
        next - current > 3 -> false
        true -> true
      end
    end
  end

  def tolerated_increasing?(previous, current, next, tail, skipped?) do
    # IO.inspect("#{previous} #{current} #{next}", label: "Levels")
    # IO.inspect(skipped?, label: "skipped?")

    # IO.inspect(tail, label: "tail")
    # NO
    usual? =
      cond do
        current >= next -> false
        next - current > 3 -> false
        true -> true
      end

    # Need to be enhanced
    pick_next? =
      cond do
        skipped? == true -> false
        skipped? == false and next >= hd(tail) -> false
        skipped? == false and hd(tail) - next > 3 -> false
        skipped? == false and previous == nil -> true
        skipped? == false and next - previous > 3 -> false
        true -> true
      end

    # [41, 41, 44, 44, 46, ""]
    pick_current? =
      cond do
        skipped? == true -> false
        skipped? == false and current >= hd(tail) -> false
        skipped? == false and hd(tail) - current > 3 -> false
        skipped? == false and previous == nil -> true
        true -> true
      end

    # IO.inspect(usual?, label: "usual?")
    # IO.inspect(pick_current?, label: "pick_current?")
    # IO.inspect(pick_next?, label: "pick_next?")
    # IO.inspect("----")

    case {usual?, pick_next?, pick_current?} do
      {true, _, _} -> tolerated_increasing?(current, next, hd(tail), tl(tail), skipped?)
      {false, _, true} -> tolerated_increasing?(previous, current, hd(tail), tl(tail), true)
      {false, true, _} -> tolerated_increasing?(previous, next, hd(tail), tl(tail), true)
      {_, _, _} -> false
    end
  end

  def tolerated_decreasing?(previous, current, next, [], skipped?) do
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

  def tolerated_decreasing?(previous, current, next, tail, skipped?) do
    # IO.inspect("#{previous} #{current} #{next}", label: "Levels decreasing")
    # IO.inspect(skipped?, label: "skipped?")

    # IO.inspect(tail, label: "tail")
    # [37, 36, 39, 38, 37, 34]
    usual? =
      cond do
        current <= next -> false
        current - next > 3 -> false
        true -> true
      end

    pick_next? =
      cond do
        skipped? == true -> false
        skipped? == false and next <= hd(tail) -> false
        skipped? == false and next - hd(tail) > 3 -> false
        skipped? == false and previous == nil -> true
        skipped? == false and previous <= next -> false
        skipped? == false and previous - next > 3 -> false
        true -> true
      end

    pick_current? =
      cond do
        skipped? == true -> false
        skipped? == false and current <= hd(tail) -> false
        skipped? == false and current - hd(tail) > 3 -> false
        skipped? == false and previous == nil -> true
        true -> true
      end

    # IO.inspect(usual?, label: "usual?")
    # IO.inspect(pick_current?, label: "pick_current?")
    # IO.inspect(pick_next?, label: "pick_next?")
    # IO.inspect("----")

    case {usual?, pick_next?, pick_current?} do
      {true, _, _} -> tolerated_decreasing?(current, next, hd(tail), tl(tail), skipped?)
      {false, _, true} -> tolerated_decreasing?(previous, current, hd(tail), tl(tail), true)
      {false, true, _} -> tolerated_decreasing?(previous, next, hd(tail), tl(tail), true)
      {_, _, _} -> false
    end
  end

  # Cover this:
  # [55, 57, 63, 59, 64]
  # Compare to the previous one as well

  # 421 | 440 -> 19
  # 129

  # [41, 41, 44, 44, 46, ""]
end
