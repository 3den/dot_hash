require_relative "../test_helper"

describe Hash do
  attr_reader :properties

  describe "#to_propertires" do
    before do
      @properties = {
        "price" => 10, info: {name: "eagle"}
      }.to_properties
    end

    it "returns a DotHash object" do
      properties.must_be_instance_of DotHash::Properties
    end

    it "gets nested properties" do
      properties.info.name.must_equal "eagle"
    end

    it "gets simple properties" do
      properties.price.must_equal 10
    end
  end
end
