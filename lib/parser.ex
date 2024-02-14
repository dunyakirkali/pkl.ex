defmodule Parser do
  @moduledoc false

  import NimbleParsec

  any_unicode = utf8_char([])

  # A code comment that starts with a double-slash (`//`) and runs until the end of the line.
  line_comment =
    string("//")
    |> ignore()
    |> repeat_while(any_unicode, {:not_line_terminator, []})
    |> tag(:line_comment)

  # A nestable multiline comment which is typically used to comment out code. Starts with `/*` and ends with `*/`.
  block_comment =
    string("/*")
    |> ignore()
    |> repeat_while(any_unicode, {:not_end_of_comment, []})
    |> tag(:block_comment)

  identifier = ascii_string([?a..?z, ?A..?Z, ?0..?9, ?_, ?-, ??], min: 1)

  # field =
  #   identifier
  #   |> repeat(any_unicode)
  #   |> tag(:field)

  whitespace = utf8_string([?\s, ?\n, ?\r, ?\t], min: 0)

  assignment =
    identifier
    |> ignore(whitespace)
    |> ignore(string("="))
    |> ignore(whitespace)

  defp not_end_of_comment(<<"*/", _::binary>>, context, _, _), do: {:halt, context}
  defp not_end_of_comment(_, context, _, _), do: {:cont, context}

  defp not_line_terminator(<<?\n, _::binary>>, context, _, _), do: {:halt, context}
  defp not_line_terminator(<<?\r, _::binary>>, context, _, _), do: {:halt, context}
  defp not_line_terminator(_, context, _, _), do: {:cont, context}

  defparsec(:parse, choice([line_comment, block_comment, assignment]))
end
