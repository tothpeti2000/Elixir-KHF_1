defmodule Khf1 do
  @moduledoc """
  Camping
  
  @author "Egyetemi Hallgató <egy.hallg@dp.vik.bme.hu>"
  @date   "2022-09-25"
  ...
  """

  @doc """
  ...
  """

  # Number of rows (1 - n)
  @type row :: integer
  # Number of columns (1 - m)
  @type col :: integer
  # Coordinates of a field
  @type field :: {row, col}

  # Number of tents per row
  @type tentsCountRows :: [integer]
  # Number of tents per column
  @type tentsCountCols :: [integer]

  # Coordinates of the fields which have a tree on them
  @type trees :: [field]
  # Tuple describing the puzzle
  @type puzzle_desc :: {tentsCountRows, tentsCountCols, trees}

  @doc """
  ...
  """
  @spec to_internal(file :: String.t()) :: pd :: puzzle_desc
  # pd is the description of the puzzle stored in the file
  def to_internal(file) do
    lines = File.read!(file) |> String.split(~r/\R/)

    rows =
      lines
      |> Enum.map(fn text -> Enum.join(String.split(text), " ") end)
      |> Enum.filter(fn text -> text != "" end)

    arrayContent = rows |> Enum.map(&String.split/1)

    n = length(arrayContent) - 1
    m = length(hd(arrayContent))

    rowTentCounts = for i <- 1..n, do: Enum.at(Enum.at(arrayContent, i), 0) |> String.to_integer()

    colTentCounts = hd(arrayContent) |> Enum.map(&String.to_integer/1)

    tentCoordinates =
      for i <- 1..n, j <- 1..m do
        if Enum.at(Enum.at(arrayContent, i), j) == "*", do: {i, j}
      end
      |> Enum.filter(&(!is_nil(&1)))

    {rowTentCounts, colTentCounts, tentCoordinates}
  end
end
