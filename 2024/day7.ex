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
        updated_equations = generate_operator_combinations(length(options), ["+", "*", "||"])

        if Enum.any?(updated_equations, fn equation ->
             # Part 2 addition
             # 31304694714407 is too low
             # Wrong approach
             #  options = maybe_concat_options(options, equation, [])
             #  equation = Enum.reject(equation, &(&1 == "||"))

             accumulator = hd(options)
             has_right_equation?(sum, tl(options), equation, accumulator)
           end) do
          sum
        else
          0
        end
      end
    end)
    |> Enum.sum()
  end

  def has_right_equation?(sum, [] = _options, [] = _formula, accumulator) do
    sum == accumulator
  end

  def has_right_equation?(sum, _, _, accumulator) when accumulator > sum, do: false

  def has_right_equation?(sum, [a | options], [operator | formula], accumulator) do
    accumulator =
      case operator do
        "+" -> Kernel.+(a, accumulator)
        "*" -> Kernel.*(a, accumulator)
        "||" -> "#{accumulator}#{a}" |> String.to_integer()
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

  # 2 3 4 5    + || *
  # acc - 2; 3, +
  # 5,

  # [5, 519, 507, 83]
  # ["||", "+", "||"]

  # + || * || concat -> all in the same time as another approach

  # Not needed at all. Made because of my stupidness.
  # I misread the instruction and made bit of overengineering.

  # BUT: That was really interesting problem to solve.
  # INSTRUCTION: Concat options first, then make sure that you have right answer.
  def maybe_concat_options([], _, final_options), do: final_options
  def maybe_concat_options([a], [], final_options), do: final_options ++ [a]

  def maybe_concat_options([a, b | options], ["||" | formula], final_options) do
    ab = "#{a}#{b}" |> String.to_integer()
    maybe_concat_options([ab | options], formula, final_options)
  end

  def maybe_concat_options([a, b, c | options], [operation, "||" | formula], final_options) do
    bc = "#{b}#{c}" |> String.to_integer()
    maybe_concat_options([a, bc | options], [operation | formula], final_options)
  end

  def maybe_concat_options([a | options], [_ | formula], final_options) do
    maybe_concat_options(options, formula, final_options ++ [a])
  end
end
