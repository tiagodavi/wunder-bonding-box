defmodule Wunder.Tracking do

  alias Wunder.{BoundingBoxServer, ResultServer}
  @csv_error {:error, "You need to load CSV files first"}

  def load(path)
  when byte_size(path) > 0 do
    case BoundingBoxServer.new(path) do
      {:ok, pid} -> GenServer.call(pid, :bounding_boxes)
      error -> error
    end
  end
  def load(_), do: {:error, "Path must be string"}

  def execute(%{origin: {x1, y1}, destination: {x2, y2}} = pair)
  when is_float(x1) and is_float(y1) and is_float(x2) and is_float(y2) do
    children = BoundingBoxServer.count_children()
    if children.active > 0 do
      ResultServer.execute(pair)
    else
      @csv_error
    end
  end
  def execute(_), do: {:error, "Wrong Pattern"}

  def bounding_boxes() do
    children = BoundingBoxServer.count_children()
    if children.active > 0 do
      BoundingBoxServer.bounding_boxes()
    else
      @csv_error
    end
  end

  def result() do
    children = BoundingBoxServer.count_children()
    if children.active > 0 do
      ResultServer.all()
    else
      @csv_error
    end
  end

  def clean() do
    BoundingBoxServer.clean()
    ResultServer.clean()
  end

end
