module DotHash
  class Settings
    attr_reader :configs

    def initialize(configs, wrapper=Properties)
      @configs = wrapper.new(configs)
    end

    def method_missing(key, *args, &block)
      configs.send(key, *args, &block)
    end

    def respond_to?(key)
      configs.respond_to?(key)
    end

    class << self
      attr_reader :instance

      def method_missing(key, *args, &block)
        instance.public_send key, *args, &block
      end

      def respond_to?(key)
        super(key) || instance.respond_to?(key)
      end

      def load(*args)
        @instance = new Loader.new(*args).load
      end

      def namespace(namespace)
        @instance = @instance[namespace]
      end
    end
  end
end
