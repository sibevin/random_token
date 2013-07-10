require "test/unit"
require "random_token"

class TestPercent < Test::Unit::TestCase
  def test_get_should_create_a_random_with_percent_signs
    length = 10000 
    pattern = "===%#{length}%===%%==="
    token = RandomToken.strf(pattern)
    assert_match(/^===%{#{length}}===%===$/, token)
  end
end
