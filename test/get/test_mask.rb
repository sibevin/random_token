gem "minitest"
require "minitest/autorun"
require "random_token"

class TestMask < Minitest::Test
  def test_get_should_use_given_mask
    length = 10000
    mask = ['a','b','c','d','e','0','1','2','3','4']
    token = RandomToken.get(length, :mask => mask)
    assert((token.split(//).uniq - mask) == token.split(//).uniq)
  end

  def test_get_should_raise_an_exception_if_mask_is_given_but_friendly_option_is_false
    length = 10000
    mask = ['a','b','c','d','e','0','1','2','3','4']
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.get(length, :mask => mask,
                                                                              :friendly => false) }
    assert(e.code == :false_friendly_with_given_mask)
  end

  def test_get_should_raise_an_exception_if_mask_remove_all_seeds
    length = 10000
    seed = ['a']
    mask = ['a']
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.get(length, :seed => seed,
                                                                              :mask => mask) }
    assert(e.code == :mask_remove_all_seeds)
  end
end
