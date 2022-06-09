defmodule StackServer do
  use GenServer

  def via_tuple(stack_name) do
    {:via, Registry, {StackRegistry, stack_name}}
  end

  def stack_pid(stack_name) do
    stack_name |> via_tuple() |> GenServer.whereis()
  end

  def start_link(stack_name) do
    IO.puts "starting the stack server... #{stack_name}..."
    GenServer.start_link(__MODULE__, stack_name, name: via_tuple(stack_name))
  end

  def init(_stack_name), do: {:ok, []}

  def pop(stack_name) do
    GenServer.call(via_tuple(stack_name), :pop)
  end

  def push(stack_name, item) do
    GenServer.cast(via_tuple(stack_name), {:push, item})
  end

  def show(stack_name) do
    GenServer.call(via_tuple(stack_name), :show)
  end

  def stop(stack_name) do
    GenServer.cast(via_tuple(stack_name), :stop)
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

  def handle_info(message, state) do
    IO.puts "received your msg: #{inspect(message)}"
    {:noreply, state}
  end
end

#dynamic supervisor
defmodule StackSup do
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end
  def init(:ok) do
    IO.puts "stack supervisor is started..."
    DynamicSupervisor.init(strategy: :one_for_one)
  end
  def start_stack(stack_name) do
    child_spec = %{
      id: StackServer,
      start: {StackServer, :start_link, [stack_name]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)

  end

  def stop_stack(stack_name) do
    stack_pid = StackServer.stack_pid(stack_name)
    DynamicSupervisor.terminate_child(__MODULE__, stack_pid)
  end
end

#top level supervisor
defmodule DynamicDemo do
  use Application

  def start(_type, _args) do
    children = [{Registry, keys: :unique, name: StackRegistry}, StackSup]
    options = [strategy: :one_for_one, name: TopSupervisor]

    Supervisor.start_link(children, options)
  end
end

"""
vijay@vijay:~/Documents/ex/genserv$ iex -S mix
Erlang/OTP 24 [erts-12.2.1] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [jit]

Compiling 1 file (.ex)

stack supervisor is started...
Interactive Elixir (1.13.0) - press Ctrl+C to exit (type h() ENTER for help

iex(1)> alias StackSup, as: Dss
StackSup
iex(2)> alias StackServer, as: Ss  
StackServer
iex(3)> Dss.start_stack "Fruits"
starting the stack server... Fruits...
{:ok, #PID<0.178.0>}
iex(4)> Ss.push "Fruits", "apple"
:ok
iex(5)> Ss.show "Fruits"
["apple"]
iex(6)> Dss.start_stack "one"
starting the stack server... one...
{:ok, #PID<0.182.0>}
iex(7)> Dss.stop_stack "one"
:ok
"""
