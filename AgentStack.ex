defmodule AgentStack do
  use Agent

  def start() do
    Agent.start_link(fn -> [] end)
  end

  def push(agent, item) do
    Agent.update(agent, fn data -> [item | data] end)
  end

  def pop(agent) do
    head = Agent.get(agent, fn data -> hd(data) end)
    Agent.update(agent, fn data -> tl(data) end)
    head
  end

  def stop(agent), do: Agent.stop(agent)
end

"""
iex> {:ok, agent} = AgentStack.start
{:ok, #PID<0.6488.0>}
iex> AgentStack.push(agent, 5)
:ok
iex> AgentStack.push(agent, 6)
:ok
iex> AgentStack.pop(agent)
6
iex> AgentStack.pop(agent)
5
iex> AgentStack.stop agent
:ok
"""
