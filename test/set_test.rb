require 'test_helper'

class SetTest < ActiveSupport::TestCase


  test "set data struture" do
    data = [
      [:awesome],
      [:attended, "school"],
      [:died],
      [:name, {:is => "Jerome"}]]
    set = SetBuilder::Set.new(Friend, data)
    assert set.valid?
    assert_equal "who are awesome, who have attended school, who died, and whose name is Jerome", set.to_s
  end
  
  test "simple perform" do
    data = [[:awesome]]
    set = SetBuilder::Set.new(Friend, data)

    expected_results = [[{:conditions => {:awesome => true}}]]
    Friend.reset_composed_scope
    assert_equal expected_results, set.perform.composed_scope
  end
  
  test "complex perform" do
    data = [
      [:awesome],
      [:attended, "Concordia"],
      [:died],
      [:name, {:is => "Jerome"}]]
    set = SetBuilder::Set.new(Friend, data)    
    
    expected_results = [
      [{:conditions => {:awesome => true}}],
      [{:joins => "INNER JOIN schools ON friends.school_id=schools.id", :conditions => {"schools.name" => "Concordia"}}],
      [{:conditions => {:alive => false}}],
      [{:conditions => "friends.name='Jerome'"}]
    ]
    Friend.reset_composed_scope
    assert_equal expected_results, set.perform.composed_scope
  end


end
