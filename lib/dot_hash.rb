class DotHash
  VERSION = "0.0.1"
  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def method_missing(key)
    has_key?(key) ? get_key(key) : super
  end

  private

  def has_key?(key)
    hash.has_key?(key)
  end

  def get_key(key)
    hash[key]
  end

end
