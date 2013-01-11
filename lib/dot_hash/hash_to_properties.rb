module DotHash
  module HashToProperties
    def to_properties
      Properties.new self
    end
  end
end

Hash.send :include, DotHash::HashToProperties
