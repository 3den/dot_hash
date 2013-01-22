require File.expand_path("../../test_helper", __FILE__)

module DotHash
  describe Properties do
    attr_reader :settings

    describe "#method_missing" do
      describe "with a simple hash" do
        before do
          @settings = Properties.new speed: "15", "power" => 100
        end

        it "gets a hash property using the dot notation" do
          settings.speed.must_equal "15"
        end

        it "raises an error if the method is not on the hash" do
          -> {settings.name}.must_raise NoMethodError
        end

        it "gets a property from a stringed key" do
          settings.power.must_equal 100
        end
      end

      describe "with a nested hash" do
        before do
          @settings = Properties.new user: {
            "info" => {name: "dude", is_admin: false}
          }
        end

        it "returns a DotHash instence for property with a nested hash" do
          settings.user.must_be_instance_of DotHash::Properties
        end

        it "gets chained properties" do
          settings.user.info.name.must_equal "dude"
          settings.user.info.is_admin.must_equal false
        end
      end

      describe "#[]" do
        before do
          @settings = Properties.new user: { name: "dude" }
        end

        it "accesses properties like a symbol hash" do
          settings[:user][:name].must_equal "dude"
        end

        it "accesses properties like a string hash" do
          settings["user"]["name"].must_equal "dude"
        end
      end
    end

    describe "#respond_to?" do
      before do
        @settings = Properties.new speed: "15",
          info: {name: "Eden"},
          "color" => "#00FFBB"
      end

      it "responds to a simple property" do
        settings.must_respond_to :speed
      end

      it "responds to a nested property" do
        settings.info.must_respond_to :name
      end

      it "respond to a string property" do
        settings.must_respond_to :color
      end

      it "doesn't respond to a missing property" do
        settings.wont_respond_to :size
      end
    end

  end
end
