require 'test_helper'

class DateModifierTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers
  
  
  test "should constrain our date queries to A.D." do
    modifier = DateModifier.new({:in_the_last => [Date.today.year, "years"]})
    assert_equal "x>='0001-01-01'", modifier.build_conditions_for("x")
  end
  
  
end