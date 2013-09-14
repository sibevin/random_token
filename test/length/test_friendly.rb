require "test/unit"
require "random_token"

class TestFriendly < Test::Unit::TestCase
  def test_gen_should_not_create_a_random_including_masked_alphabets_or_numbers
    length = 10000
    token = RandomToken.gen(length, :friendly => true)
    assert((RandomToken::MASK - token.split(//).uniq) == RandomToken::MASK)
    token = RandomToken.gen(length, :f => true)
    assert((RandomToken::MASK - token.split(//).uniq) == RandomToken::MASK)
  end

  def test_gen_should_not_support_friendly_feature_when_creating_binary_random
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => :b, :friendly => true) }
    assert(e.code == :not_support_friendly)
  end

  def test_gen_should_not_support_friendly_feature_when_creating_octal_random
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => :o, :friendly => true) }
    assert(e.code == :not_support_friendly)
  end

  def test_gen_should_not_support_friendly_feature_when_creating_hexadecimal_random
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => :h, :friendly => true) }
    assert(e.code == :not_support_friendly)
  end

  def test_gen_should_support_friendly_feature_when_creating_random_with_given_seeds
    length = 10000
    seeds = ['a','b','c','d','e','0','1','2','3','4']
    token = RandomToken.gen(length, :seed => seeds, :friendly => true)
    assert((token.split(//).uniq - RandomToken::MASK) == token.split(//).uniq)
  end
end
