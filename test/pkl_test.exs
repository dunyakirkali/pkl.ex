defmodule PklTest do
  use ExUnit.Case
  doctest Pkl

  test "line_comment" do
    # GIVEN
    line_comment = "// This is a comment\n"

    # WHEN
    result = Parser.parse(line_comment)

    # THEN
    assert result == {:ok, [line_comment: ~c" This is a comment"], "\n", %{}, {1, 0}, 20}
  end

  test "block_comment" do
    # GIVEN
    block_comment = """
    /*
      Multiline
      comment
    */
    """

    # WHEN
    result = Parser.parse(block_comment)

    # THEN
    assert result ==
             {:ok, [block_comment: ~c"\n  Multiline\n  comment\n"], "*/\n", %{}, {4, 25}, 25}
  end

  test "decimal integer" do
    # GIVEN
    decimal_integer = "num1 = 123"

    # WHEN
    result = Parser.parse(decimal_integer)

    # THEN
    assert result ==
             {:ok, [integer: {:decimal, 123}], "", %{}, {4, 25}, 25}
  end
end
