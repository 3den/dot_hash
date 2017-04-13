module DotHash
  class Properties
    attr_reader :hash
    alias_method :to_hash, :hash

    def initialize(hash)
      @hash = hash
    end

    def method_missing(key, *args, &block)
      if has_key?(key)
        execute(key, *args, &block)
      else
        super(key, *args, &block)
      end
    end

    def respond_to_missing?(key, *args)
      has_key?(key) or super(key, *args)
    end

    def ==(other)
      super(other) or other.to_hash == hash
    end

    def to_s
      hash.to_s
    end

    def to_json
      hash.to_json
    end

    def [](key)
      fetch(key, nil)
    end

    def fetch(key, *args, &block)
      key = hash.has_key?(key.to_s) ? key.to_s : key.to_sym
      value = hash.fetch(key, *args, &block)

      return value unless value.is_a?(Hash)
      hash[key] = self.class.new value
    end

    private

    def has_key?(key)
      hash.has_key?(key.to_s) or
        hash.has_key?(key.to_sym) or
        hash.respond_to?(key)
    end

    def execute(key, *args, &block)
      fetch(key) do
        hash.public_send(key, *args) do |*values|
          block.call(*hashify_args(values))
        end
      end
    end

    def hashify_args(args)
      args.each_with_index do |a, i|
        args[i] =
          case a
          when Hash then self.class.new(a)
          when Array then hashify_args(a)
          else a
          end
      end
    end
  end
end
