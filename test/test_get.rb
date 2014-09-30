gem "minitest"
require "minitest/autorun"

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require "test_helper"
require "random_token"
require "get/test_length"
require "get/test_case"
require "get/test_friendly"
require "get/test_seed"
require "get/test_mask"
require "get/test_hash_seed"
