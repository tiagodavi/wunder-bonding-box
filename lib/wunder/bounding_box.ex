defmodule Wunder.BoundingBox do

  @header 1

  def load_boxes(path) do

    cond do
      File.exists?(path) ->

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

      true -> []
    end

  end

  def load_coordinates(path) do

    cond do
      File.exists?(path) ->

        File.stream!(path)
         |> CSV.decode
         |> Stream.drop(@header)
         |> Stream.map(fn {:ok, [lon, lat]} ->
           %{type: "Point", coordinates: {lat, lon}}
          end)

      true -> []
    end

  end

  def execute(boxes_path, coordinates_path) do

     boxes = load_boxes(boxes_path)
     coordinates = load_coordinates(coordinates_path)

     for %{type: "Point", coordinates: {lat, lon}} = coord <- coordinates,
         box <- boxes, is_map(box), Envelope.contains?(box, coord) do
           %{box: box, coord: %{x: lat, y: lon}}
     end

  end

end
