require "minitest/autorun"
require "random_token"

class TestByte < Minitest::Test
  def test_gen_should_create_a_random_with_16xlength_with_binary_seed
    length = 32
    token = RandomToken.gen(length, :seed => :binary, :byte => true)
    assert_match(/^[0-1]{#{length*16}}$/, token)
    token = RandomToken.gen(length, :seed => :binary, :b => true)
    assert_match(/^[0-1]{#{length*16}}$/, token)
  end

  def test_gen_should_create_a_random_with_4xlength_with_oct_seed
    length = 32
    token = RandomToken.gen(length, :seed => :oct, :byte => true)
    assert_match(/^[0-7]{#{length*4}}$/, token)
    token = RandomToken.gen(length, :seed => :oct, :b => true)
    assert_match(/^[0-7]{#{length*4}}$/, token)
  end

  def test_gen_should_create_a_random_with_2xlength_with_hex_seed
    length = 32
    token = RandomToken.gen(length, :seed => :hex, :byte => true)
    assert_match(/^[A-Z0-9]{#{length*2}}$/, token)
    token = RandomToken.gen(length, :seed => :hex, :b => true)
    assert_match(/^[A-Z0-9]{#{length*2}}$/, token)
  end

  def test_gen_should_not_support_byte_feature_when_use_format
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen("%b", :byte => true) }
    assert(e.code == :format_not_support_byte)
  end

  def test_gen_should_not_support_byte_feature_when_creating_alphabet_number_random
    length = 10000
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen(length, :byte => true) }
    assert(e.code == :not_support_byte)
  end

  def test_gen_should_not_support_byte_feature_when_creating_alphabet_random
    length = 10000
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => :a, :byte => true) }
    assert(e.code == :not_support_byte)
  end

  def test_gen_should_not_support_byte_feature_when_creating_number_random
    length = 10000
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => :n, :byte => true) }
    assert(e.code == :not_support_byte)
  end

  def test_gen_should_not_support_byte_feature_when_creating_random_with_seed_array
    length = 10000
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => ['a', 'b'], :byte => true) }
    assert(e.code == :not_support_byte)
  end

  def test_gen_should_not_support_byte_feature_when_creating_random_with_seed_hash
    length = 10000
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => {'a' => 1, 'b' => 2}, :byte => true) }
    assert(e.code == :not_support_byte)
  end
end
