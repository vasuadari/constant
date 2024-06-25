defmodule Constant do
  defmacro defconst(list) do
    define_const(list, [])
  end

  defmacro defconst(list, opts) do
    define_const(list, opts)
  end

  def define_const(list, opts) do
    quote bind_quoted: [list: list, opts: opts] do
      values = Keyword.values(list)

      Enum.each(list, fn
        {key, value} when is_nil(value) ->
          raise "Value cannot be nil"

        {key, value} when is_atom(key) ->
          escaped_value = Macro.escape(value)
          escaped_key = Macro.escape(key)

          def unquote(key)(), do: unquote(escaped_value)

          defmacro unquote(:"const_#{key}")() do
            unquote(quote do: unquote(Macro.escape(escaped_value)))
          end

          if opts[:reverse_lookup] do
            def key_of(unquote(escaped_value)), do: unquote(escaped_key)
          end

          if opts[:atomize] && is_binary(value) do
            escaped_atom_value = Macro.escape(String.to_atom(value))

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

      if opts[:reverse_lookup] do
        def key_of(_), do: nil
      end

      atom_values =
        if opts[:atomize] do
          values
          |> Enum.filter(&is_binary(&1))
          |> Enum.map(&String.to_atom(&1))
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

      escaped_all_keys = Keyword.keys(Macro.escape(list))
      def keys, do: unquote(escaped_all_keys)

      def has_key?(key), do: key in unquote(escaped_all_keys)
    end
  end

  defmodule Error, do: defexception([:message])

  def key_of(_value, []), do: nil

  def key_of(value, [module | other_modules]) do
    module.key_of(value) || key_of(value, other_modules)
  rescue
    UndefinedFunctionError ->
      raise Error, "reverse_lookup option is not set"
  end

  def has_key?(_key, []), do: false

  def has_key?(key, [module | other_modules]) do
    module.has_key?(key) || has_key?(key, other_modules)
  end
end
