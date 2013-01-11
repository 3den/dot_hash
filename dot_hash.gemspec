# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'dot_hash/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Marcelo Eden"]
  gem.email         = ["edendroid@gmail.com"]
  gem.description   = %q{Access hash values using the dot notation}
  gem.summary       = %q{Converts hash.to_properties so you can access values using properties.some_key}
  gem.homepage      = "https://github.com/3den/dot_hash"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "dot_hash"
  gem.require_paths = ["lib"]
  gem.version       = DotHash::VERSION

  gem.add_development_dependency "rake"
end
