defmodule Pro do
  @moduledoc """
  Function to traverse list and modify it
  returns a new list
  """
  def double_each([head | tail], sum, fun) do
    sum = fun.(head)
    [sum | double_each(tail, sum, fun)]
  end

  def double_each([], _sum, _fun), do: []
end

a = [1, 2, 3, 4]

fun = fn a ->
  a * 2
end

IO.inspect(Pro.double_each(a, 0, fun))
