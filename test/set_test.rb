require 'test_helper'

class SetTest < ActiveSupport::TestCase


  test "set data struture" do
    data = [
      [:awesome],
      [:attended, "school"],
      [:died],
      [:name, {:is => "Jerome"}]]
    set = Friend.that_belong_to(data)
    assert set.valid?
    assert_equal "who are awesome, who have attended school, who died, and whose name is Jerome", set.to_s
  end
  
  test "simple perform" do
    data = [[:awesome]]
    set = Friend.that_belong_to(data)

    expected_results = [[{:conditions => {:awesome => true}}]]
    Friend.reset_composed_scope
    assert_equal expected_results, set.perform.composed_scope
  end
  
  test "complex perform" do
    data = [
      [:awesome],
      [:attended, "Concordia"],
      [:died],
      [:name, {:begins_with => "Jerome"}]]
    set = Friend.that_belong_to(data)
    
    expected_results = [
      [{:conditions => {:awesome => true}}],
      [{:joins => "INNER JOIN schools ON friends.school_id=schools.id", :conditions => {"schools.name" => "Concordia"}}],
      [{:conditions => {:alive => false}}],
      [{:conditions => ["friends.name LIKE ?", "Jerome%"]}]
    ]
    Friend.reset_composed_scope
    assert_equal expected_results, set.perform.composed_scope
  end
  
  test "invalid set" do
    data = [[:name, {:starts_with => "Jerome"}]]  # starts_with is not a valid operator
    set = Friend.that_belong_to(data)
    
    # !todo: what to do?
  end


end
