require 'test_helper'

class SetTest < ActiveSupport::TestCase
  
  
  
  test "set data struture" do
    data = [
      [:awesome],
      [:attended, 2],
      [:died],
      [:name, {:is => "Jerome"}]]
    set = Friend.that_belong_to(data)
    assert set.valid?
    assert_equal "who are awesome, who have attended McKendree, who died, and whose name is Jerome", set.to_s
  end

  test "sets with invalid modifiers should be invalid" do
    data = [[:born, {:after => ["wrong"]}]]
    set = Friend.that_belong_to(data)
    assert_equal false, set.valid?
  end

  test "sets should not allow non-numbers in a number modifiers" do
    data = [[:age, {:is => ["12a"]}]]
    set = Friend.that_belong_to(data)
    refute set.valid?
  end

  test "sets should not allow empty string in a number modifiers" do
    data = [[:age, {:is => [""]}]]
    set = Friend.that_belong_to(data)
    refute set.valid?
  end
  
  test "sets lacking expected modifiers should be invalid" do
    data = [[:born, {:ever => []}]]
    set = Friend.that_belong_to(data)
    assert_equal true, set.valid?
    
    data = [[:born]]
    set = Friend.that_belong_to(data)
    assert_equal false, set.valid?
  end  
  
  test "set structure with negations (nouns are ignored)" do
    data = [
      ["!awesome"],
      ["!attended", 2],
      ["!died"],
      ["!name", {:is => "Jerome"}]]
    set = Friend.that_belong_to(data)
    assert set.valid?
    assert_equal "who are not awesome, who have not attended McKendree, who have not died, and whose name is Jerome", set.to_s
  end
  
  test "simple perform" do
    data = [[:awesome]]
    set = Friend.that_belong_to(data)
    
    expected_results = [{:conditions => {:awesome => true}}]
    assert_equal expected_results, set.perform
  end
  
  test "complex perform" do
    data = [
      [:awesome],
      [:attended, 1],
      [:died],
      [:name, {:begins_with => "Jerome"}]]
    set = Friend.that_belong_to(data)
    
    expected_results = [
      {:conditions => {:awesome => true}},
      {:joins => "INNER JOIN schools ON friends.school_id=schools.id", :conditions => {"schools.id" => 1}},
      {:conditions => {:alive => false}},
      {:conditions => ["friends.name LIKE ?", "Jerome%"]}
    ]
    assert_equal expected_results, set.perform
  end
  
  test "invalid set" do
    data = [[:name, {:starts_with => "Jerome"}]]  # starts_with is not a valid operator
    set = Friend.that_belong_to(data)
    
    # !todo: what to do?
  end


end
