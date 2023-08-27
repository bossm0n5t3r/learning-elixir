# https://elixir-lang.org/getting-started/processes.html

ExUnit.start()

defmodule Processes do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/processes.html#spawn
  test "spawn" do
    pid = spawn(fn -> 1 + 2 end)
    assert Process.alive?(pid)

    self()
    assert Process.alive?(self())
  end

  # https://elixir-lang.org/getting-started/processes.html#send-and-receive
  test "send and receive" do
    send(self(), {:hello, "world"})

    result0 =
      receive do
        {:hello, msg} -> msg
        {:world, _msg} -> "won't match"
      end

    assert result0 == "world"

    result1 =
      receive do
        {:hello, msg} -> msg
      after
        1_000 -> "nothing after 1s"
      end

    assert result1 == "nothing after 1s"

    parent = self()
    spawn(fn -> send(parent, {:hello, self()}) end)

    result2 =
      receive do
        {:hello, pid} -> "Got hello from #{inspect(pid)}"
      end

    # Got hello from #PID<~>
    IO.puts(result2)
  end

  # https://elixir-lang.org/getting-started/processes.html#links
  test "Links" do
    # Do run on "iex"
  end

  # https://elixir-lang.org/getting-started/processes.html#tasks
  test "Tasks" do
    # Do run on "iex"
  end

  # https://elixir-lang.org/getting-started/processes.html#state
  test "State" do
    # Do run on "iex"
  end
end
