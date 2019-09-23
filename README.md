# Constant

A package to define constants in your module.

## Installation

The package can be installed by adding `constant` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:constant, git: "vasuadari/constant"}
  ]
end
```

## Usage

```
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
