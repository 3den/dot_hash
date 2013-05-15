require_relative "../test_helper"

class CustomSettings < DotHash::Settings
  load attributes: {power: 10, skills: ["fireball", "frost"]}
end

describe CustomSettings do
  it "loads the given settings" do
    CustomSettings.attributes.power.must_equal 10
    CustomSettings.attributes.skills.must_equal ["fireball", "frost"]
  end
end


class CustomSettings2 < DotHash::Settings
  load attributes: {power: 10, name: "Eden", skills: ["fireball", "frost"]}
  namespace :attributes
end

describe CustomSettings2 do
  it "loads the settings within the namespace" do
    CustomSettings2.power.must_equal 10
    CustomSettings2.skills.must_equal ["fireball", "frost"]
  end
end
