require "test/unit"
require "random_token"

class TestCase < Test::Unit::TestCase
  def test_gen_should_create_a_random_with_upper_case_alphabets_or_numbers
    length = 10000
    token = RandomToken.gen(length, :case => :up)
    assert_match(/^[A-Z0-9]{#{length}}$/, token)
    token = RandomToken.gen(length, :case => :u)
    assert_match(/^[A-Z0-9]{#{length}}$/, token)
    token = RandomToken.gen(length, :c => :up)
    assert_match(/^[A-Z0-9]{#{length}}$/, token)
    token = RandomToken.gen(length, :c => :u)
    assert_match(/^[A-Z0-9]{#{length}}$/, token)
  end

  def test_gen_should_create_a_random_with_lower_case_alphabets_or_numbers
    length = 10000
    token = RandomToken.gen(length, :case => :down)
    assert_match(/^[a-z0-9]{#{length}}$/, token)
    token = RandomToken.gen(length, :case => :d)
    assert_match(/^[a-z0-9]{#{length}}$/, token)
    token = RandomToken.gen(length, :c => :down)
    assert_match(/^[a-z0-9]{#{length}}$/, token)
    token = RandomToken.gen(length, :c => :d)
    assert_match(/^[a-z0-9]{#{length}}$/, token)
  end

  def test_gen_should_not_support_case_feature_when_creating_binray_random
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => :b, :case => :up) }
    assert(e.code == :not_support_case)
  end

  def test_gen_should_not_support_case_feature_when_creating_octal_random
    length = 10000
    e = assert_raise(RandomToken::RandomTokenError) { RandomToken.gen(length, :seed => :o, :case => :up) }
    assert(e.code == :not_support_case)
  end

  def test_gen_should_use_upper_case_by_default_when_creating_hexdecimal_random
    length = 10000
    token = RandomToken.gen(length, :seed => :h)
    assert_match(/^[0-9A-F]*$/, token)
  end

  def test_gen_should_keep_case_by_default_when_creating_random_with_given_seeds
    length = 10000
    seeds = ['a', 'B', 'c', 'D', 'e', 'F', 'g', 'H', 'i', 'J', 'k', 'L', 'm', 'N']
    token = RandomToken.gen(length, :seed => seeds)
    targets = "[#{Regexp.escape(seeds.join)}]"
    assert_match(/^#{targets}*$/, token)
  end
end
