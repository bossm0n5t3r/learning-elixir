# https://elixir-lang.org/getting-started/basic-types.html

ExUnit.start()

defmodule BasicTypes do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/basic-types.html
  test "Basic types" do
    assert is_integer(1)
    assert is_integer(0x1F)
    assert is_float(1.0)
    assert is_boolean(true)
    assert is_atom(:atom)
    assert is_bitstring("elixir")
    assert is_list([1, 2, 3])
    assert is_tuple({1, 2, 3})
  end

  # https://elixir-lang.org/getting-started/basic-types.html#basic-arithmetic
  test "Basic arithmetic" do
    assert 1 + 2 == 3
    assert 5 * 5 == 25
    # Notice that 10 / 2 returned a float 5.0 instead of an integer 5.
    assert 10 / 2 == 5.0

    # If you want to do integer division or get the division remainder,
    # you can invoke the div and rem functions.
    assert div(10, 2) == 5
    assert div(10, 2) == 5
    assert rem(10, 2) == 0
    assert rem(10, 3) == 1

    # Elixir also supports shortcut notations for entering binary, octal, and hexadecimal numbers
    assert 0b1010 == 10
    assert 0o777 == 511
    assert 0x1F == 31

    # Float numbers require a dot followed by at least one digit and
    # also support e for scientific notation
    assert 1.0 == 1.0
    assert 1.0e-10 == 1.0e-10

    # Floats in Elixir are 64-bit double precision.
    # You can invoke the round function to get the closest integer to a given float,
    # or the trunc function to get the integer part of a float.
    assert round(3.58) == 4
    assert trunc(3.58) == 3
  end

  # https://elixir-lang.org/getting-started/basic-types.html#booleans
  test "Booleans" do
    assert true
    refute true == false
    assert is_boolean(true)
    refute is_boolean(1)
  end

  # https://elixir-lang.org/getting-started/basic-types.html#atoms
  test "Atoms" do
    # An atom is a constant whose value is its own name.
    # Some other languages call these symbols.
    # They are often useful to enumerate over distinct values.
    assert :apple == :apple
    assert :orange == :orange
    assert :watermelon == :watermelon
    refute :apple == :orange

    # The booleans true and false are also atoms.
    assert true == :true
    assert is_atom(false)
    assert is_boolean(:false)

    # Elixir allows you to skip the leading : for the atoms false, true and nil.
    # Finally, Elixir has a construct called aliases which we will explore later.
    # Aliases start in upper case and are also atoms:
    assert is_atom(Hello)
  end

  # https://elixir-lang.org/getting-started/basic-types.html#strings
  test "Strings" do
    # Strings in Elixir are delimited by double quotes, and they are encoded in UTF-8:
    assert "hellö" == "hellö"

    string = :world
    assert "hellö #{string}" == "hellö world"

    assert is_binary("hellö")

    # Notice that the number of bytes in that string is 6, even though it has 5 graphemes.
    # That’s because the grapheme “ö” takes 2 bytes to be represented in UTF-8.
    assert byte_size("hellö") == 6
    assert String.length("hellö") == 5

    assert String.upcase("hellö") == "HELLÖ"
  end

  # https://elixir-lang.org/getting-started/basic-types.html#anonymous-functions
  test "Anonymous functions" do
    add = fn a, b -> a + b end

    assert add.(1, 2) == 3
    assert is_function(add)

    # check if add is a function that expects exactly 2 arguments
    assert is_function(add, 2)

    # check if add is a function that expects exactly 1 argument
    refute is_function(add, 1)

    double = fn a -> add.(a, a) end

    assert double.(2) == 4

    x = 42
    assert (fn -> x = 0 end).() == 0
    assert x == 42
  end

  # https://elixir-lang.org/getting-started/basic-types.html#linked-lists
  test "(Linked) Lists" do
    assert [1, 2, true, 3] == [1, 2, true, 3]
    assert length([1, 2, 3]) == 3

    assert [1, 2, 3] ++ [4, 5, 6] == [1, 2, 3, 4, 5, 6]
    assert [1, true, 2, false, 3, true] -- [true, false] == [1, 2, 3, true]

    # List operators never modify the existing list.
    # Concatenating to or removing elements from a list returns a new list.
    # We say that Elixir data structures are immutable.
    # One advantage of immutability is that it leads to clearer code.
    # You can freely pass the data around with the guarantee no one will mutate it in memory - only transform it.

    list = [1, 2, 3]
    assert hd(list) == 1
    assert tl(list) == [2, 3]

    assert_raise ArgumentError, fn -> hd([]) end

    # Single quotes are charlists, double quotes are strings.
    assert [104, 101, 108, 108, 111] == ~c"hello"
    refute ~c"hello" == "hello"
    assert ~c"hello" == ~c"hello"
  end

  # https://elixir-lang.org/getting-started/basic-types.html#tuples
  test "Tuples" do
    assert {:ok, "hello"} == {:ok, "hello"}
    assert tuple_size({:ok, "hello"}) == 2

    tuple = {:ok, "hello"}
    assert elem(tuple, 1) == "hello"
    assert tuple_size(tuple) == 2

    # The original tuple stored in the tuple variable was not modified.
    # Like lists, tuples are also immutable.
    # Every operation on a tuple returns a new tuple, it never changes the given one.
    assert put_elem(tuple, 1, "world") == {:ok, "world"}
    assert tuple == {:ok, "hello"}
  end

  # https://elixir-lang.org/getting-started/basic-types.html#lists-or-tuples
  test "Lists or tuples?" do
    # What is the difference between lists and tuples?

    # Lists are stored in memory as linked lists,
    # meaning that each element in a list holds its value and points to the following element
    # until the end of the list is reached.
    # This means accessing the length of a list is a linear operation:
    # we need to traverse the whole list in order to figure out its size.

    # Similarly, the performance of list concatenation depends on the length of the left-hand list:
    list = [1, 2, 3]

    # This is fast as we only need to traverse `[0]` to prepend to `list`
    assert [0] ++ list == [0, 1, 2, 3]

    # This is slow as we need to traverse `list` to append 4
    assert list ++ [4] == [1, 2, 3, 4]

    # Tuples, on the other hand, are stored contiguously in memory.
    # This means getting the tuple size or accessing an element by index is fast.
    # However, updating or adding elements to tuples is expensive
    # because it requires creating a new tuple in memory:
    tuple = {:a, :b, :c, :d}

    assert put_elem(tuple, 2, :e) == {:a, :b, :e, :d}
    assert tuple == {:a, :b, :c, :d}

    tuple = {:ok, "hello"}
    assert elem(tuple, 1) == "hello"
  end
end
