defmodule Day3 do
  def load() do
    case File.read("input3.txt") do
      {:ok, body} ->
        Regex.scan(~r/mul\([\d+,\d+^\)]*\)/, body)
        # Returns something like:
        # [["mul(668,253)"],
        # ["mul(955,947)"]]
        |> Enum.map(fn elem -> Regex.scan(~r/mul\((\d+),(\d+)\)/, Enum.at(elem, 0)) end)
        |> Enum.map(fn [[_, x, y]] -> String.to_integer(x) * String.to_integer(y) end)
        |> Enum.sum()

        # Write logic to handle multiplies between don't() and do()

        # Take only ones that appear before first `don't()`
        Regex.scan(~r/mul\([\d+,\d+^\)]*\)*don't()/, body)
        |> IO.inspect()

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end
end
