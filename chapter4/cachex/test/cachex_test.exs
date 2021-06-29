defmodule CacheXTest do
  use ExUnit.Case
  doctest CacheX

  @key :testing
  @value ["one", "two", "three"]

  test "write" do
    CacheX.write(@key, @value)
    assert CacheX.read(@key) == @value
  end

  test "delete" do
    CacheX.write(@key, @value)
    assert CacheX.read(@key) == @value
    CacheX.delete(@key)

    catch_exit(CacheX.read(@key))
  end

  test "exist?" do
    CacheX.write(@key, @value)
    assert CacheX.exist?(@key)
    CacheX.delete(@key)
    :timer.sleep(1)
    refute CacheX.exist?(@key)
  end
end
