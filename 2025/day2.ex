defmodule Day do
  @moduledoc """
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
  1698522-1698528,446443-446449,38593856-38593862,565653-565659,
  824824821-824824827,2121212118-2121212124

  https://adventofcode.com/2025/day/2
  """

  def load() do
    case File.read("input2.txt") do
      {:ok, body} ->
        body
        |> String.split(",", trim: true)
        |> Enum.map(&String.split(&1, "-"))
        |> Enum.map(fn [start_range, end_range] ->
          {String.to_integer(start_range), String.to_integer(end_range)}
        end)

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end

  def sum_corrupted_ids() do
    ranges = load()

    {list_corrupted_ids(ranges, []) |> Enum.sum(),
     list_corrupted_id_patterns(ranges, []) |> Enum.sum()}
  end

  # Part 1
  def list_corrupted_ids([], corrupted_ids), do: corrupted_ids

  def list_corrupted_ids(ranges, corrupted_ids) do
    {first, last} = hd(ranges)

    ids_in_range =
      Enum.filter(first..last, fn id ->
        odd? = Integer.digits(id) |> length() |> rem(2) == 0
      end)
      |> Enum.filter(fn id ->
        id = Integer.to_string(id)
        middle = String.length(id) |> div(2)
        {first_half, second_half} = String.split_at(id, middle)

        first_half == second_half
      end)

    list_corrupted_ids(tl(ranges), corrupted_ids ++ ids_in_range)
  end

  # Part 2
  def list_corrupted_id_patterns([], corrupted_ids), do: corrupted_ids

  def list_corrupted_id_patterns(ranges, corrupted_ids) do
    {first, last} = hd(ranges)

    ids_in_range =
      Enum.filter(first..last, fn id ->
        half_index = div(Integer.digits(id) |> length(), 2) + 1

        half_digits =
          Integer.digits(id) |> Enum.take(half_index) |> Enum.map(&Integer.to_string(&1))

        found_pattern? = false
        pattern = ""
        id = Integer.to_string(id)
        in_pattern? = following_repetitive_pattern?(id, half_digits, pattern, found_pattern?)
      end)

    list_corrupted_id_patterns(tl(ranges), corrupted_ids ++ ids_in_range)
  end

  def following_repetitive_pattern?(id, half_digits, _, true = found_pattern?), do: true
  def following_repetitive_pattern?(id, [] = _half_digits, _, _found_pattern?), do: false

  def following_repetitive_pattern?(id, half_digits, "", found_pattern?) do
    pattern = hd(half_digits)
    following_repetitive_pattern?(id, tl(half_digits), pattern, found_pattern?)
  end

  def following_repetitive_pattern?(id, half_digits, pattern, found_pattern?) do
    id_chunks = String.split(id, pattern)
    found_pattern? = Enum.all?(id_chunks, &(&1 == ""))

    if(found_pattern?) do
      following_repetitive_pattern?(id, half_digits, pattern, found_pattern?)
    else
      pattern = "#{pattern}#{hd(half_digits)}"
      following_repetitive_pattern?(id, tl(half_digits), pattern, found_pattern?)
    end
  end
end
