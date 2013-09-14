require "test/unit"
require "random_token"

class TestLength < Test::Unit::TestCase
  def test_gen_should_create_a_given_length_random_string
    length = 8
    token = RandomToken.gen(length)
    assert_match(/^.{#{length}}$/, token)
  end
end
