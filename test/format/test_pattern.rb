require "test/unit"
require "random_token"

class TestPattern < Test::Unit::TestCase
  def test_gen_should_create_a_random_with_alphabets
    length = 10000 
    pattern = "===%#{length}A===%#{length}a===Aa==="
    token = RandomToken.gen(pattern)
    assert_match(/^===[A-Z]{#{length}}===[a-z]{#{length}}===Aa===$/, token)
  end

  def test_gen_should_create_a_random_with_numbers
    length = 10000 
    pattern = "===%#{length}n===n==="
    token = RandomToken.gen(pattern)
    assert_match(/^===[0-9]{#{length}}===n===$/, token)
  end

  def test_gen_should_create_a_random_with_0_and_1
    length = 10000 
    pattern = "===%#{length}b===b==="
    token = RandomToken.gen(pattern)
    assert_match(/^===[0-1]{#{length}}===b===$/, token)
  end

  def test_gen_should_create_a_random_with_octal_digits
    length = 10000 
    pattern = "===%#{length}o===o==="
    token = RandomToken.gen(pattern)
    assert_match(/^===[0-8]{#{length}}===o===$/, token)
  end

  def test_gen_should_create_a_random_with_hexadecimal_digits
    length = 10000 
    pattern = "===%#{length}h===%#{length}H===hH==="
    token = RandomToken.gen(pattern)
    assert_match(/^===[0-9a-f]{#{length}}===[0-9A-F]{#{length}}===hH===$/, token)
  end

  def test_gen_should_create_a_random_with_alphabets_and_numbers
    length = 10000 
    pattern = "===%#{length}x===%#{length}X===xX==="
    token = RandomToken.gen(pattern)
    assert_match(/^===[0-9a-z]{#{length}}===[0-9A-Z]{#{length}}===xX===$/, token)
  end

  def test_gen_should_create_a_random_with_given_format
    length = 10000 
    pattern = "===%#{length}?===?==="
    token = RandomToken.gen(pattern)
    assert_match(/^===.{#{length}}===\?===$/, token)
  end

  def test_gen_should_raise_an_exception_if_the_given_pattern_is_invalid
    pattern = "===%123==="
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.gen(pattern) }
    assert(e.code == :invalid_strf_pattern)
  end
end
