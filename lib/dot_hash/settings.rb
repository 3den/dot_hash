module DotHash
  class Settings < Properties
    def initialize(*args)
      super Loader.new(*args).load
    end

    class << self
      attr_reader :instance

      def method_missing(*args, &block)
        instance.public_send(*args, &block)
      end

      def respond_to_missing?(*args)
        instance.respond_to?(*args)
      end

      def load(*args)
        @instance = new(*args)
      end

      def namespace(namespace)
        @instance = @instance[namespace]
      end
    end
  end
end
