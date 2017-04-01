# DotHash
[![Code Climate](https://codeclimate.com/github/3den/dot_hash.png)](https://codeclimate.com/github/3den/dot_hash) [![Build Status](https://travis-ci.org/3den/dot_hash.png?branch=master)](https://travis-ci.org/3den/dot_hash)

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

You can convert and hash to DotHash's properties.

```ruby
some_hash = {size: {height: 100, width: 500}, "color" => "red"}
properties = DotHash.load(some_hash)

properties.size.height # returns 100, it is the same as some_hash[:size][:height]
properties.color       # returns "red", it works with Strings and Symbol keys
properties[:color]     # returns "red", can be used like a hash with string keys
properties["color"]    # returns "red", can be used like a hash with symbol keys
```

You can use DotHash::Settings to manage all configs of your app it can load yml, json with or without ERB code embeded.

```ruby
# App Settings
class Settings < DotHash::Settings
  load(
    'path/to/some/settings.json',
    'path/to/settings-directory/',
    {something: 'Some Value'}
  )
end

# Use the settings as a Singleton
Settings.something
Settings.other.stuff.from_yml_settings

# Create a settings instance from some YML
swagger = Settings.new Rails.root.join('config', 'my-swagger.yml')
swagger.info.title # returns the title from swagger doc
```

DotHash supports Rails and is very easy to manage fancy settings with it.

```ruby
class Settings < DotHash::Settings
   load(
      Rails.root.join('config', 'settings.yml'), # loads config/settings.yml
      Rails.root.join('package.json'), # loads package.json
      *Dir(Rails.root.join('config', 'settings', '*.yml')), # loads all config/settings/*.yml but dont go to nested directories
      Rails.root.join('config', 'settings', Rails.env), # loads all files on config/settings/<env>/
      Rails.root.join('config', 'settings.local.yml') # loads config/settings.local.yml
   )
end
```

Check the tests for more details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/3den/dot_hash/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

