module DotHash
  class Loader
    attr_reader :hashes

    def initialize *hashes
      @hashes = hashes
    end

    def load
      hashes.inject({}) do |hash, arg|
        merge_hashes hash, get_hash_from(arg)
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

    private

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
      return {} unless file =~ /\.(yaml|yml)(\.erb)?$/
      YAML.load load_erb(file)
    end

    def load_erb(file)
      ERB.new(File.read(file)).result
    end

    def get_hash_from_directory(directory)
      Dir["#{directory}/**/*"].sort.inject({}) do |hash, file|
        merge_hashes hash, get_hash_from_file(file)
      end
    end
  end
end

