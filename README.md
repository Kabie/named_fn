# NamedFn

Named function for Elixir.

Erlang added named fun for some time. While Elixir havn't adopt it yet. This package is a workaround.

## Usage

Equivalent to:

```erlang
Factorial = fun
  F(0) -> 1;
  F(X) when X > 0 -> X * F(X - 1)
end.
```

We have:

```elixir
factorial = named_fn :f do
  0 -> 1
  x when x > 0 -> x * f(x - 1)
end
```

## Limitations

Currently this heavily depend on Elixir and Erlang compiler. So it may break if underlaying APIs changed.

If you define a named function with 0 arity, you can't call it inside body. Since it's hard to distinguish a call and a var, and we want to support using the function as a var.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `named_fn` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:named_fn, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/named_fn](https://hexdocs.pm/named_fn).
