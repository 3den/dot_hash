require "minitest/autorun"
require_relative "../lib/dot_hash"

TESTS_PATH= File.dirname(__FILE__)

def fixtures_path file=nil
  "#{TESTS_PATH}/fixtures/#{file}"
end
