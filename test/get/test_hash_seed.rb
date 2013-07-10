require "test/unit"
require "random_token"

class TestHashSeed < Test::Unit::TestCase
  def test_get_should_create_a_random_with_the_given_seeds
    length = 10000
    token = RandomToken.get(length, :seed => { 'a' => 1, 'b' => 2, 'c' => 3 })
    assert_match(/^[a-c]{#{length}}$/, token)
  end

  def test_get_should_create_a_random_with_the_given_distribution_of_seeds
    length = 1000000
    token = RandomToken.get(length, :seed => { 'a' => 1, 'b' => 2, 'c' => 3 })
    a_count = token.count('a')
    b_count = token.count('b')
    c_count = token.count('c')
    assert_in_delta(b_count.to_f/(2*a_count), 1, 0.01)
    assert_in_delta(c_count.to_f/(3*a_count), 1, 0.01)
  end

  def test_get_should_not_support_case_feature_when_given_the_hash_seed
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { 
      RandomToken.get(length, :seed => { 'a' => 1, 'b' => 2, 'c' => 3 }, :case => :up)
    }
    assert(e.code == :not_support_case)
  end

  def test_get_should_not_support_friendly_feature_when_given_the_hash_seed
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { 
      RandomToken.get(length, :seed => { 'a' => 1, 'b' => 2, 'c' => 3 }, :friendly => true)
    }
    assert(e.code == :not_support_friendly)
  end
end
