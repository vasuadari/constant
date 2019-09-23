defmodule Constant do
  defmacro defconst(list, opts \\ []) do
    quote bind_quoted: [list: list, opts: opts] do
      import String, only: [to_atom: 1]

      Enum.each(list, fn
        {key, value} when is_atom(key) and is_binary(value) ->
          value = if(opts[:atomize_values], do: to_atom(value), else: value)
          escaped_value = Macro.escape(value)

          def unquote(key)(), do: unquote(escaped_value)

        {key, value} when is_atom(key) ->
          escaped_value = Macro.escape(value)

          def unquote(key)(), do: unquote(escaped_value)

        _ ->
          raise "Key has to be an atom"
      end)
    end
  end
end

