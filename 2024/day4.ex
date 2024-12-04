defmodule Day4 do
  @moduledoc """
  https://adventofcode.com/2024/day/4
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

    vertical_all_amount =
      vertical_input
      |> Enum.map(&(Regex.scan(~r/XMAS|SAMX/, &1) |> length()))
      |> Enum.sum()

    normal_order_amount + reversed_amount + vertical_all_amount
  end
end
