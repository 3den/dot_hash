
# DotHash
[![Build Status](https://travis-ci.org/3den/dot_hash.png?branch=master)](https://travis-ci.org/3den/dot_hash)

A very efficient gem that lets you use hashes as object properties. It is almost as fast as a plain Hash 
since it's complexity is also linear, `O(n) # where N is the number of nested parents of the given property`.

## Installation

Add this line to your application's Gemfile:

    gem 'dot_hash'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dot_hash

## Usage

```ruby
some_hash = {size: {height: 100, width: 500}, "color" => "red"}
properties = some_hash.to_properties

properties.size.height # returns 100, it is the same as some_hash[:size][:height]
properties.color       # returns "red", it works with Strings and Symbol keys
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
