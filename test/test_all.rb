require 'coveralls'
Coveralls.wear!

require "test/unit"

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require "test_helper"
require "random_token"
require "test_gen"
require "test_get"
require "test_strf"
