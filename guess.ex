defmodule Guess do
  @doc """
  Function to play a guess game
  First, generate a random num
  get a number from user
  specify a no of rounds in attributes

  """

  def main(_args) do
    play_game()
  end

  @max_rounds 5

  def play_game() do
    chosen_num = :rand.uniform(100)
    IO.puts "I ahve chosen a number from 0 to 100"
    IO.puts "Try to guess it correctly"
    play_round(chosen_num, 1)
  end

  def play_round(chosen_number, round) do
    player_input = IO.gets("please enter your guess for round #{round}: ") |> String.trim() |> String.to_integer()

    case give_clue(chosen_number, player_input) do
      {:continue, message} ->
        IO.puts message
        process_next_round(chosen_number, round + 1)
      win ->
        IO.puts "you guess correct"
      _ ->
        :error
    end
  end

  defp give_clue(chosen_number, player_input) when chosen_number > player_input do
    {:continue, "you have guess low"}
  end
  defp give_clue(chosen_number, player_input) when chosen_number < player_input do
    {:continue, "you have guessed high"}
  end
  defp give_clue(_, _) do
    :win
  end

  defp process_next_round(chosen_number, round) when round <= @max_rounds do
      play_round(chosen_number, round)
  end
  defp process_next_round(chosen_number, _round) do
    IO.puts "you have reached max limits of rounds"
    IO.puts "My chosen number is #{chosen_number}"

  end
end

Guess.play_game()
