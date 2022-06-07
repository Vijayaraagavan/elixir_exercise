defmodule GenDemo.Stack do
  use GenServer

  def start() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args), do: {:ok, []}

  def pop() do
    GenServer.call(__MODULE__, :pop)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def show() do
    GenServer.call(__MODULE__, :show)
  end

  def stop() do
    GenServer.cast(__MODULE__, :stop)
  end

  def terminate(reason, state) do
    IO.puts "Server terminated because of #{inspect(reason)}"
    inspect(state)
  end

  #handlers (callbacks)
  def handle_call(:pop, _from, []) do
    {:reply, :nothing, []}
  end
  def handle_call(:pop, _from, state) do
    {:reply, hd(state), tl(state)}
  end

  def handle_cast({:push,item}, state) do
    {:noreply, [item|state]}
  end

  def handle_call(:show, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end
end

"""
iex(9)> {:ok, pid} = GenDemo.Stack.start
{:ok, #PID<0.304.0>}
iex(10)> pid
#PID<0.304.0>
iex(11)> Process.alive? pid
true
iex(12)> GenDemo.Stack.push(5)
:ok
iex(13)> GenDemo.Stack.push(8)
:ok
iex(14)> GenDemo.Stack.show
[8, 5]
iex(15)> Process.alive? pid
true
iex(16)> GenDemo.Stack.pop
8
iex(17)> GenDemo.Stack.show
[5]
iex(18)> GenDemo.Stack.stop
Server terminated because of :normal
:ok
iex(19)> Process.alive? pid
false
"""
