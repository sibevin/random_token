require "test/unit"
require "random_token"

class TestSeed < Test::Unit::TestCase
  def test_gen_should_create_a_random_with_alphabets_only
    length = 10000
    token = RandomToken.gen(length, :seed => :a)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.gen(length, :seed => :alphabet)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.gen(length, :seed => :l)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.gen(length, :seed => :letter)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.gen(length, :s => :a)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.gen(length, :s => :alphabet)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.gen(length, :s => :l)
    assert_match(/^[A-Za-z]*$/, token)
    token = RandomToken.gen(length, :s => :letter)
    assert_match(/^[A-Za-z]*$/, token)
  end

  def test_gen_should_create_a_random_with_numbers_only
    length = 10000
    token = RandomToken.gen(length, :seed => :n)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.gen(length, :seed => :number)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.gen(length, :seed => 1)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.gen(length, :seed => 10)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.gen(length, :s => :n)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.gen(length, :s => :number)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.gen(length, :s => 1)
    assert_match(/^[0-9]*$/, token)
    token = RandomToken.gen(length, :s => 10)
    assert_match(/^[0-9]*$/, token)
  end

  def test_gen_should_create_a_random_with_0_and_1_only
    length = 10000
    token = RandomToken.gen(length, :seed => :b)
    assert_match(/^[01]*$/, token)
    token = RandomToken.gen(length, :seed => :binary)
    assert_match(/^[01]*$/, token)
    token = RandomToken.gen(length, :seed => 2)
    assert_match(/^[01]*$/, token)
    token = RandomToken.gen(length, :s => :b)
    assert_match(/^[01]*$/, token)
    token = RandomToken.gen(length, :s => :binary)
    assert_match(/^[01]*$/, token)
    token = RandomToken.gen(length, :s => 2)
    assert_match(/^[01]*$/, token)
  end

  def test_gen_should_create_a_random_with_octal_digits
    length = 10000
    token = RandomToken.gen(length, :seed => :o)
    assert_match(/^[0-7]*$/, token)
    token = RandomToken.gen(length, :seed => :oct)
    assert_match(/^[0-7]*$/, token)
    token = RandomToken.gen(length, :seed => 8)
    assert_match(/^[0-7]*$/, token)
    token = RandomToken.gen(length, :s => :o)
    assert_match(/^[0-7]*$/, token)
    token = RandomToken.gen(length, :s => :oct)
    assert_match(/^[0-7]*$/, token)
    token = RandomToken.gen(length, :s => 8)
    assert_match(/^[0-7]*$/, token)
  end

  def test_gen_should_create_a_random_with_hexadecimal_digits
    length = 10000
    token = RandomToken.gen(length, :seed => :h)
    assert_match(/^[0-9A-F]*$/, token)
    token = RandomToken.gen(length, :seed => :hex)
    assert_match(/^[0-9A-F]*$/, token)
    token = RandomToken.gen(length, :seed => 16)
    assert_match(/^[0-9A-F]*$/, token)
    token = RandomToken.gen(length, :s => :h)
    assert_match(/^[0-9A-F]*$/, token)
    token = RandomToken.gen(length, :s => :hex)
    assert_match(/^[0-9A-F]*$/, token)
    token = RandomToken.gen(length, :s => 16)
    assert_match(/^[0-9A-F]*$/, token)
  end

  def test_gen_should_create_a_random_with_given_seeds
    length = 10000
    seeds = ['a', 'b', 'c', '1', '2', '3', '!', '@', '#', '$', '%',
             '^', '&', '*', '(', ')', '-', '_', '=', '+', '{', '}',
             '[', ']', '\\', '|', ';', ':', '\'', '"', ',', '<',
             '.', '>', '/', '?', '`', '~']
    token = RandomToken.gen(length, :seed => seeds)
    assert_match(/^#{"[#{Regexp.escape(seeds.join)}]"}*$/, token)
    token = RandomToken.gen(length, :s => seeds)
    assert_match(/^#{"[#{Regexp.escape(seeds.join)}]"}*$/, token)
  end
end
