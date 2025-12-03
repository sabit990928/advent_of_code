defmodule Day1 do
  def load(file) do
    case File.read(file) do
      {:ok, body} ->
        body
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split(&1, " ", trim: true))
        |> Enum.map(fn line ->
          if length(line) > 1,
            do: [List.first(line), String.to_integer(List.last(line))],
            else: line
        end)
        |> List.flatten()

      {:error, _} ->
        IO.puts("Couldn't open the file.")
    end
  end

  def calculate(input_list) do
    Enum.map(input_list, fn value ->
      # has_string_number? =
      String.contains?(value, [
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine"
      ])

      # oneeight - on e8
      # twone = tw o1 or 2one

      updated_value =
        value
        |> String.replace("one", "o1e")
        |> String.replace("two", "t2o")
        |> String.replace("eight", "e8t")
        |> String.replace("three", "t3e")
        |> String.replace("four", "f4r")
        |> String.replace("five", "f5e")
        |> String.replace("six", "s6x")
        |> String.replace("seven", "s7n")
        |> String.replace("nine", "n9e")

      IO.inspect("#{value} | #{updated_value}", label: "updated_value")

      charlist_value = String.to_charlist(updated_value)

      number_charlist =
        Enum.map(charlist_value, fn char_number ->
          if char_number in 48..57 do
            char_number
          end
        end)
        |> Enum.filter(&(&1 !== nil))

      first = List.first(number_charlist)
      last = List.last(number_charlist)

      new_list = [first, last] |> String.Chars.to_string() |> String.to_integer() |> IO.inspect()
    end)
    |> Enum.sum()
  end

  defp replace_with_numbers(input_value) do
  end
end

sample = ["1abc2", "pqr3stu8vwx", "a1b2c3d4e5f", "treb7uchet"]

second_sample = [
  "two1nine",
  "eightwothree",
  "abcone2threexyz",
  "xtwone3four",
  "4nineeightseven2",
  "zoneight234",
  "7pqrstsixteen"
]

input = Day1.load("input1.txt")

# Day1/2 first_answer: 54843 (wrong, too low)
