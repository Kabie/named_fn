defmodule NamedFnTest do
  use ExUnit.Case
  doctest NamedFn

  import NamedFn

  test "define a normal function" do
    f =
      named_fn :func_name do
        any -> any
      end

    assert f.(42) == 42
    assert f.(:foo) == :foo
  end

  test "define a recursive function" do
    func =
      named_fn :fac do
        0 -> 1
        x when x > 0 -> x * fac(x - 1)
      end

    assert func.(0) == 1
    assert func.(5) == 120
  end

  test "with bindings" do
    fib0 = 0
    fib1 = 1

    fib =
      named_fn :fib do
        ^fib0 -> fib0
        ^fib1 -> fib1
        n -> fib(n - 1) + fib(n - 2)
      end

    assert fib.(0) == 0
    assert fib.(1) == 1
    assert fib.(13) == 233
  end

  test "return self" do
    func = named_fn :this do
      -> this
    end

    f = func.()
    assert Function.info(f, :uniq) == Function.info(func, :uniq)

    func = named_fn :this do
      f -> f.(this)
    end

    f = func.(&Function.identity/1)
    assert Function.info(f, :uniq) == Function.info(func, :uniq)
  end
end
