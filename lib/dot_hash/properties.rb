module DotHash
  class Properties
    attr_reader :hash
    alias_method :to_hash, :hash

    def initialize(hash)
      @hash = hash
    end

    def method_missing(key, *args, &block)
      symbolize_key key
      has_key?(key) ?
        execute(key, *args, &block) :
        super(key, *args, &block)
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

    def execute(key, *args, &block)
      value = get_value(key)
      return value unless value.nil?
      hash.public_send(key, *args, &block)
    end

    def get_value(key)
      key = key.to_sym
      value = hash[key]
      return value unless value.is_a?(Hash)
      hash[key] = self.class.new value
    end

    def symbolize_key(key)
      return unless hash.has_key?(key.to_s)
      hash[key.to_sym] = hash.delete key.to_s
    end
  end
end
