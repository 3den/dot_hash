module DotHash
  class Properties
    attr_reader :hash
    alias_method :to_hash, :hash

    def initialize(hash)
      @hash = hash
    end

    def method_missing(key, *args, &block)
      symbolize_key key
      has_key?(key) ? get_value(key, *args, &block) : super
    end

    def respond_to?(key)
      symbolize_key key
      has_key?(key) or super(key)
    end

    def [](key)
      symbolize_key key
      get_value(key)
    end

    private

    def has_key?(key)
      hash.has_key?(key.to_sym) or hash.respond_to?(key)
    end

    def get_value(key, *args, &block)
      key = key.to_sym
      value = hash.fetch(key) { hash.send(key, *args, &block) }
      return value unless value.is_a?(Hash)
      hash[key] = self.class.new value
    end

    def symbolize_key(key)
      return unless hash.has_key?(key.to_s)
      hash[key.to_sym] = hash.delete key.to_s
    end
  end
end
