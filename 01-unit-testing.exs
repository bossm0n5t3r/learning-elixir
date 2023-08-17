# http://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html
# https://hexdocs.pm/ex_unit/ExUnit.html
# https://elixirschool.com/en/lessons/testing/basics

# set up the test runner
ExUnit.start

defmodule UnitTesting do
  # use requires a module and sets up macros; will explore more later

  # Note that we pass "async: true", this runs the test case
  # concurrently with other test cases. The individual tests
  # within each test case are still run serially.
  use ExUnit.Case, async: true

  test 'simple test' do
    # Elixir is smart! No need for assert_equal, assert_gte, etc.
    # And we still get great failure messages, yipee!

    # 1) test simple test (UnitTesting)
    #    Assertion with == failed
    #    code:  assert 40 + 2 == 43
    #    left:  42
    #    right: 43
    #    stacktrace:
    #      01-unit-testing.exs:27: (test)
    assert 40 + 2 == 42 # 43 으로 바꿔서 실행하면 위의 실패 메시지를 확인할 수 있다.
  end

  # test macro accepts string as test name
  test "refute is opposite of assert" do
    refute 1 + 1 == 3
  end

  # test macro also accepts an atom
  test :assert_raise do
    assert_raise ArithmeticError, fn ->
      1 + "x"
    end
  end

  test "assert_in_delta asserts that val1 and val2 differ by less than delta." do
    assert_in_delta 1, # actual
                    5, # expected
                    6  # delta
  end
end
