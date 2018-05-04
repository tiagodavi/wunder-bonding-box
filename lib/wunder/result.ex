defmodule Wunder.Result do

  defstruct [
    pair: %{origin: {0,0}, destination: {0,0}},
    matching_origin: [],
    matching_destination: [],
    matching_both: [],
    pair_bounding_box: %Envelope{}]

  def new(pair) do
    %Wunder.Result{pair: pair}
  end

end
