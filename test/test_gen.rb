require 'minitest/autorun'

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require "test_helper"
require "random_token"
require "length/test_length"
require "length/test_case"
require "length/test_friendly"
require "length/test_seed"
require "length/test_mask"
require "length/test_hash_seed"
require "length/test_byte"
require "format/test_pattern"
require "format/test_percent"

class TestGen < Minitest::Test
  def test_gen_should_raise_an_exception_if_the_given_arg_is_invalid
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen(nil) }
    assert(e.code == :invalid_gen_arg)
  end

  def test_gen_should_raise_an_exception_if_the_given_options_are_duplicated
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen(8, :s => :a, :seed => :o) }
    assert(e.code == :duplicated_option)
  end

  def test_gen_should_raise_an_exception_if_the_given_option_values_are_invalid
    invalid_value = 'invalid_value'
    e = assert_raises(RandomToken::RandomTokenError) { RandomToken.gen(8, :c => invalid_value) }
    assert(e.code == :invalid_option_value)
  end
end
