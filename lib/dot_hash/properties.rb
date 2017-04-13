module DotHash
  class Properties < Hash
    def initialize(hash)
      super
      update(hash)
    end

    def method_missing(key, *args, &block)
      if key?(key)
        self[key]
      else
        super(key, *args, &block)
      end
    end

    def respond_to_missing?(key, *args)
      key?(key) or super(key, *args)
    end

    def [](key)
      fetch(key, nil)
    end

    def key?(key)
      has_key?(key.to_s) or has_key?(key.to_sym)
    end

    def fetch(key, *args, &fallback)
      key = has_key?(key.to_s) ? key.to_s : key.to_sym
      value = super(key, *args, &fallback)

      if value.is_a?(Hash) && !value.is_a?(Properties)
        self[key] = self.class.new(value)
      else
        value
      end
    end
  end
end
