defmodule Day11 do
  def count_stones() do
    stones = File.read!("input11.txt") |> String.split()

    # update_the_order(stones, 25, [])

    # Concurrent way
    # tasks = Enum.map(stones, &Task.async(fn -> update_the_order([&1], 25, []) end))
    # Task.await_many(tasks, :infinity) |> IO.inspect() |> Enum.sum()

    # Part 2
    stones = Enum.map(stones, &{String.to_integer(&1), 0})

    # 45-50 starts to be significantly slow. While it's quicker than previous solution.
    # tasks = Enum.map(stones, &Task.async(fn -> log_update_the_order([&1], 20, []) end))
    # Task.await_many(tasks, :infinity) |> IO.inspect() |> Enum.sum()

    log_update_the_order(stones, 55, []) |> length()
  end

  # Part 2. Slow
  def log_update_the_order([] = _numbers, 1 = _blink_amount, acc), do: acc

  def log_update_the_order([] = _numbers, blink_amount, acc) do
    if length(acc) > 200_000 do
      # IO.inspect(blink_amount)
      numbers = Enum.chunk_every(acc, 1000)

      tasks =
        Enum.map(numbers, &Task.async(fn -> log_update_the_order(&1, blink_amount - 1, []) end))

      acc = Task.await_many(tasks, :infinity) |> List.flatten()
      # IO.inspect(acc, label: "acc after 2000")
      # log_update_the_order(acc, blink_amount - 2, [])
    else
      log_update_the_order(acc, blink_amount - 1, [])
    end
  end

  def log_update_the_order([{0, _} | rest], blink_amount, acc) do
    log_update_the_order(rest, blink_amount, [{1, 0} | acc])
  end

  def log_update_the_order([{stone, times} | rest], blink_amount, acc) do
    # IO.inspect(blink_amount, label: "blink_amount")

    digits_length =
      ((:math.log10(stone) + :math.log10(2024) * times) |> Float.floor() |> trunc()) + 1

    even_digits? = rem(digits_length, 2) == 0

    stones =
      if even_digits? do
        stone = (stone * :math.pow(2024, times)) |> trunc()

        {left, right} =
          Integer.to_string(stone) |> String.split_at(div(digits_length, 2))

        left = String.to_integer(left)
        right = String.to_integer(right)

        [{left, 0}, {right, 0}]
      else
        [{stone, times + 1}]
      end

    log_update_the_order(rest, blink_amount, stones ++ acc)
  end

  # Part 1
  # Sequential way
  def update_the_order([] = _numbers, 1 = _blink_amount, acc), do: length(acc)

  def update_the_order([] = _numbers, blink_amount, acc),
    do: update_the_order(acc, blink_amount - 1, [])

  def update_the_order([stone | rest], blink_amount, acc) do
    even_digits? = String.length(stone) |> rem(2) == 0

    stones =
      case {stone, even_digits?} do
        {"0", _} ->
          ["1"]

        {stone, true} ->
          {left, right} = String.split_at(stone, div(String.length(stone), 2))
          right = String.to_integer(right) |> Integer.to_string()
          [left, right]

        {stone, false} ->
          [String.to_integer(stone) |> Kernel.*(2024) |> Integer.to_string()]
      end

    # IO.inspect(acc ++ stones, label: "acc")
    update_the_order(rest, blink_amount, acc ++ stones)
  end

  # Idea for part 2
  # Multiply not required to happen every time
  # Try to work with input as a string
end
