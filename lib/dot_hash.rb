$:.push File.expand_path('../', __FILE__)

require 'yaml'
require 'json'
require 'erb'
require 'dot_hash/properties'
require 'dot_hash/loader'
require 'dot_hash/settings'
require 'dot_hash/version'

module DotHash
  class << self
    def load(*args)
      Loader.new(*args).properties
    end
  end
end
