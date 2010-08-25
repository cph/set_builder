require 'test_helper'

class InflectorTest < ActiveSupport::TestCase


  test "active" do
    assert_equal "who died", SetBuilder::Trait.new("died", :active).to_s
  end
    
  test "perfect" do
    assert_equal "who have attended", SetBuilder::Trait.new("attended", :perfect).to_s
  end
    
  test "passive" do
    assert_equal "who were born", SetBuilder::Trait.new("born", :passive).to_s
  end
    
  test "reflexive" do
    assert_equal "who are awesome", SetBuilder::Trait.new("awesome", :reflexive).to_s
  end
    
  test "noun" do
    assert_equal "whose name", SetBuilder::Trait.new("name", :noun).to_s
  end
    

end