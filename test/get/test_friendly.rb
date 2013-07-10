require "test/unit"
require "random_token"

class TestFriendly < Test::Unit::TestCase
  def test_get_should_not_create_a_random_including_masked_alphabets_or_numbers
    length = 10000
    token = RandomToken.get(length, :friendly => true)
    assert((RandomToken.default_mask - token.split(//).uniq) == RandomToken.default_mask)
  end

  def test_get_should_not_support_friendly_feature_when_creating_binary_random
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.get(length, :seed => :b, :friendly => true) }
    assert(e.code == :not_support_friendly)
  end

  def test_get_should_not_support_friendly_feature_when_creating_octal_random
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.get(length, :seed => :o, :friendly => true) }
    assert(e.code == :not_support_friendly)
  end

  def test_get_should_not_support_friendly_feature_when_creating_hexadecimal_random
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.get(length, :seed => :h, :friendly => true) }
    assert(e.code == :not_support_friendly)
  end

  def test_get_should_support_friendly_feature_when_creating_random_with_given_seeds
    length = 10000
    seeds = ['a','b','c','d','e','0','1','2','3','4']
    token = RandomToken.get(length, :seed => seeds, :friendly => true)
    assert((token.split(//).uniq - RandomToken.default_mask) == token.split(//).uniq)
  end
end
