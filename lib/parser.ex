defmodule Parser do
  @moduledoc false

  import NimbleParsec

  any_unicode = utf8_char([])

  @doc """
  A code comment that starts with a double-slash (`//`) and runs until the end of the line.
  """
  line_comment =
    string("//")
    |> ignore()
    |> repeat_while(any_unicode, {:not_line_terminator, []})
    |> tag(:line_comment)

  @doc """
  A nestable multiline comment which is typically used to comment out code. Starts with `/*` and ends with `*/`.
  """
  block_comment =
    string("/*")
    |> ignore()
    |> repeat_while(any_unicode, {:not_end_of_comment, []})
    |> tag(:block_comment)

  defparsec(:parse, choice([line_comment, block_comment]))

  defp not_end_of_comment(<<"*/", _::binary>>, context, _, _), do: {:halt, context}
  defp not_end_of_comment(_, context, _, _), do: {:cont, context}

  defp not_line_terminator(<<?\n, _::binary>>, context, _, _), do: {:halt, context}
  defp not_line_terminator(<<?\r, _::binary>>, context, _, _), do: {:halt, context}
  defp not_line_terminator(_, context, _, _), do: {:cont, context}
end
