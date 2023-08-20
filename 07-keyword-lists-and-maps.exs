# https://elixir-lang.org/getting-started/keywords-and-maps.html

ExUnit.start()

defmodule KeywordListsAndMaps do
  use ExUnit.Case

  # https://elixir-lang.org/getting-started/keywords-and-maps.html#keyword-lists
  test "Keyword lists" do
    assert String.split("1 2 3", " ") == ["1", "2", "3"]
    assert String.split("1  2  3", " ") == ["1", "", "2", "", "3"]
    assert String.split("1  2  3", " ", [trim: true]) == ["1", "2", "3"]
    assert String.split("1  2  3", " ", trim: true) == ["1", "2", "3"]
    assert [{:trim, true}] == [trim: true]

    list = [a: 1, b: 2]
    assert list ++ [c: 3] == [a: 1, b: 2, c: 3]
    assert [a: 0] ++ list == [a: 0, a: 1, b: 2]
    assert list[:a] == 1
    assert list[:b] == 2

    # In case of duplicate keys, values added to the front are the ones fetched:
    new_list = [a: 0] ++ list
    assert new_list[:a] == 0

    # Keyword lists are important because they have three special characteristics:
    #   Keys must be atoms.
    #   Keys are ordered, as specified by the developer.
    #   Keys can be given more than once.
  end

  # https://elixir-lang.org/getting-started/keywords-and-maps.html#do-blocks-and-keywords
  test "do-blocks and keywords" do
    seen =
      if true do
        "This will be seen"
      else
        "This won't"
      end

    assert seen == "This will be seen"

    rewrite = if true, do: "This will be seen", else: "This won't"
    assert rewrite == "This will be seen"
  end

  # https://elixir-lang.org/getting-started/keywords-and-maps.html#maps-as-key-value-pairs
  test "Maps as key-value pairs" do
    # Whenever you need to store key-value pairs, maps are the “go to” data structure in Elixir.
    # A map is created using the %{} syntax:
    map = %{:a => 1, 2 => :b}
    assert map[:a] == 1
    assert map[2] == :b
    assert map[:c] == nil

    # Compared to keyword lists, we can already see two differences:
    #   Maps allow any value as a key.
    #   Maps’ keys do not follow any ordering.
    %{} = %{:a => 1, 2 => :b}
    %{:a => a} = %{:a => 1, 2 => :b}
    assert a == 1

    assert_raise MatchError, fn ->
      %{:c => c} = %{:a => 1, 2 => :b}
    end

    # The Map module provides a very similar API to the Keyword module
    # with convenience functions to add, remove, and update maps keys:
    assert Map.get(%{:a => 1, 2 => :b}, :a) == 1
    assert Map.put(%{:a => 1, 2 => :b}, :c, 3) == %{2 => :b, :a => 1, :c => 3}
    assert Map.to_list(%{:a => 1, 2 => :b}) == [{2, :b}, {:a, 1}]
  end

  # https://elixir-lang.org/getting-started/keywords-and-maps.html#maps-of-fixed-keys
  test "Maps of fixed keys" do
    map = %{:name => "John", :age => 23}
    assert map.name == "John"
  end

  # https://elixir-lang.org/getting-started/keywords-and-maps.html#nested-data-structures
  test "Nested data structures" do
    users = [
      john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
      mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
    ]

    assert users[:john].age == 27

    users = put_in(users[:john].age, 31)

    users =
      update_in(users[:mary].languages, fn languages -> List.delete(languages, "Clojure") end)
  end

  # Summary

  # This concludes our introduction to associative data structures in Elixir.
  # As a summary, you should:
  #   Use keyword lists for passing optional values to functions
  #   Use maps for general key-value data structures and when working with known data (with fixed keys)
end
