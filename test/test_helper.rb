require "minitest/autorun"
require File.expand_path("../../lib/dot_hash", __FILE__)
TESTS_PATH= File.dirname(__FILE__)

def fixtures_path file=nil
  "#{TESTS_PATH}/fixtures/#{file}"
end
