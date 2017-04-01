require_relative "../test_helper"

class CustomSettings < DotHash::Settings
  load(
    fixtures_path, # load from many sources and merges everything
    attributes: {power: 10, skills: ["fireball", "frost"]}
  )
end

describe CustomSettings do
  it "loads the all given settings" do
    assert_equal CustomSettings.to_hash, {
      "default"=>{"attr"=>{"speed"=>10, "power"=>11}},
      "rogue"=>{"attr"=>{"speed"=>25, "power"=>11}},
      "hero"=>{"name"=>"Eden", "power"=>100, "location"=> TESTS_PATH},
      :attributes=>{:power=>10, :skills=>["fireball", "frost"]}
    }
  end
end
