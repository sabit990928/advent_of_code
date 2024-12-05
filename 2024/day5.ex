defmodule Day5 do
  @moduledoc """
  https://adventofcode.com/2024/day/5
  """

  # Part 1
  def sum_right_middle() do
    [rules, prints] = File.read!("input5.txt") |> String.split("\n\n")
    rules = String.split(rules, "\n")
    prints = String.split(prints, "\n") |> Enum.map(&String.split(&1, ","))
    # | for rules and , for prints

    Enum.map(prints, fn line ->
      if right_order?(hd(line), tl(line), rules), do: line, else: nil
    end)
    |> Enum.reject(&(&1 == nil))
    |> Enum.map(fn line ->
      middle_index = div(length(line), 2)
      Enum.at(line, middle_index) |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def right_order?(_page, [], _rules), do: true

  def right_order?(page, other_pages, rules) do
    if(Enum.any?(other_pages, fn next_page -> (next_page <> "|" <> page) in rules end)) do
      false
    else
      right_order?(hd(other_pages), tl(other_pages), rules)
    end
  end

  # Part 2
  # 5023 too low
  def sum_wrong_middle() do
    [rules, prints] = File.read!("input5.txt") |> String.split("\n\n")
    rules = String.split(rules, "\n")
    prints = String.split(prints, "\n") |> Enum.map(&String.split(&1, ","))

    Enum.map(prints, fn line ->
      if right_order?(hd(line), tl(line), rules), do: nil, else: line
    end)
    |> Enum.reject(&(&1 == nil))
    |> Enum.map(fn line -> reorder(line, [], rules) end)
    |> Enum.map(fn line ->
      middle_index = div(length(line), 2)
      Enum.at(line, middle_index) |> String.to_integer()
    end)
    |> Enum.sum()
  end

  def reorder([first], ordered_line, _rules), do: [first | ordered_line]

  def reorder(line, ordered_line, rules) do
    last_page =
      Enum.find(line, fn page ->
        rest = line -- [page]

        Enum.map(rest, fn other_page ->
          (page <> "|" <> other_page) in rules
        end) == Enum.map(1..length(rest), fn _ -> false end)
      end)

    reorder(line -- [last_page], [last_page | ordered_line], rules)
  end
end
