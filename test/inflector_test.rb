require 'test_helper'

class InflectorTest < ActiveSupport::TestCase


  test "active" do
    assert_equal "who died", SetBuilder::Trait.new('"died"').to_s
  end
    
  test "perfect" do
    assert_equal "who have attended", SetBuilder::Trait.new('have "attended"').to_s
  end
    
  test "passive" do
    assert_equal "who were born", SetBuilder::Trait.new('were "born"').to_s
  end
    
  test "reflexive" do
    assert_equal "who are awesome", SetBuilder::Trait.new('are "awesome"').to_s
  end
    
  test "noun" do
    assert_equal "whose name", SetBuilder::Trait.new('whose "name"').to_s
  end
    

end
