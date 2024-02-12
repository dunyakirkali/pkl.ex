defmodule PklTest do
  use ExUnit.Case
  doctest Pkl

  test "greets the world" do
    assert Pkl.hello() == :world
  end
end
