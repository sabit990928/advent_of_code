defmodule Day4 do
  @moduledoc """
  https://adventofcode.com/2024/day/4

  Sample: 18
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """

  def load do
    input = File.read!("input4.txt") |> String.split("\n", trim: true)

    normal_order_amount =
      input
      |> Enum.map(fn line -> Regex.scan(~r/XMAS/, line) end)
      |> Enum.map(&length(&1))
      |> Enum.sum()

    reversed_amount =
      input
      |> Enum.map(&(Regex.scan(~r/SAMX/, &1) |> length()))
      |> Enum.sum()

    vertical_input =
      input
      |> Enum.map(&String.graphemes(&1))
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list(&1))
      |> Enum.map(&Enum.join(&1))

    vertical_amount =
      vertical_input
      |> Enum.map(&(Regex.scan(~r/XMAS/, &1) |> length()))
      |> Enum.sum()

    reversed_vertical_amount =
      vertical_input
      |> Enum.map(&(Regex.scan(~r/SAMX/, &1) |> length()))
      |> Enum.sum()

    diagonal_input =
      for offset <- -(length(input) - 1)..(length(input) - 1) do
        for {line, index} <- Enum.with_index(Enum.map(input, &String.graphemes(&1))) do
          j = offset + index

          if j >= 0 and j < length(line) do
            Enum.at(line, j)
          end
        end
      end
      |> Enum.map(fn line -> Enum.reject(line, &(&1 == nil)) end)
      |> Enum.map(&Enum.join(&1))

    left_right_diagonal_amount =
      diagonal_input
      |> Enum.map(&(Regex.scan(~r/XMAS/, &1) |> length()))
      |> Enum.sum()

    reversed_left_right_diagonal_amount =
      diagonal_input
      |> Enum.map(&(Regex.scan(~r/SAMX/, &1) |> length()))
      |> Enum.sum()

    reversed_diagonal_input =
      for offset <- 0..(length(input) * 2 - 2) do
        for {line, index} <- Enum.with_index(Enum.map(input, &String.graphemes(&1))) do
          j = offset - index

          if j >= 0 and j < length(line) do
            Enum.at(line, j)
          end
        end
      end
      |> Enum.map(fn line -> Enum.reject(line, &(&1 == nil)) end)
      |> Enum.map(&Enum.join(&1))

    right_left_diagonal_amount =
      reversed_diagonal_input
      |> Enum.map(&(Regex.scan(~r/XMAS/, &1) |> length()))
      |> Enum.sum()

    reversed_right_left_diagonal_all_amount =
      reversed_diagonal_input
      |> Enum.map(&(Regex.scan(~r/SAMX/, &1) |> length()))
      |> Enum.sum()

    normal_order_amount = IO.inspect(normal_order_amount, label: "normal_order_amount")
    reversed_amount = IO.inspect(reversed_amount, label: "reversed_amount")
    vertical_amount = IO.inspect(vertical_amount, label: "vertical_amount")

    reversed_vertical_amount =
      IO.inspect(reversed_vertical_amount, label: "reversed_vertical_amount")

    left_right_diagonal_amount =
      IO.inspect(left_right_diagonal_amount, label: "left_right_diagonal_amount")

    reversed_left_right_diagonal_amount =
      IO.inspect(reversed_left_right_diagonal_amount,
        label: "reversed_left_right_diagonal_amount"
      )

    right_left_diagonal_amount =
      IO.inspect(right_left_diagonal_amount, label: "right_left_diagonal_amount")

    reversed_right_left_diagonal_all_amount =
      IO.inspect(reversed_right_left_diagonal_all_amount,
        label: "reversed_right_left_diagonal_all_amount"
      )

    normal_order_amount + reversed_amount +
      vertical_amount + reversed_vertical_amount +
      left_right_diagonal_amount + reversed_left_right_diagonal_amount +
      right_left_diagonal_amount + reversed_right_left_diagonal_all_amount
  end

  # 2390 is too low, bur handy?
end
