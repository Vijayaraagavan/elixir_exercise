{:ok, pid} = TaskStack.start()
send(pid, {:push, 5})
send(pid, {:push, 6})
send(pid, {:show, self()})
receive do
  data -> IO.inspect data
end

send(pid, {:pop, self()})
receive do
data -> IO.puts("I got #{data}")
end
send(pid, {:pop, self()})
receive do
data -> IO.puts("I got #{data}")
end
send(pid, {:pop, self()})
receive do
data -> IO.puts("I got #{data}")
end
