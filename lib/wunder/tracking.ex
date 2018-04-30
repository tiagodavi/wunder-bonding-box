defmodule Wunder.Tracking do

  alias Wunder.BoundingBox

  @output %{origin_boxes: [], destination_boxes: [], both_boxes: [], pair_box: %Envelope{}}

  def execute(%{origin: {x1, y1}, destination: {x2, y2}}, boxes_path)
  when is_float(x1) and is_float(y1) and is_float(x2) and is_float(y2) do

    with boxes = [_|_] <- BoundingBox.load_boxes(boxes_path)
      do

        x1 = Float.to_string(x1)
        y1 = Float.to_string(y1)
        x2 = Float.to_string(x2)
        y2 = Float.to_string(y2)

        origin = %{type: "Point", coordinates: {x1, y1}}
        destination = %{type: "Point", coordinates: {x2, y2}}
        output = %{@output | pair_box: Envelope.from_geo(%Geo.Polygon{coordinates: [[{x1, y1}, {x2, y2}]]})}

        Enum.reduce(boxes, output, fn(box, acc) ->

          cond do
            Envelope.contains?(box, origin) &&
            Envelope.contains?(box, destination) ->
              %{ acc | both_boxes: Enum.concat(acc.both_boxes, [box])}
            Envelope.contains?(box, origin) ->
              %{ acc | origin_boxes: Enum.concat(acc.origin_boxes, [box])}
            Envelope.contains?(box, destination) ->
              %{ acc | destination_boxes: Enum.concat(acc.destination_boxes, [box])}
            true ->
              acc
          end

        end)


      else _ -> @output
    end

  end
  def execute(_,_), do: @output

end
