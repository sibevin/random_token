lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'random_token/version'

Gem::Specification.new do |spec|
  spec.name          = "random_token"
  spec.version       = RandomToken::VERSION
  spec.authors       = ["Sibevin Wang"]
  spec.email         = ["sibevin@gmail.com"]
  spec.description   = %q{A simple way to generate a random token.}
  spec.summary       = <<-EOF
Use "gen" method to create a random token with a given length.

  RandomToken.gen(8)
  # "iUEFxcG2"

Some options can help to modify the token format.

  RandomToken.gen(20, seed: :alphabet, friendly: true, case: :up)
  # "YTHJHTXKSSXTPLARALRH"

Use string format to create a random in the particular format.

  RandomToken.gen("Give me a token %8?")
  # "Give me a token 6HRQZp8O"

Please see "README" to get more details.
  EOF
  spec.homepage      = "https://github.com/sibevin/random_token"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
