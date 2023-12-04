defmodule Task do
  @max_red 12
  @max_green 13
  @max_blue 14

  def load(file) do
    case File.read(file) do
      {:ok, body} ->
        body
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, "; ", trim: true))

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end

  def calculate(input_list) do
    data =
      Enum.map(input_list, fn data_list ->
        Enum.map(data_list, fn round ->
          round = String.trim(round)
        end)
      end)

    parsed_data = convert_data(data)
    with_index = Enum.with_index(parsed_data, 1)

    Enum.map(with_index, fn {game_list, index} ->
      final =
        Enum.map(game_list, fn round_map ->
          red_amount = round_map["red"] || 0
          green_amount = round_map["green"] || 0
          blue_amount = round_map["blue"] || 0

          if red_amount > @max_red || green_amount > @max_green || blue_amount > @max_blue do
            IO.inspect(game_list, label: "game_list, with_index")
            :invalid
          else
            :valid
          end
        end)
        |> Enum.filter(fn valid_atom -> valid_atom == :invalid end)

      {final, index}
    end)
    |> Enum.filter(fn {list, index} ->
      length(list) == 0
    end)
    |> Enum.map(fn {_list, index} -> index end)
    |> Enum.sum()
  end

  def convert_data(data) do
    Enum.map(data, &convert_sublist(&1))
  end

  defp convert_sublist(sublist) do
    Enum.map(sublist, &convert_item(&1))
  end

  defp convert_item(item) do
    item
    |> String.split(~r/\s*,\s*/)
    |> Enum.reduce(%{}, &parse_color/2)
  end

  defp parse_color(color, acc) do
    [count_str, color_name] = String.split(color, " ")
    count = String.to_integer(count_str)

    Map.update(acc, color_name, count, &(&1 + count))
  end
end

sample = [
  "3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
  "1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
  "8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
  "1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
  "6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
]

# input = Task.load("input2.txt")

[
  [
    "2 red, 2 green",
    "1 red, 1 green, 2 blue"
  ],
  [
    "5 green, 4 red, 7 blue",
    "7 red, 15 blue"
  ]
]

[
  [
    %{red: 2, green: 2},
    %{red: 1, green: 1, blue: 2}
  ],
  [
    %{red: 4, green: 5, blue: 7},
    %{red: 7, blue: 15}
  ]
]
