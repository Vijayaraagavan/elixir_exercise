defmodule Gcd do
  @moduledoc """
  Function to calculate gcd using Euclidean algorithm
  
  gcd(A, B) = B When A = 0
  gcd(A, B) = A when B = 0
  write A in quotient remainder form => A = B.Q + R
            gcd(A, B) == gcd(B, R)
  ex: GCD of 270 and 192
    270/192 = 1 with R = 78 => 270 = 192 * 1 + 78
    Find gcd(192, 78) and so on
    GCD(270,192) = GCD(192,78) = GCD(78,36) = GCD(36,6) = GCD(6,0) = 6
  """
  def gcd(a, 0), do: a
  def gcd(a, b), do: gcd(b, rem(a, b))
end

IO.puts(Gcd.gcd(5, 10))
