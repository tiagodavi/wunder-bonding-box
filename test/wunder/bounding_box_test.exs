defmodule Wunder.BoundingBoxTest do
  use ExUnit.Case

  def envelope?(_ = %Envelope{}), do: true
  def envelope?(_), do: false

  def point?(%{type: "Point", coordinates: _ }), do: true
  def point?(_), do: false

  def coord?(%{x: _, y: _}), do: true
  def coord?(_), do: false

  def box?(%{box: box, coord: coord}), do: envelope?(box) && coord?(coord)
  def box?(_), do: false

  test ".load_boxes returns an empty list when path is invalid" do
    assert Wunder.BoundingBox.load_boxes("/abc.txt") == []
  end

  test ".load_boxes returns a list of %Envelope{} when path is valid" do
    total = Wunder.BoundingBox.load_boxes("./source/pairs.csv")
    |> Enum.count(&envelope?/1)
    assert total > 0
  end

  test ".load_coordinates returns an empty list when path is invalid" do
    assert Wunder.BoundingBox.load_coordinates("./source/invalid.csv") == []
  end

  test ".load_coordinates returns a list of Point when path is valid" do
    total = Wunder.BoundingBox.load_coordinates("./source/coordinates.csv")
    |> Enum.count(&point?/1)
    assert total > 0
  end

  test ".execute returns a list of Maps with a box and its coordinates" do
    total = Wunder.BoundingBox.execute
    |> Enum.count(&box?/1)
    assert total > 0
  end

end
