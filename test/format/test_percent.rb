gem "minitest"
require "minitest/autorun"
require "random_token"

class TestPercent < Minitest::Test
  def test_gen_should_create_a_random_with_percent_signs
    length = 10000
    pattern = "===%#{length}%===%%==="
    token = RandomToken.gen(pattern)
    assert_match(/^===%{#{length}}===%===$/, token)
  end
end
