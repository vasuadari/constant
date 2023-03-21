# Constant
[![Build Status](https://travis-ci.org/vasuadari/constant.svg?branch=master)](https://travis-ci.org/vasuadari/constant)
[![Hex.pm version](https://img.shields.io/hexpm/v/constant.svg)](https://hex.pm/packages/constant)

A package to define constants in your module.

## Installation

The package can be installed by adding `constant` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:constant, "~> 0.0.1"}
  ]
end
```

## Usage

```elixir
defmodule HTTPStatusCode do
  import Constant

  defconst ok: 200, created: 201
end

iex> HTTPStatusCode.ok()
200
iex> HTTPStatusCode.created()
201

defmodule ColorCode do
  import Constant

  defconst [black: "FFFFFF", white: "000000"], atomize: true
end

iex> ColorCode.black()
"FFFFFF"
iex> ColorCode.black_atom()
:FFFFFF
```

The constant can be used in the format `const_<key>` after requiring the module, and which enables the constant to be directly used in argument pattern matches and guards.

```elixir
defmodule ColorCodeMatcher do
  require ColorCode

  def is_black(_color = ColorCode.const_black()), do: true
  def is_black(_), do: false
end
```

## License

Constant source code is licensed under the [MIT License](LICENSE).

