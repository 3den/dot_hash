require_relative "../test_helper"

module DotHash
  describe Properties do
    attr_reader :properties

    describe "#method_missing" do
      describe "with a simple hash" do
        before do
          @properties = Properties.new speed: "15", "power" => 100
        end

        it "gets a hash property using the dot notation" do
          assert_equal properties[:speed], "15"
          assert_equal properties['speed'], "15"
          assert_equal properties.speed, "15"
        end

        it "raises an error if the method is not on the hash" do
          -> {
            properties.name
          }.must_raise NoMethodError, "undefined method `name' for {:speed=>\"15\", \"power\"=>100}:DotHash::Properties"
        end

        it "gets a property from a stringed key" do
          assert_equal properties.power, 100
        end

        it "gets all values from a given property" do
          assert_equal properties.values, ["15", 100]
        end

        it "responds to a block method" do
          assert_equal properties.map { |k, v| [k, v] }, [[:speed, "15"], ["power", 100]]
        end
      end

      describe "with a nested hash" do
        before do
          @properties = Properties.new user: {
            "info" => {name: "dude", is_admin: false, favorite_thing: nil}
          }
        end

        it "returns a DotHash instence for property with a nested hash" do
          properties.user.must_be_instance_of DotHash::Properties
        end

        it "gets chained properties" do
          assert_equal properties.user.info.name, "dude"
          assert_equal properties.user.info.is_admin, false
        end

        it 'preserves nil-value nodes' do
          assert_nil properties.user.info.favorite_thing
        end
      end

      describe 'method delegation' do
        before do
          @properties = Properties.new({
            ninja: {name: 'Naruto'}
          })
        end

        it '#map sets inner-hashes to Properties' do
          skip
          result = properties.map { |k, v| "#{k}: #{v.name}" }

          assert_equal result, ['ninja: Naruto']
        end

        it '#each_with_object goes nested on block args' do
          skip
          result = properties.each_with_object({}) do |(k, v), acc|
            acc[k] = v.name
          end

          assert_equal result, Properties.new({ninja: 'Naruto'})
        end
      end
    end

    describe '#==' do
      before do
        @properties = Properties.new({
          ninja: {name: 'Naruto'}
        })
      end

      it 'is equal to it self' do
        assert_equal properties, properties
      end

      it 'is equal to its hash' do
        assert_equal properties, {ninja: {name: 'Naruto'}}
      end

      it 'is equal to its copy' do
        assert_equal properties, Properties.new(properties.to_hash)
      end
    end

    describe "#[]" do
      before do
        @properties = Properties.new user: { name: "dude" }
      end

      it "accesses properties like a symbol hash" do
        assert_equal properties[:user][:name], "dude"
      end

      it "accesses properties like a string hash" do
        assert_equal properties["user"]["name"], "dude"
      end

      it 'returns nil when value not present' do
        assert_nil properties['missing']
      end
    end

    describe "#to_hash" do
      before do
        @properties = Properties.new user: { name: "dude" }
      end

      it "returns a hash" do
        assert_equal properties.to_hash, user: {name: "dude"}
      end
    end

    describe "#to_json" do
      before do
        @properties = Properties.new user: { name: "dude" }
      end

      it "returns a hash" do
        assert_equal properties.to_json, '{"user":{"name":"dude"}}'
      end
    end

    describe "#to_s" do
      attr_reader :hash

      before do
        @hash = { user: {name: "dude"} }
        @properties = Properties.new @hash
      end

      it "returns the hash as a string" do
        assert_equal properties.to_s, hash.to_s
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

    describe '#method' do
      before do
        @properties = Properties.new speed: "100",
          info: {name: "Eden"},
          "color" => "#00FFBB"
      end

      it 'has a capturable method for a simple property' do
        assert_equal @properties.method(:speed).call, "100"
      end

      it 'has a capturable method for a nested property' do
        assert_equal @properties.info.method(:name).call, "Eden"
        assert_equal @properties.method(:info).call.name, "Eden"
      end

      it 'has a capturable method for a string property' do
        assert_equal @properties.method(:color).call, "#00FFBB"
      end

      it 'does not have a capturable method for a missing property' do
        lambda do
          @properties.method(:power)
        end.must_raise(NameError)
      end

      it 'has a capturable method for public hash methods' do
        @properties.method(:keys).must_be_kind_of Method
      end

      it 'has a capturable method for public methods' do
        hash_method = @properties.method(:to_hash)
        hash_method.must_be_kind_of Method
        # not Object#hash or Properties#hash#hash
        hash_method.call.wont_be_kind_of Numeric
      end
    end
  end
end
