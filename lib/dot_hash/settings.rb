module DotHash
  class Settings
    attr_reader :configs

    def initialize(configs, wrapper=Properties)
      @configs = Properties.new(configs)
    end

    def method_missing(key, *args)
      configs.send(key, *args)
    end

    def respond_to?(key)
      configs.respond_to?(key)
    end

    class << self
      attr_reader :instance

      def method_missing(key)
        instance.public_send key
      end

      def respond_to?(key)
        instance.respond_to?(key)
      end

      def load(*args)
        @instance = new hash_from(*args)
      end

      private

      def hash_from *args
        args.inject({}) do |hash, arg|
          merge_hashes hash, get_hash_from(arg)
        end
      end

      def get_hash_from arg
        if arg.is_a? Hash
          arg
        elsif File.file? arg
          get_hash_from_file arg
        elsif File.directory? arg
          get_hash_from_directory arg
        end
      end

      def get_hash_from_file(file)
        return {} unless file =~ /\.(yaml|yml)/
        YAML.load_file(file)
      end

      def get_hash_from_directory(directory)
        Dir["#{directory}/**/*"].inject({}) do |hash, file|
          merge_hashes hash, get_hash_from_file(file)
        end
      end

      def merge_hashes(h1, h2)
        return h1 unless h2
        return h2 unless h1

        h2.each do |key, value|
          h1[key] = value.is_a?(Hash) ?
            merge_hashes(h1[key], value) : value
        end

        h1
      end
    end
  end
end
