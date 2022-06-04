filter = fn inn ->
  # sep = String.split(inn, " ")
  # joined = Enum.join(sep,"")
  # joined = String.upcase(joined)
  # str1 = String.split(joined,"")
  # Enum.sort(str1)
  # inn |> String.split(" ") |> Enum.join("") |> String.upcase() |> String.split("") |> Enum.sort()
                # (or)
  inn |> String.replace(~r"[ ]", "") |> String.upcase() |> String.split("") |> Enum.sort()
end

anag = fn a, b ->
  a == b
end
# inn = "Partial Men"
str1 = filter.("Partial Men")
str2 = filter.("parliament")
IO.puts(anag.(str1, str2))
