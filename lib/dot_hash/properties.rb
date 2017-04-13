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
      super(other) ||
        (other.respond_to?(:to_hash) && other.to_hash == hash)
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

      if value.nil? or hash.respond_to?(key)
        hashify_item value
      elsif cached.has_key?(key)
        value
      else
        cached[key] = true
        hash[key] = hashify_item(value)
      end
    end

    def has_key?(key)
      hash.has_key?(key.to_s) or
        hash.has_key?(key.to_sym) or
        hash.respond_to?(key)
    end

    private

    def cached
      @cached ||= self.class.new({})
    end

    def execute(key, *args, &block)
      fetch(key) do
        if block
          hash.public_send(key, *args) do |*values|
            block.call(*hashify_list(values))
          end
        else
          hash.public_send(key, *args)
        end
      end
    end

    def hashify_list(args)
      args.each_with_index do |a, i|
        args[i] = hashify_item(a)
      end
    end

    def hashify_item(item)
      case item
      when Hash then self.class.new(item)
      when Array then hashify_list(item)
      else item
      end
    end
  end
end
