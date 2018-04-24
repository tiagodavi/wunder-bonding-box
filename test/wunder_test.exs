defmodule WunderTest do
  use ExUnit.Case
  doctest Wunder

  test "greets the world" do
    assert Wunder.hello() == :world
  end
end
