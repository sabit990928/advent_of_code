defmodule Day6 do
  # Part 1
  def run_guard() do
    map =
      File.read!("input6.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes(&1))

    # Pass right, left, up, down atoms
    # Make decision to forward and zip/unzip depend on that
    no_guard_map = make_map(map, :up)

    IO.inspect(no_guard_map, label: "no_guard_map", limit: :infinity)

    no_guard_map
    |> Enum.map(fn line -> Enum.filter(line, &(&1 == "X")) |> length() end)
    |> Enum.sum()
  end

  def make_map(map, :up) do
    # Go up

    # ["#", ".", ".", ".", ".", ".", "^", ".", ".", "."]
    # Zipped move left
    vertical = Enum.zip(map) |> Enum.map(&Tuple.to_list(&1)) |> Enum.with_index()

    case Enum.find(vertical, fn {line, _index} -> "^" in line end) do
      nil ->
        map

      {line, line_index} ->
        indexed_line = Enum.with_index(line)
        {_, index_of_guard} = Enum.find(indexed_line, fn {symbol, _index} -> symbol == "^" end)

        i_closest_wall = find_backward_wall(line, index_of_guard)
        i_closest_wall = if(i_closest_wall, do: i_closest_wall + 1, else: nil)
        moved_line = move_back(line, index_of_guard, i_closest_wall)

        updated_vertical = List.replace_at(vertical, line_index, {moved_line, line_index})

        updated_map =
          Enum.map(updated_vertical, fn {line, _} -> line end)
          |> Enum.zip()
          |> Enum.map(&Tuple.to_list(&1))

        make_map(updated_map, :right)
    end
  end

  def make_map(map, :down) do
    vertical = Enum.zip(map) |> Enum.map(&Tuple.to_list(&1)) |> Enum.with_index()

    case Enum.find(vertical, fn {line, _index} -> "^" in line end) do
      nil ->
        map

      {line, line_index} ->
        indexed_line = Enum.with_index(line)
        {_, index_of_guard} = Enum.find(indexed_line, fn {symbol, _index} -> symbol == "^" end)

        i_closest_wall = find_forward_wall(line, index_of_guard)
        i_closest_wall = if(i_closest_wall, do: i_closest_wall - 1, else: nil)
        moved_line = move_forward(line, index_of_guard, i_closest_wall)

        updated_vertical = List.replace_at(vertical, line_index, {moved_line, line_index})

        updated_map =
          Enum.map(updated_vertical, fn {line, _} -> line end)
          |> Enum.zip()
          |> Enum.map(&Tuple.to_list(&1))

        make_map(updated_map, :left)
    end
  end

  def make_map(old_map, :right) do
    # Turn right
    map = old_map |> Enum.with_index()

    case Enum.find(map, fn {line, _index} -> "^" in line end) do
      nil ->
        old_map

      {line, line_index} ->
        indexed_line = Enum.with_index(line)
        {_, index_of_guard} = Enum.find(indexed_line, fn {symbol, _index} -> symbol == "^" end)

        i_closest_wall = find_forward_wall(line, index_of_guard)
        i_closest_wall = if(i_closest_wall, do: i_closest_wall - 1, else: nil)
        moved_line = move_forward(line, index_of_guard, i_closest_wall)

        updated_map = List.replace_at(old_map, line_index, moved_line)

        make_map(updated_map, :down)
    end
  end

  def make_map(old_map, :left) do
    map = old_map |> Enum.with_index()

    case Enum.find(map, fn {line, _index} -> "^" in line end) do
      nil ->
        old_map

      {line, line_index} ->
        indexed_line = Enum.with_index(line)
        {_, index_of_guard} = Enum.find(indexed_line, fn {symbol, _index} -> symbol == "^" end)

        i_closest_wall = find_backward_wall(line, index_of_guard)
        i_closest_wall = if(i_closest_wall, do: i_closest_wall + 1, else: nil)
        moved_line = move_back(line, index_of_guard, i_closest_wall)

        updated_map = List.replace_at(old_map, line_index, moved_line)

        make_map(updated_map, :up)
    end
  end

  def move_forward(line, guard_index, nil = wall_index) do
    if guard_index + 1 > length(line) do
      List.replace_at(line, guard_index, "X")
    else
      line = List.replace_at(line, guard_index, "X")
      move_forward(line, guard_index + 1, wall_index)
    end
  end

  def move_forward(line, guard_index, wall_index) when guard_index == wall_index do
    List.replace_at(line, guard_index, "^")
  end

  def move_forward(line, guard_index, wall_index) do
    line = List.replace_at(line, guard_index, "X")
    move_forward(line, guard_index + 1, wall_index)
  end

  # Stop if index is out of bounds
  defp find_forward_wall(_line, -1), do: nil
  defp find_forward_wall(line, index) when length(line) < index, do: nil

  defp find_forward_wall(line, index) do
    if Enum.at(line, index) == "#" do
      # Return immediately when the condition is met
      index
    else
      # Recur with the next index
      find_forward_wall(line, index + 1)
    end
  end

  def move_back(line, guard_index, nil = wall_index) do
    if guard_index - 1 < 0 do
      List.replace_at(line, guard_index, "X")
    else
      line = List.replace_at(line, guard_index, "X")
      move_back(line, guard_index - 1, wall_index)
    end
  end

  def move_back(line, guard_index, wall_index) when guard_index == wall_index do
    List.replace_at(line, guard_index, "^")
  end

  def move_back(line, guard_index, wall_index) do
    line = List.replace_at(line, guard_index, "X")
    move_back(line, guard_index - 1, wall_index)
  end

  # Stop if index is out of bounds
  defp find_backward_wall(_line, -1), do: nil

  defp find_backward_wall(line, index) do
    if Enum.at(line, index) == "#" do
      # Return immediately when the condition is met
      index
    else
      # Recur with the previous index
      find_backward_wall(line, index - 1)
    end
  end
end
