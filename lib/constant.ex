defmodule Constant do
  defmacro defconst(list, opts \\ []) do
    quote bind_quoted: [list: list, opts: opts], location: :keep do
      import String, only: [to_atom: 1]

      Enum.each(list, fn
        {key, value} when is_nil(value) ->
          raise "Value cannot be nil"

        {key, value} when is_atom(key) ->
          escaped_value = Macro.escape(value)

          def unquote(key)(), do: unquote(escaped_value)

          if opts[:atomize] && is_binary(value) do
            escaped_atom_value = Macro.escape(to_atom(value))

            def unquote(:"#{key}_atom")(), do: unquote(escaped_atom_value)

            def unquote(:"#{key}?")(value) do
              value in [unquote(escaped_value), unquote(escaped_atom_value)]
            end
          else
            def unquote(:"#{key}?")(value) do
              value == unquote(escaped_value)
            end
          end

        _ ->
          raise "Key has to be an atom"
      end)
    end
  end
end
