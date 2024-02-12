defmodule Parser do
  @moduledoc false

  import NimbleParsec

  @doc """
  Defines a comment parser that matches comments starting with `//`.
  """
  line_comment =
    string("//")
    |> ignore()
    |> repeat(utf8_char(not: ?\n))
    |> tag(:comment)

  defparsec(:parse, line_comment)
end
