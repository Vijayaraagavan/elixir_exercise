defmodule LogLevel do
  def to_label(level, legacy?) do
    # Please implement the to_label/2 function
    cond do
      level == 0 and legacy? == false -> :trace
      level == 1 -> :debug
      level == 2 -> :info
      level == 3 -> :warning
      level == 4 -> :error
      level == 5 and legacy? == false -> :fatal
      true -> :unknown
    end
  end

  def alert_recipient(level, legacy?) do
    # Please implement the alert_recipient/2 function
    cond do
      to_label(level, legacy?) == :unknown and legacy? == true -> :dev1
      to_label(level, legacy?) == :unknown and legacy? == false -> :dev2
      level == 4 -> :ops
      level == 5 -> :ops
      true -> false
    end
  end
end


# You are running a system that consists of a few applications producing many logs. You want to write a small program that will aggregate those logs and give them labels according to their severity level. All applications in your system use the same log codes, but some of the legacy applications don't support all the codes.

# Log code	Log label	Supported in legacy apps?
# 0	trace	no
# 1	debug	yes
# 2	info	yes
# 3	warning	yes
# 4	error	yes
# 5	fatal	no
# ?	unknown	-
# Task 1
# Return the logging code label

# Implement the LogLevel.to_label/2 function. It should take an integer code and a boolean flag telling you if the log comes from a legacy app, and return the label of a log line as an atom. Unknown log codes and codes unsupported in a legacy app should return an unknown label.

# LogLevel.to_label(0, false)
# # => :trace

# Somebody has to be notified when unexpected things happen.

# Implement the LogLevel.alert_recipient/2 function to determine to whom the alert needs to be sent. The function should take an integer code and a boolean flag telling you if the log comes from a legacy app, and return the name of the recipient as an atom.

# If the log label is error or fatal, send the alert to the ops team. If you receive a log with an unknown label from a legacy system, send the alert to the dev1 team, other unknown labels should be sent to the dev2 team. All other log labels can be safely ignored.

# LogLevel.alert_recipient(-1, true)
# # => :dev1
