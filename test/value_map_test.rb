require 'test_helper'

class ValueMapTest < ActiveSupport::TestCase


  test "value map can fetch what you supplied it" do
    expected_hash = {1 => "Concordia", 2 => "McKendree"}
    assert_equal expected_hash, SetBuilder::ValueMap.for(:school)
  end
  
  
  test "value map should fetch the correct value" do 
    expected_school = "Concordia"
    assert_equal expected_school, SetBuilder::ValueMap.to_s(:school, 1)
  end


  test "value map should fetch the correct value when passed as a string" do 
    expected_school = "Concordia"
    assert_equal expected_school, SetBuilder::ValueMap.to_s("school", 1)
  end
  
  
  test "value map should generate json that can be handed to the client-side SetBuilder" do
    expected_json = "{\"school\":{\"1\":\"Concordia\",\"2\":\"McKendree\"}}"
    assert_equal expected_json, SetBuilder::ValueMap.to_json
  end


end
