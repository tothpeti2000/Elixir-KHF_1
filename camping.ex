defmodule Khf1 do
  @moduledoc """
  Camping
  
  @author "Tóth Péter tothpeti2000@edu.bme.hu"
  @date   "2022-09-19"
  ...
  """

  # Number of rows (1 - n)
  @type row :: integer
  # Number of columns (1 - m)
  @type col :: integer
  # Coordinates of a field
  @type field :: {row, col}

  # Number of tents per row
  @type tents_count_rows :: [integer]
  # Number of tents per column
  @type tents_count_cols :: [integer]

  # Coordinates of the fields which have a tree on them
  @type trees :: [field]
  # Tuple describing the puzzle
  @type puzzle_desc :: {tents_count_rows, tents_count_cols, trees}

  @spec to_internal(file :: String.t()) :: pd :: puzzle_desc
  # pd is the description of the puzzle stored in the file
  def to_internal(file) do
    rows = parse_file(file)

    row_tent_counts = first_items_of_arrays(tl(rows))
    col_tent_counts = hd(rows)
    tent_coordinates = get_tent_coordinates(rows)

    {row_tent_counts, col_tent_counts, tent_coordinates}
  end

  @spec parse_file(file :: String.t()) :: [[any]]
  # Parse the file content to an array of rows
  defp parse_file(file) do
    lines = File.read!(file) |> String.split(~r/\R/, trim: true)
    # [" 0  1 2     ", "0  - *  - ", "-1 *    -  *"]

    rows =
      lines
      |> Enum.map(fn text -> String.split(text) |> Enum.join(" ") end)
      |> Enum.filter(fn text -> text != "" end)

    # ["0 1 2", "0 - * -", "-1 * - *"]

    [first_row | other_rows] = Enum.map(rows, &String.split/1)
    # [["0", "1", "2"], ["0", "-", "*", "-"], ["-1", "*", "-", "*"]]

    parsed_first_row = Enum.map(first_row, &String.to_integer/1)

    parsed_other_rows =
      Enum.map(other_rows, fn [row_tents_count | fields] ->
        [String.to_integer(row_tents_count) | fields]
      end)

    [parsed_first_row | parsed_other_rows]
  end

  @spec first_items_of_arrays(arrays :: [[any]]) :: [any]
  # Collect the first items of the arrays and put them into another array
  defp first_items_of_arrays(arrays) do
    for i <- 0..(length(arrays) - 1), do: Enum.at(Enum.at(arrays, i), 0)
  end

  @spec get_tent_coordinates(rows :: [[any]]) :: [field]
  # Get the coordinates of the tents from the rows
  defp get_tent_coordinates(rows) do
    n = length(rows) - 1
    m = length(hd(rows))

    for i <- 1..n, j <- 1..m do
      if Enum.at(Enum.at(rows, i), j) == "*", do: {i, j}
    end
    |> Enum.filter(&(!is_nil(&1)))
  end
end
