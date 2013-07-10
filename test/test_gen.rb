require "test/unit"

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require "test_helper"
require "random_token"

class TestGen < Test::Unit::TestCase
  def test_gen_should_raise_an_exception_if_the_given_arg_is_invalid
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.gen(nil) }
    assert(e.code == :invalid_gen_arg)
  end
end
