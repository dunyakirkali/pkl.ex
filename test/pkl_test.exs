defmodule PklTest do
  use ExUnit.Case
  doctest Pkl

  test "line_comment" do
    # GIVEN
    comment_text = "// This is a comment\n"

    # WHEN
    result = Parser.parse(comment_text)

    # THEN
    assert result == {:ok, [comment: ~c" This is a comment"], "\n", %{}, {1, 0}, 20}
  end
end
