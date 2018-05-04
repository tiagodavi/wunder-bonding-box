defmodule Wunder.TrackingTest do
  use ExUnit.Case, async: true

  alias Wunder.Tracking

  @moduletag :tracking
  @boxes_path "./source/pairs.csv"

  setup do
    Tracking.clean()
    :ok
  end

  test ".load returns error when path is invalid" do
    error = {:error, "Path must be string"}

    response1 = Tracking.load 10
    response2 = Tracking.load nil
    response3 = Tracking.load :invalid
    response4 = Tracking.load ""

    assert response1 == error
    assert response2 == error
    assert response3 == error
    assert response4 == error
  end

  test ".execute returns error when there are no files in memory" do
    response = Tracking.execute(
      %{origin: {14.6346, 120.9899}, destination: {14.6364, 120.9917}}
    )
    assert response == {:error, "You need to load CSV files first"}
  end

  test ".result returns error when there are no files in memory" do
    response = Tracking.result()
    assert response == {:error, "You need to load CSV files first"}
  end

  test ".load returns error when path is loaded more than once" do
    Tracking.load @boxes_path
    {:error, {:already_started, pid}} = Wunder.Tracking.load @boxes_path
    assert is_pid(pid) == true
  end

  test ".load returns bounding boxes in memory" do
    Tracking.load @boxes_path
    bounding_boxes = Tracking.bounding_boxes()
    |> Enum.count
    assert bounding_boxes > 0
  end

  test ".execute returns one box matching both (origin and destination)" do

    Tracking.load @boxes_path

    response = Tracking.execute(
      %{origin: {14.6346, 120.9899}, destination: {14.6364, 120.9917}}
    )

    total = response.matching_both
    |> Enum.count

    assert total > 0
  end

  test ".execute returns one box matching origin" do

    Tracking.load @boxes_path

    response = Tracking.execute(
      %{origin: {14.4704, 120.9971}, destination: {1.5789, 25.879}}
    )

    total = response.matching_origin
    |> Enum.count

    assert total > 0
  end

  test ".execute returns one box matching destination" do

    Tracking.load @boxes_path

    response = Tracking.execute(
      %{origin: {18.4704, 170.9971}, destination: {14.5126, 120.9956}}
    )

    total = response.matching_destination
    |> Enum.count

    assert total > 0
  end

  test ".result returns all previous matchings" do

    Tracking.load @boxes_path

    Tracking.execute(
      %{origin: {14.6346, 120.9899}, destination: {14.6364, 120.9917}}
    )

    Tracking.execute(
      %{origin: {14.4704, 120.9971}, destination: {1.5789, 25.879}}
    )

    Tracking.execute(
      %{origin: {18.4704, 170.9971}, destination: {14.5126, 120.9956}}
    )

    response = Tracking.result()

    assert is_map(response["14.4704-120.9971-1.5789-25.879"]) == true
    assert is_map(response["14.6346-120.9899-14.6364-120.9917"]) == true
    assert is_map(response["18.4704-170.9971-14.5126-120.9956"]) == true
  end


end
