require_relative "../test_helper"

module DotHash
  describe Loader do
    describe "#hash" do
      it "merges the given hashes" do
        loader = Loader.new(
          {a: 1, b: {c: 2}},
          {b: {x: {z: 10}}}
        )
        assert_equal loader.hash, {a: 1, b: {c: 2, x: {z: 10}}}
      end

      it "loads from a file" do
        loader = Loader.new fixtures_path("configs1.yml")

        assert_equal loader.hash, {
          "default" => {"attr" => {"speed"=>10, "power"=>11}},
          "rogue" => {"attr" => {"speed"=>20, "power"=>11}}
        }
      end

      it "loads from two files" do
        loader = Loader.new(
          fixtures_path("configs1.yml"),
          fixtures_path("configs2.json")
        )

        assert_equal loader.hash,({
          "default"=>{"attr"=>{"speed"=>10, "power"=>11}},
          "rogue"=>{"attr"=>{"speed"=>25, "power"=>11}}
        })
      end

      it "does not hash files without the yaml extension" do
        loader = Loader.new fixtures_path("config.yaml.example")

        assert_equal loader.hash, {}
      end

      it "loads from a directory" do
        loader = Loader.new fixtures_path

        assert_equal loader.hash, {
          "default"=>{"attr"=>{"speed"=>10, "power"=>11}},
          "rogue"=>{"attr"=>{"speed"=>25, "power"=>11}},
          "hero"=>{"name"=>"Eden", "power"=>100, "location"=>TESTS_PATH}
        }
      end

      it "loads ERB files" do
        loader = Loader.new fixtures_path("configs3.yaml.erb")

        assert_equal loader.hash, {
          "hero"=>{"name"=>"Eden", "power"=>100, "location"=>TESTS_PATH}
        }
      end
    end
  end
end

