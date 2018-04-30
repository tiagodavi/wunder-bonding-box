defmodule Wunder.TrackingTest do
  use ExUnit.Case

  @moduletag :tracking
  @boxes_path "./source/pairs.csv"

  test ".execute returns an empty output when takes invalid arguments" do
    response =
    %{both_boxes: [],
      destination_boxes: [],
      origin_boxes: [],
      pair_box: %Envelope{max_x: 0, max_y: 0, min_x: 0, min_y: 0}
    }
    assert Wunder.Tracking.execute("sth", 0) == response
  end

  test ".execute returns one box matching both (origin and destination)" do

    response = Wunder.Tracking.execute(
    %{origin: {14.6346, 120.9899}, destination: {14.6364, 120.9917}},
    @boxes_path)

    both_total = response.both_boxes
    |> Enum.count

    origin_total = response.origin_boxes
    |> Enum.count

    destination_total = response.destination_boxes
    |> Enum.count

    assert both_total == 1
    assert origin_total == 0
    assert destination_total == 0
    assert is_map(response.pair_box) == true
  end

  test ".execute returns one box matching (origin)" do

    response = Wunder.Tracking.execute(
    %{origin: {14.4704, 120.9971}, destination: {1.5789, 25.879}},
    @boxes_path)

    both_total = response.both_boxes
    |> Enum.count

    origin_total = response.origin_boxes
    |> Enum.count

    destination_total = response.destination_boxes
    |> Enum.count

    assert both_total == 0
    assert origin_total == 1
    assert destination_total == 0
    assert is_map(response.pair_box) == true
  end

  test ".execute returns one box matching (destination)" do

    response = Wunder.Tracking.execute(
    %{origin: {18.4704, 170.9971}, destination: {14.5126, 120.9956}},
    @boxes_path)

    both_total = response.both_boxes
    |> Enum.count

    origin_total = response.origin_boxes
    |> Enum.count

    destination_total = response.destination_boxes
    |> Enum.count

    assert both_total == 0
    assert origin_total == 0
    assert destination_total == 1
    assert is_map(response.pair_box) == true
  end

end
