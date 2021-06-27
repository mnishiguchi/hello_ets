defmodule HelloEtsTest do
  use ExUnit.Case
  doctest HelloEts

  test "greets the world" do
    assert HelloEts.hello() == :world
  end
end
