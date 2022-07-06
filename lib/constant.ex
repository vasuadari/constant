defmodule Constant do
  import String, only: [to_atom: 1]

  defmacro defconst(list, opts \\ []) do
    values = Keyword.values(list)
      atom_values =
        if opts[:atomize] do
          values
           |> Enum.filter(&is_binary(&1))
           |> Enum.map(&to_atom(&1))
        else
          []
        end
      values = values ++ atom_values

    quote bind_quoted: [list: list, opts: opts, values: values], location: :keep do
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

      escaped_values = Macro.escape(values)
      def values do
        unquote(escaped_values)
      end

      def valid?(value) do
        value in unquote(escaped_values)
      end

      escaped_list = Macro.escape(list)
      def dump do
        unquote(escaped_list)
      end
    end
  end
end
