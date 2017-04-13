module DotHash
  class Settings < Properties
    def initialize(*args)
      super Loader.new(*args).hash
    end

    def load(*args)
      merge! Loader.new(self, *args).hash
    end

    class << self
      [
        :method_missing,
        :respond_to_missing?,
        :[],
        :key?,
        :load,
        :to_hash
      ].each do |m|
        define_method(m) do |*args|
          instance.send(m, *args)
        end
      end

      def instance
        @instance ||= new({})
      end
    end
  end
end
