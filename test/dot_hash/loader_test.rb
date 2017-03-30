require_relative "../test_helper"

module DotHash
  describe Loader do

    describe "#load" do
      it "merges the given hashes" do
        loader = Loader.new(
          {a: 1, b: {c: 2}},
          {b: {x: {z: 10}}}
        )
        assert_equal loader.load,({a: 1, b: {c: 2, x: {z: 10}}})
      end

      it "loads from a file" do
        loader = Loader.new fixtures_path("configs1.yaml")

        assert_equal loader.load,({
          "default" => {"attr" => {"speed"=>10, "power"=>11}},
          "rogue" => {"attr" => {"speed"=>20, "power"=>11}}
        })
      end

      it "loads from two files" do
        loader = Loader.new(
          fixtures_path("configs1.yaml"),
          fixtures_path("configs2.yaml")
        )

        assert_equal loader.load,({
          "default"=>{"attr"=>{"speed"=>10, "power"=>11}},
          "rogue"=>{"attr"=>{"speed"=>25, "power"=>11}}
        })
      end

      it "does not load files without the yaml extension" do
        loader = Loader.new fixtures_path("config.yaml.example")

        assert_equal loader.load,({})
      end

      it "loads from a directory" do
        loader = Loader.new fixtures_path

        assert_equal loader.load,({
          "default"=>{"attr"=>{"speed"=>10, "power"=>11}},
          "rogue"=>{"attr"=>{"speed"=>25, "power"=>11}},
          "hero"=>{"name"=>"Eden", "power"=>100, "location"=>TESTS_PATH}
        })
      end

      it "loads ERB files" do
        loader = Loader.new fixtures_path("configs3.yaml.erb")

        assert_equal loader.load,({
          "hero"=>{"name"=>"Eden", "power"=>100, "location"=>TESTS_PATH}
        })
      end
    end
  end
end

