require 'test_helper'

class SetTest < ActiveSupport::TestCase



  test "set data struture" do
    set = to_set [
      [:awesome],
      [:attended, 2],
      [:died],
      [:name, {:is => "Jerome"}]]
    assert set.valid?
    assert_equal "who are awesome, who have attended McKendree, who died, and whose name is Jerome", set.to_s
  end

  test "sets with invalid modifiers should be invalid" do
    set = to_set [[:born, {:after => ["wrong"]}]]
    assert_equal false, set.valid?
  end

  test "sets should not allow non-numbers in a number modifiers" do
    set = to_set [[:age, {:is => ["12a"]}]]
    refute set.valid?
  end

  test "sets should not allow empty string in a number modifiers" do
    set = to_set [[:age, {:is => [""]}]]
    refute set.valid?
  end

  test "sets lacking expected modifiers should be invalid" do
    set = to_set [[:born, {:ever => []}]]
    assert_equal true, set.valid?

    set = to_set [[:born]]
    assert_equal false, set.valid?
  end

  test "set structure with negations (nouns are ignored)" do
    set = to_set [
      ["!awesome"],
      ["!attended", 2],
      ["!died"],
      ["!name", {:is => "Jerome"}]]
    assert set.valid?
    assert_equal "who are not awesome, who have not attended McKendree, who have not died, and whose name is Jerome", set.to_s
  end

  test "simple perform" do
    set = to_set [[:awesome]]

    expected_results = [{:conditions => {:awesome => true}}]
    assert_equal expected_results, set.perform
  end

  test "complex perform" do
    set = to_set [
      [:awesome],
      [:attended, 1],
      [:died],
      [:name, {:begins_with => "Jerome"}]]

    expected_results = [
      {:conditions => {:awesome => true}},
      {:joins => "INNER JOIN schools ON friends.school_id=schools.id", :conditions => {"schools.id" => 1}},
      {:conditions => {:alive => false}},
      {:conditions => ["friends.name LIKE ?", "Jerome%"]}
    ]
    assert_equal expected_results, set.perform
  end

  test "invalid set" do
    set = to_set [[:name, {:starts_with => "Jerome"}]]  # starts_with is not a valid operator

    # !todo: what to do?
    skip "TODO: test invalid sets"
  end


private

  def to_set(data)
    SetBuilder::Set.new($friend_traits, Friend.all, data)
  end

end
