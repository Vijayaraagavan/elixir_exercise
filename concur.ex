defmodule TaskNumbers do
  @server_url "http://numbersapi.com/"
  def fetch_fact(number) do
    url = @server_url <> to_string(number)
    response = url |> HTTPoison.get() |> parse_response

    case response do
      {:ok, body} -> body
      _ -> "#{number} - some error caused"
    end
  end

  def parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    {:ok, body}
  end
  def parse_response(_response) do
    :error
  end

  def tot() do    //sequential call takes 5 seconds
    IO.puts fetch_fact(11)
    a = :erlang.timestamp()
    1..25 |> Enum.map(&fetch_fact/1)
    b = :erlang.timestamp()
    IO.puts :timer.now_diff(b, a)/1000000
  end

  def find_facts_tasks(numbers) do    //concurrent call takes 0.5 seconds
    a = :erlang.timestamp()
    results = numbers |> Enum.map(&Task.async(fn ->
      TaskNumbers.fetch_fact(&1) end)) |>
      Enum.map(&Task.await/1)
      IO.puts("#{inspect(results)}")
      b = :erlang.timestamp()
      IO.puts :timer.now_diff(b, a)/1000000

  end
end
