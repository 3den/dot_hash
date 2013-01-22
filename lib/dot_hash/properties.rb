module DotHash
  class Properties
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def method_missing(key)
      symbolize_key key
      has_key?(key) ? get_value(key) : super
    end

    def respond_to?(key, *args)
      symbolize_key key
      has_key?(key) or super(key, *args)
    end

    def [](key)
      symbolize_key key
      get_value(key)
    end

    private

    def has_key?(key)
      hash.has_key? key.to_sym
    end

    def get_value(key)
      key = key.to_sym
      value = hash[key]
      return value unless value.is_a? Hash

      hash[key] = self.class.new value
    end

    def symbolize_key(key)
      return unless hash.has_key?(key.to_s)
      hash[key.to_sym] = hash.delete key.to_s
    end
  end
end
