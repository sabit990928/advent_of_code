defmodule Day8 do
  # 358 is too high
  def antennas do
    input =
      File.read!("input8.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes(&1))
      |> Enum.with_index()
      |> Enum.map(fn {line, index} -> {Enum.with_index(line), index} end)

    max_y = length(input)
    max_x = hd(input) |> elem(0) |> length()

    Enum.map(input, fn {line, l_i} ->
      Enum.map(line, fn {symbol, s_i} ->
        if symbol != "." do
          rest_lines =
            Enum.drop(input, l_i + 1)
            |> Enum.map(fn {n_line, n_l_i} ->
              Enum.map(n_line, fn {n_symbol, n_s_i} ->
                if symbol == n_symbol do
                  distance_x = s_i - n_s_i
                  # Then you'll add distance_x to s_i and minus distance_x from n_s_i
                  distance_y = abs(l_i - n_l_i)

                  y_step = l_i - distance_y
                  top = if y_step >= 0, do: y_step, else: false

                  x_step = s_i + distance_x
                  left_right = if x_step < 0 or x_step > max_x, do: false, else: x_step

                  shift = if top && left_right, do: {top, left_right}, else: {}

                  n_y_step = n_l_i + distance_y
                  n_top = if n_y_step > max_y, do: false, else: n_y_step

                  n_x_step = n_s_i - distance_x
                  n_left_right = if n_x_step < 0 or n_x_step > max_x, do: false, else: n_x_step

                  n_shift = if n_top && n_left_right, do: {n_top, n_left_right}, else: {}

                  [shift, n_shift]
                end
              end)
            end)
        end
      end)
    end)
    # |> Enum.map(fn line, index -> line end)
    |> List.flatten()
    |> Enum.reject(&(&1 == nil or &1 == {}))
    |> Enum.uniq()
    |> IO.inspect()
    |> length()
  end

  # def save_indexes(line_index, x, y, input, acc) do
  # end

  # Distance between two a is as a chess horse step. Г
  # So antinodes makes the same distance depend on every instance.
  # But it kinda goes left or right depend on diagonal type direction.

  # ..........
  # ...#......
  # ..........
  # ....a.....
  # ..........
  # .....a....
  # ..........
  # ......#...
  # ..........
  # ..........
end
