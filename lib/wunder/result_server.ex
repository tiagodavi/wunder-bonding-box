defmodule Wunder.ResultServer do
  use Agent

  alias Wunder.{BoundingBoxServer, Result}

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def execute(%{origin: {x1, y1}, destination: {x2, y2}} = pair) do

    bounding_boxes = BoundingBoxServer.bounding_boxes()

    x1 = Float.to_string(x1)
    y1 = Float.to_string(y1)
    x2 = Float.to_string(x2)
    y2 = Float.to_string(y2)

    key = "#{x1}-#{y1}-#{x2}-#{y2}"

    state = Agent.get(__MODULE__, fn state -> state end)
    pair_value = Map.get(state, key, Result.new(pair))
    
    origin = %{type: "Point", coordinates: {x1, y1}}
    destination = %{type: "Point", coordinates: {x2, y2}}
    pair_value = %{ pair_value |
    pair_bounding_box: Envelope.from_geo(%Geo.Polygon{coordinates: [[{x1, y1}, {x2, y2}]]})}

    result = Enum.reduce(bounding_boxes, pair_value, fn(box, acc) ->
      cond do
        Envelope.contains?(box, origin) &&
        Envelope.contains?(box, destination) ->
          %{ acc | matching_both: Enum.concat(acc.matching_both, [box])}
        Envelope.contains?(box, origin) ->
          %{ acc | matching_origin: Enum.concat(acc.matching_origin, [box])}
        Envelope.contains?(box, destination) ->
          %{ acc | matching_destination: Enum.concat(acc.matching_destination, [box])}
        true ->
          acc
      end
    end)

    Agent.update(__MODULE__, &Map.put(&1, key, result))
    result
  end

  def all() do
    Agent.get(__MODULE__, fn state -> state end)
  end

  def clean() do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

end
