defmodule TaskStack do
  def start do
    Task.start_link(fn -> stack_process([]) end)
  end

  def stack_process(list) do
    receive do
      {:push, item} ->
          stack_process([item|list])
      {:pop, caller} ->
          {head, tail} = get_head_tail(list)
          send(caller, head)
          stack_process(tail)
      {:show,caller} ->
          send(caller, list)
          stack_process(list)
      after
        200_000 -> exit(:no_operation)
    end
  end

  defp get_head_tail([]), do: {:nothing, []}
  defp get_head_tail(list), do: {hd(list), tl(list)}
end

#look into run_stack.ex file for testing this func
