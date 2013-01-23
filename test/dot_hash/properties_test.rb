require File.expand_path("../../test_helper", __FILE__)

module DotHash
  describe Properties do
    attr_reader :properties

    describe "#method_missing" do
      describe "with a simple hash" do
        before do
          @properties = Properties.new speed: "15", "power" => 100
        end

        it "gets a hash property using the dot notation" do
          properties.speed.must_equal "15"
        end

        it "raises an error if the method is not on the hash" do
          -> {properties.name}.must_raise NoMethodError
        end

        it "gets a property from a stringed key" do
          properties.power.must_equal 100
        end

        it "gets all values from a given property" do
          properties.values.must_equal ["15", 100]
        end
      end

      describe "with a nested hash" do
        before do
          @properties = Properties.new user: {
            "info" => {name: "dude", is_admin: false}
          }
        end

        it "returns a DotHash instence for property with a nested hash" do
          properties.user.must_be_instance_of DotHash::Properties
        end

        it "gets chained properties" do
          properties.user.info.name.must_equal "dude"
          properties.user.info.is_admin.must_equal false
        end
      end

      describe "#[]" do
        before do
          @properties = Properties.new user: { name: "dude" }
        end

        it "accesses properties like a symbol hash" do
          properties[:user][:name].must_equal "dude"
        end

        it "accesses properties like a string hash" do
          properties["user"]["name"].must_equal "dude"
        end
      end
    end

    describe "#to_hash" do
      before do
        @properties = Properties.new user: { name: "dude" }
      end

      it "returns a hash" do
        properties.to_hash.must_equal user: {name: "dude"}
      end
    end

    describe "#respond_to?" do
      before do
        @properties = Properties.new speed: "15",
          info: {name: "Eden"},
          "color" => "#00FFBB"
      end

      it "responds to a simple property" do
        properties.must_respond_to :speed
      end

      it "responds to a nested property" do
        properties.info.must_respond_to :name
      end

      it "respond to a string property" do
        properties.must_respond_to :color
      end

      it "doesn't respond to a missing property" do
        properties.wont_respond_to :power
      end

      it "responds to public hash methods" do
        properties.must_respond_to :keys
      end
    end

  end
end
