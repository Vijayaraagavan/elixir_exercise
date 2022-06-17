defmodule Secrets do
  def secret_add(secret) do
    # Please implement the secret_add/1 function
      fn x -> x + secret end
  end

  def secret_subtract(secret) do
    # Please implement the secret_subtract/1 function
fn x -> x - secret end
  end

  def secret_multiply(secret) do
    # Please implement the secret_multiply/1 function
fn x -> x * secret end
  end

  def secret_divide(secret) do
    # Please implement the secret_divide/1 function
fn x -> 
  a = div(x, secret )
end
  end

  def secret_and(secret) do
    # Please implement the secret_and/1 function
fn x -> Bitwise.band(x, secret) end
  end

  def secret_xor(secret) do
    # Please implement the secret_xor/1 function
fn x -> Bitwise.bxor(x, secret) end
  end

  def secret_combine(secret_function1, secret_function2) do
    # Please implement the secret_combine/2 function
fn x -> 
    x |> secret_function1.() |> secret_function2.() 
end

  end
end

# We might use anonymous functions to:

# Hide data using lexical scope (also known as a closure).
# Dynamically create functions at run-time.

# Elixir supports many functions for working with bits found in the Bitwise module.

# band/2: bitwise AND
# bsl/2: bitwise SHIFT LEFT
# bsr/2: bitwise SHIFT RIGHT
# bxor/2: bitwise XOR
# bor/2: bitwise OR
# bnot/1: bitwise NOT
