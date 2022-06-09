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

  def init(stack_name) do
    data =
      case :ets.lookup(:stacks_table, stack_name) do
        [] -> :ets.insert(:stacks_table, {stack_name, []})
        [{^stack_name, state_list}] -> state_list
      end
      {:ok, data}
  end

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

  def showtable(stack_name) do
    GenServer.call(via_tuple(stack_name), :showtable)
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
    new_state = tl(state)
    :ets.insert(:stacks_table, {this_stack_name(), new_state})
    {:reply, hd(state), new_state}
  end

  def handle_cast({:push,item}, state) do
    new_state = [item | state]
    # IO.puts this_stack_name()
    :ets.insert(:stacks_table, {this_stack_name(), new_state})
    {:noreply, new_state}
  end

  def handle_call(:show, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_call(:showtable, _from, state) do
    res = :ets.lookup(:de, 1980)
    {:reply, res, state}
  end

  def handle_info(message, state) do
    IO.puts "received your msg: #{inspect(message)}"
    {:noreply, state}
  end

  defp this_stack_name() do
    Registry.keys(StackRegistry, self()) |> List.first()
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
    :ets.delete(:stacks_table, stack_name)
    DynamicSupervisor.terminate_child(__MODULE__, stack_pid)
  end
end

#top level supervisor
defmodule DynamicDemo do
  use Application

  def start(_type, _args) do
    children = [{Registry, keys: :unique, name: StackRegistry}, StackSup]
    options = [strategy: :one_for_one, name: TopSupervisor]

    :ets.new(:stacks_table, [:set, :public, :named_table])

    Supervisor.start_link(children, options)

  end
  def sam() do
    table = :ets.new(:de, [:set, :protected, :named_table])
    :ets.insert(table, {1980, "hi", 100})
    :ets.insert(table, {1982, "buy", 200})
  end
end

# StackSup.start_stack("Fruits")
# StackServer.push "Fruits", 5
# StackServer.show "Fruits"
# StackServer.showtable "Fruits"

# pid = StackServer.stack_pid "Fruits"
# Process.exit(pid, :kill)
# StackServer.show "Fruits"

# now value stored will be retrieved
