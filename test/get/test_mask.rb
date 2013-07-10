require "test/unit"
require "random_token"

class TestMask < Test::Unit::TestCase
  def test_get_should_use_given_mask
    length = 10000
    mask = ['a','b','c','d','e','0','1','2','3','4']
    token = RandomToken.get(length, :mask => mask)
    assert((token.split(//).uniq - mask) == token.split(//).uniq)
  end

  def test_get_should_raise_an_exception_if_mask_is_given_but_friendly_option_is_false
    length = 10000
    mask = ['a','b','c','d','e','0','1','2','3','4']
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.get(length, :mask => mask,
                                                                              :friendly => false) }
    assert(e.code == :false_friendly_with_given_mask)
  end
end
