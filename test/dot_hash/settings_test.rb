require File.expand_path("../../test_helper", __FILE__)

module DotHash
  describe Settings do
    attr_reader :settings

    describe "#method_missing" do
      before do
        configs = {site: "skyo.com", facebook: {api: "123"}}
        @settings = Settings.new configs
      end

      it "gets hash properties" do
        settings.site.must_equal "skyo.com"
        settings[:site].must_equal "skyo.com"
      end

      it "gets a nested hash property" do
        settings.facebook.api.must_equal "123"
        settings['facebook']['api'].must_equal "123"
      end
    end

    describe "#respond_to?" do
      before do
        configs = {site: "skyo.com"}
        @settings = Settings.new configs
      end

      it "responds to a property on the configs" do
        settings.must_respond_to :site
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
        Settings.site.must_equal "skyo.com"
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
          Settings.b.x.z.must_equal 10
        end

        it "keeps non-changed properties untouched" do
          Settings.a.must_equal 1
        end

        it "merges nested hashes correctly" do
          Settings.b.c.must_equal 2
        end
      end

      describe "loading from files" do
        it "loads from a file" do
          Settings.load fixtures_path("configs1.yaml")
          Settings.rogue.speed.must_equal 20
          Settings.rogue.power.must_equal 11
        end

        it "loads from two files" do
          Settings.load(
            fixtures_path("configs1.yaml"),
            fixtures_path("configs2.yaml")
          )

          Settings.rogue.speed.must_equal 25
          Settings.rogue.power.must_equal 11
        end

        it "loads from a directory" do
          Settings.load fixtures_path
          Settings.rogue.speed.must_equal 25
          Settings.rogue.power.must_equal 11
        end
      end
    end
  end
end
