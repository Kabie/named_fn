defmodule NamedFn do
  @moduledoc """
  Documentation for `NamedFn`.
  """

  @doc """
  Define a named function.

  iex> import NamedFn
  iex> fac = named_fn :fac do
  ...>  0 -> 1
  ...>  x when x > 0 -> x * fac(x - 1)
  ...> end
  iex> fac.(5)
  120
  """
  defmacro named_fn(name, do: clauses) do
    clauses = Macro.escape(clauses)

    quote do
      NamedFn.define_named_fn(__ENV__, unquote(name), unquote(clauses), binding())
    end
  end

  @doc false
  def define_named_fn(env, name, clauses, bindings) do
    quoted = {:fn, [], clauses}

    {_, scope} = :elixir_env.env_to_scope(env)
    # scope is record `elixir_erl` in "elixir.hrl"
    var_names = elem(scope, 4)
    {read, _} = env.current_vars

    erl_bindings =
      bindings
      |> Enum.map(fn {var, value} ->
        erl_var = var_names[read[{var, nil}]]
        {erl_var, value}
      end)

    # {erl_ast, _, _} = :elixir.quoted_to_erl(quoted, env)
    {expanded, _} = :elixir_expand.expand(quoted, env)
    {erl_ast, _} = :elixir_erl_pass.translate(expanded, scope)

    {{:fun, _, {:clauses, ex_clauses}}, _} = :ast_walk.expr(erl_ast, replace_fn_name(name), [])
    {:value, result, _} = :erl_eval.expr({:named_fun, env.line, name, ex_clauses}, erl_bindings)
    result
  end

  defp replace_fn_name(name) do
    fn
      state, {:call, line1, {:atom, line2, ^name}, args} ->
        {{:call, line1, {:var, line2, name}, args}, state}

      state, others ->
        {others, state}
    end
  end
end
