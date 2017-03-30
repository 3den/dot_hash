require_relative "../test_helper"

class CustomSettings < DotHash::Settings
  load attributes: {power: 10, skills: ["fireball", "frost"]}
end

describe CustomSettings do
  it "loads the given settings" do
    assert_equal CustomSettings.attributes.power, 10
    assert_equal CustomSettings.attributes.skills, ["fireball", "frost"]
  end
end

class CustomSettings2 < DotHash::Settings
  load attributes: {power: 10, name: "Eden", skills: ["fireball", "frost"]}
  namespace :attributes
end

describe CustomSettings2 do
  it "loads the settings within the namespace" do
    assert_equal CustomSettings2.power, 10
    assert_equal CustomSettings2.skills, ["fireball", "frost"]
  end
end
