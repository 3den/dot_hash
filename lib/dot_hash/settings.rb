module DotHash
  class Settings < Properties
    def initialize(*args)
      super Loader.new(*args).hash
    end

    def load(*args)
      @cached = {}
      @hash = Loader.new(hash, *args).hash
    end

    class << self
      def method_missing(*args, &block)
        instance.public_send(*args, &block)
      end

      def respond_to_missing?(*args)
        instance.respond_to?(*args)
      end

      def load(*args)
        instance.load(*args)
      end

      private

      def instance
        @instance ||= new({})
      end
    end
  end
end
