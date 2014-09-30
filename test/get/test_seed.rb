require 'minitest/autorun'
require "random_token"

class TestSeed < Minitest::Test
  def test_get_should_create_a_random_with_alphabets_only
    length = 10000
    token = RandomToken.get(length, :seed => :a)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.get(length, :seed => :alphabet)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.get(length, :seed => :l)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.get(length, :seed => :letter)
    assert_match(/^[A-Za-z]*$/, token)
  end

  def test_get_should_create_a_random_with_numbers_only
    length = 10000
    token = RandomToken.get(length, :seed => :n)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.get(length, :seed => :number)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.get(length, :seed => 1)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.get(length, :seed => 10)
    assert_match(/^[0-9]*$/, token)
  end

  def test_get_should_create_a_random_with_0_and_1_only
    length = 10000
    token = RandomToken.get(length, :seed => :b)
    assert_match(/^[01]*$/, token)
    token = RandomToken.get(length, :seed => :binary)
    assert_match(/^[01]*$/, token)
    token = RandomToken.get(length, :seed => 2)
    assert_match(/^[01]*$/, token)
  end

  def test_get_should_create_a_random_with_octal_digits
    length = 10000
    token = RandomToken.get(length, :seed => :o)
    assert_match(/^[0-7]*$/, token)
    token = RandomToken.get(length, :seed => :oct)
    assert_match(/^[0-7]*$/, token)
    token = RandomToken.get(length, :seed => 8)
    assert_match(/^[0-7]*$/, token)
  end

  def test_get_should_create_a_random_with_hexadecimal_digits
    length = 10000
    token = RandomToken.get(length, :seed => :h)
    assert_match(/^[0-9A-F]*$/, token)
    token = RandomToken.get(length, :seed => :hex)
    assert_match(/^[0-9A-F]*$/, token)
    token = RandomToken.get(length, :seed => 16)
    assert_match(/^[0-9A-F]*$/, token)
  end

  def test_get_should_create_a_random_with_given_seeds
    length = 10000
    seeds = ['a', 'b', 'c', '1', '2', '3', '!', '@', '#', '$', '%',
             '^', '&', '*', '(', ')', '-', '_', '=', '+', '{', '}',
             '[', ']', '\\', '|', ';', ':', '\'', '"', ',', '<',
             '.', '>', '/', '?', '`', '~']
    token = RandomToken.get(length, :seed => seeds)
    targets = "[#{Regexp.escape(seeds.join)}]"
    assert_match(/^#{targets}*$/, token)
  end
end
