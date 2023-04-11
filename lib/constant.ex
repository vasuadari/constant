defmodule Constant do
  import String, only: [to_atom: 1]

  defmacro defconst(list, opts \\ []) do
    values = Keyword.values(list)

    quote bind_quoted: [list: list, opts: opts, values: values], location: :keep do
      Enum.each(list, fn
        {key, value} when is_nil(value) ->
          raise "Value cannot be nil"

        {key, value} when is_atom(key) ->
          escaped_value = Macro.escape(value)

          def unquote(key)(), do: unquote(escaped_value)

          defmacro unquote(:"const_#{key}")() do
            unquote(quote do: unquote(Macro.escape(escaped_value)))
          end

          if opts[:atomize] && is_binary(value) do
            escaped_atom_value = Macro.escape(to_atom(value))

            def unquote(:"#{key}_atom")(), do: unquote(escaped_atom_value)

            defmacro unquote(:"const_#{key}_atom")() do
              unquote(quote do: unquote(escaped_atom_value))
            end

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

      atom_values =
        if opts[:atomize] do
          values
          |> Enum.filter(&is_binary(&1))
          |> Enum.map(&to_atom(&1))
        else
          []
        end

      all_values = values ++ atom_values

      escaped_atom_values = Macro.escape(atom_values)
      def atom_values, do: unquote(escaped_atom_values)

      escaped_values = Macro.escape(values)
      def values, do: unquote(escaped_values)

      escaped_all_values = Macro.escape(all_values)
      def all_values, do: unquote(escaped_all_values)

      escaped_list = Macro.escape(list)
      def dump, do: unquote(escaped_list)

      def valid?(value) do
        value in unquote(escaped_all_values)
      end
    end
  end
end
