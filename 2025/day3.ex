defmodule Day do
  @moduledoc """

  """

  def load() do
    case File.read("input3.txt") do
      {:ok, body} ->
        body
        |> String.split("\n", trim: true)
        |> Enum.map(&(String.to_integer(&1) |> Integer.digits()))

      # |> Enum.with_index(fn element, index -> {element, index} end)

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end

  def sum_max_batteries() do
    batteries = load()

    Enum.map(batteries, fn digits ->
      # Function for 1st highest
      {last_digit, rest} = List.pop_at(digits, -1)
      rest = Enum.with_index(rest, fn element, index -> {element, index} end)

      {highest_digit, hd_index} =
        Enum.sort_by(rest, fn {digit, _index} -> digit end, :desc) |> hd()

      {_first_half, second_half} = Enum.split(digits, hd_index + 1)

      # Function for 2nd highest
      second_highest = Enum.sort(second_half, :desc) |> hd()

      "#{highest_digit}#{second_highest}" |> String.to_integer()
    end)
    |> Enum.sum()
  end
end
