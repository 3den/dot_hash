require File.expand_path("../test_helper", __FILE__)

describe DotHash do
  attr_reader :settings

  describe "with a simple hash" do
    before do
      @settings = DotHash.new size: 10, speed: "15"
    end

    it "gets a hash property using the dot notation" do
      settings.speed.must_equal "15"
    end

    it "raises an error if the method is not on the hash" do
      -> {settings.name}.must_raise NoMethodError
    end
  end

  describe "with a nested hash" do

  end
end
