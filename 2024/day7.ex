defmodule Day7 do
  @moduledoc """
  https://adventofcode.com/2024/day/7
  """

  # Part 1
  def sum_equations() do
    problems =
      File.read!("input7.txt")
      |> String.split("\n")
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(fn [sum, options] ->
        {String.to_integer(sum), String.split(options) |> Enum.map(&String.to_integer(&1))}
      end)

    # From left to right

    Enum.map(problems, fn {sum, options} ->
      equations = generate_operator_combinations(length(options))
      accumulator = hd(options)

      if Enum.any?(equations, fn equation ->
           has_right_equation?(sum, tl(options), equation, accumulator)
         end) do
        sum
      else
        0
      end
    end)
    |> Enum.sum()
  end

  def has_right_equation?(sum, [] = _options, [] = _formula, accumulator) do
    sum == accumulator
  end

  def has_right_equation?(sum, [a | options], [operator | formula], accumulator) do
    accumulator =
      case operator do
        "+" -> Kernel.+(a, accumulator)
        "*" -> Kernel.*(a, accumulator)
      end

    has_right_equation?(sum, options, formula, accumulator)
  end

  # Find all the possible combination for N amount of numbers if there are M amount of operators
  # Pass heads of each options and combination from above until if found the one that match

  def generate_operator_combinations(options_amount \\ 3, operations \\ ["+", "*"]) do
    # for operator_1 <- operations, operator_2 <- operations do
    #   [operator_1, operator_2]
    # end

    # acc: [[]]
    # acc: [["+"], ["*"]]
    # acc: [["+", "+"], ["*", "+"], ["+", "*"], ["*", "*"]]
    Enum.reduce(1..(options_amount - 1), [[]], fn _, acc ->
      for equation <- acc, operator <- operations do
        [operator | equation]
      end
    end)
  end

  # 2 -> 2
  # 3 -> 4
  # 4 -> + + +, * * *, +*+, *+*, ++*, **+, *++, +** -> 8
  # N -> power 2, N
end
