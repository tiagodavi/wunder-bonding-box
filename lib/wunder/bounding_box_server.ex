defmodule Wunder.BoundingBoxServer do

  use GenServer

  alias Wunder.{BoundingBox, BoundingBoxSupervisor}

  def start_link({process_name, path}) do
    GenServer.start_link(__MODULE__, path, name: process_name)
  end

  def init(path) do
    {:ok, BoundingBox.load_boxes(path)}
  end

  def handle_call(:bounding_boxes, _from, state) do
    {:reply, state, state}
  end

  def new(path) do
    child_spec = {__MODULE__, {String.to_atom(path), path}}
    DynamicSupervisor.start_child(BoundingBoxSupervisor, child_spec)
  end

  def count_children() do
    DynamicSupervisor.count_children(BoundingBoxSupervisor)
  end

  def children() do
    DynamicSupervisor.which_children(BoundingBoxSupervisor)
  end

  def bounding_boxes() do
    children()
    |> Enum.reduce([], fn ({_, pid, :worker, _}, acc) ->
       Enum.concat(acc, GenServer.call(pid, :bounding_boxes))
    end)
  end

  def clean() do
    children()
    |> Enum.map(fn({_, pid, :worker, _}) ->
       DynamicSupervisor.terminate_child(BoundingBoxSupervisor, pid)
    end)
  end

end
