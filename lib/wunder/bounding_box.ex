defmodule Wunder.BoundingBox do

  @header 1

  def load_boxes(path) do

    pairs = File.stream!(path)
     |> CSV.decode
     |> Stream.drop(@header)
     |> Enum.map(fn {:ok, [lon, lat]} -> {lat, lon} end)

    pairs
    |> Enum.with_index
    |> Enum.map(fn {{x1, y1}, index} ->
       case Enum.at(pairs, index + 1) do
          {x2, y2} -> Envelope.from_geo(%Geo.Polygon{coordinates: [[{x1, y1}, {x2, y2}]]})
          _ -> []
        end
     end)

  end

  def load_coordinates(path) do

    File.stream!(path)
     |> CSV.decode
     |> Stream.drop(@header)
     |> Stream.map(fn {:ok, [lon, lat]} ->
       %{type: "Point", coordinates: {lat, lon}}
      end)

  end

  def execute() do

     boxes = load_boxes("./source/pairs.csv")
     coordinates = load_coordinates("./source/coordinates.csv")

     for %{coordinates: {lat, long}, type: "Point"} = coord <- coordinates,
         box <- boxes, is_map(box), Envelope.contains?(box, coord) do
           %{box: box, coord: %{x: lat, y: long}}
     end

  end

end
