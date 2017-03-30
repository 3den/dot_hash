require_relative "../test_helper"

module DotHash
  describe Settings do
    attr_reader :settings

    describe "#method_missing" do
      before do
        configs = {site: "skyo.com", facebook: {api: "123"}}
        @settings = Settings.new configs
      end

      it "gets hash properties" do
        assert_equal settings.site, "skyo.com"
        assert_equal settings[:site], "skyo.com"
      end

      it "gets a nested hash property" do
        assert_equal settings.facebook.api, "123"
        assert_equal settings['facebook']['api'], "123"
      end
    end

    describe "#respond_to?" do
      before do
        configs = {site: "skyo.com"}
        @settings = Settings.new configs
      end

      it "responds to a property on the configs" do
        settings.must_respond_to :site
        settings.must_respond_to :hash
        settings.must_respond_to :to_s
      end

      it "does not responds to crasy stuff" do
        settings.wont_respond_to :foobar
      end
    end

    describe ".instance" do
      before do
        configs = {site: "skyo.com"}
        Settings.load configs
      end

      it "returns a singleton instance of the settings" do
        Settings.instance.must_be_instance_of Settings
      end
    end

    describe ".method_missing" do
      before do
        configs = {site: "skyo.com"}
        Settings.load configs
      end

      it "gets hash properties" do
        assert_equal Settings.site, "skyo.com"
        assert_equal Settings['site'], "skyo.com"
      end
    end

    describe ".respond_to?" do
      before do
        configs = {site: "skyo.com"}
        Settings.load configs
      end

      it "responds to a property on the configs" do
        Settings.must_respond_to :site
      end
    end

    describe ".load" do
      describe "loading from hashes" do
        before do
          Settings.load({a: 1, b: {c: 2}}, {b: {x: {z: 10}}})
        end

        it "adds new properties to the previous hash" do
          assert_equal Settings.b.x.z, 10
        end

        it "keeps non-changed properties untouched" do
          assert_equal Settings.a, 1
        end

        it "merges nested hashes correctly" do
          assert_equal Settings.b.c, 2
        end
      end

      describe "loading from files" do
        it "loads from a file" do
          Settings.load fixtures_path("configs1.yaml")
          assert_equal Settings.rogue.attr.speed, 20
          assert_equal Settings.rogue.attr.power, 11
        end

        it "loads from two files" do
          Settings.load(
            fixtures_path("configs1.yaml"),
            fixtures_path("configs2.yaml")
          )

          assert_equal Settings.rogue.attr.speed, 25
          assert_equal Settings.rogue.attr.power, 11
        end

        it "does not load files without the yaml extension" do
          Settings.load fixtures_path("config.yaml.example")

          -> { Settings.alive }.must_raise NoMethodError
        end

        it "loads from a directory" do
          Settings.load fixtures_path
          assert_equal Settings.rogue.attr.speed, 25
          assert_equal Settings.rogue.attr.power, 11
        end
      end
    end
  end
end
