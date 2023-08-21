# https://elixir-lang.org/getting-started/modules-and-functions.html

ExUnit.start()

defmodule ModulesAndFunctions do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/modules-and-functions.html#compilation
  test "Compilation" do
    defmodule Math do
      def sum(a, b) do
        a + b
      end
    end

    assert Math.sum(1, 2) == 3
  end

  # Scripted mode
  # https://elixir-lang.org/getting-started/modules-and-functions.html#scripted-mode

  # https://elixir-lang.org/getting-started/modules-and-functions.html#named-functions
  test "Named functions" do
    defmodule Math do
      def sum(a, b) do
        do_sum(a, b)
      end

      defp do_sum(a, b) do
        a + b
      end
    end

    assert Math.sum(1, 2) == 3

    assert_raise UndefinedFunctionError, fn ->
      Math.do_sum(1, 2)
    end

    # Naming Conventions
    # https://hexdocs.pm/elixir/naming-conventions.html

    defmodule MathZero0 do
      def zero?(0) do
        true
      end

      def zero?(x) when is_integer(x) do
        false
      end
    end

    assert MathZero0.zero?(0)
    refute MathZero0.zero?(1)

    assert_raise FunctionClauseError, fn ->
      MathZero0.zero?([1, 2, 3])
    end

    assert_raise FunctionClauseError, fn ->
      MathZero0.zero?(0.0)
    end

    defmodule MathZero1 do
      def zero?(0), do: true
      def zero?(x) when is_integer(x), do: false
    end

    assert MathZero1.zero?(0)
    refute MathZero1.zero?(1)

    assert_raise FunctionClauseError, fn ->
      MathZero1.zero?([1, 2, 3])
    end

    assert_raise FunctionClauseError, fn ->
      MathZero1.zero?(0.0)
    end
  end

  # https://elixir-lang.org/getting-started/modules-and-functions.html#function-capturing
  test "Function capturing" do
    defmodule Math do
      def zero?(0), do: true
      def zero?(x) when is_integer(x), do: false
    end

    assert Math.zero?(0)
    fun = &Math.zero?/1
    assert is_function(fun)
    assert fun.(0)

    # Local or imported functions, like is_function/1, can be captured without the module:
    &is_function/1
    assert (&is_function/1).(fun)

    # You can also capture operators:
    add = &+/2
    assert add.(1, 2) == 3

    # Note the capture syntax can also be used as a shortcut for creating functions:
    fun = &(&1 + 1)
    assert fun.(1) == 2

    fun2 = &"Good #{&1}"
    assert fun2.("morning") == "Good morning"
  end

  # https://elixir-lang.org/getting-started/modules-and-functions.html#default-arguments
  test "Default arguments" do
    defmodule Concat do
      def join(a, b, sep \\ " ") do
        a <> sep <> b
      end
    end

    assert Concat.join("Hello", "world") == "Hello world"
    assert Concat.join("Hello", "world", "_") == "Hello_world"

    defmodule DefaultTest do
      def dowork(x \\ "hello") do
        x
      end
    end

    assert DefaultTest.dowork() == "hello"
    assert DefaultTest.dowork(123 == 123)
    assert DefaultTest.dowork() == "hello"

    defmodule Concat1 do
      # A function head declaring defaults
      def join(a, b \\ nil, sep \\ " ")

      def join(a, b, _sep) when is_nil(b) do
        a
      end

      def join(a, b, sep) do
        a <> sep <> b
      end
    end

    assert Concat1.join("Hello", "world") == "Hello world"
    assert Concat1.join("Hello", "world", "_") == "Hello_world"
    assert Concat1.join("Hello") == "Hello"
  end
end
