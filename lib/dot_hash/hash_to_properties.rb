module DotHash
  module HashToProperties
    def to_properties
      Properties.new self
    end
  end
end

puts "TO PROPERTIES"
Hash.send :include, DotHash::HashToProperties
