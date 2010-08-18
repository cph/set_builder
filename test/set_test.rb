require 'test_helper'

class SetTest < ActiveSupport::TestCase


  test "set data struture" do
    data = [
      [:awesome],
      [:attended, "school"],
      [:died, :not],
      [:name, {:is => "Jerome"}]]
    set = SetBuilder::Set.new(Friend, data)
    assert set.valid?
    assert_equal "who is awesome, who attended school, who has not died, and whose name is Jerome", set.to_s
  end


end
