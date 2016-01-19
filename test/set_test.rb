require "test_helper"

class SetTest < ActiveSupport::TestCase



  test "set data struture" do
    set = to_set [
      { trait: :awesome },
      { trait: :attended, school: 2 },
      { trait: :died },
      { trait: :name, modifiers: [{ operator: :is, values: ["Jerome"] }] }]
    assert set.valid?
    assert_equal "who are  awesome, who have  attended McKendree, who  died, and whose name is Jerome", set.to_s
  end

  test "parsing sets that come from HTML" do
    set = to_set({
      "0" => { "trait" => "awesome" },
      "1" => { "trait" => "attended", "school" => 2 },
      "2" => { "trait" => "died" },
      "3" => { "trait" => "name", "modifiers" => {"0" => { "operator" => "is", "values" => {"0" => "Jerome"} }} } })
    assert set.valid?
    assert_equal "who are  awesome, who have  attended McKendree, who  died, and whose name is Jerome", set.to_s
  end

  test "normalizing sets" do
    expected_constraints = [
      { trait: "awesome" },
      { trait: "attended", school: 2 },
      { trait: "died" },
      { trait: "name", modifiers: [{ operator: "is", values: ["Jerome"] }] }]
    set = to_set({
      "0" => { "trait" => "awesome" },
      "1" => { "trait" => "attended", "school" => 2 },
      "2" => { "trait" => "died" },
      "3" => { "trait" => "name", "modifiers" => {"0" => { "operator" => "is", "values" => {"0" => "Jerome"} }} } })
    assert_equal expected_constraints, set.to_a
  end

  test "normalize should handle nil" do
    assert_equal [], SetBuilder::Set.normalize(nil)
  end

  test "sets with invalid modifiers should be invalid" do
    set = to_set [{ trait: :born, modifiers: [{ operator: :after, values: ["wrong"] }] }]
    assert_equal false, set.valid?
  end

  test "sets should not allow non-numbers in a number modifiers" do
    set = to_set [{ trait: :age, modifiers: [{ operator: :is, values: ["12a"] }] }]
    refute set.valid?
    assert_match /"12a" is not a valid number/, set.errors.values.join(", ")
  end

  test "sets should not allow empty string in a number modifiers" do
    set = to_set [{ trait: :age, modifiers: [{ operator: :is, values: [""] }] }]
    refute set.valid?
    assert_match /number is blank/, set.errors.values.join(", ")
  end

  test "sets lacking expected modifiers should be invalid" do
    set = to_set [{ trait: :born, modifiers: [{ operator: :ever, values: [] }] }]
    assert_equal true, set.valid?

    set = to_set [{ trait: :born }]
    assert_equal false, set.valid?
  end

  test "set structure with negations (nouns are ignored)" do
    set = to_set [
      { trait: "awesome", negative: true },
      { trait: "attended", negative: true, school: 2 },
      { trait: "died", negative: true },
      { trait: "name", negative: true, modifiers: [{ operator: :is, values: ["Jerome"] }] }]
    assert set.valid?
    assert_equal "who are not awesome, who have not attended McKendree, who have not died, and whose name is Jerome", set.to_s
  end

  test "simple perform" do
    set = to_set [{ trait: :awesome }]

    expected_results = [{:conditions => {:awesome => true}}]
    assert_equal expected_results, set.perform
  end

  test "complex perform" do
    set = to_set [
      { trait: "awesome" },
      { trait: "attended", school: 1 },
      { trait: "died" },
      { trait: "name", modifiers: [{ operator: :begins_with, values: ["Jer"] }] }]

    expected_results = [
      {:conditions => {:awesome => true}},
      {:joins => "INNER JOIN schools ON friends.school_id=schools.id", :conditions => {"schools.id" => 1}},
      {:conditions => {:alive => false}},
      {:conditions => "\"friends\".\"name\" LIKE 'Jer%'"}
    ]
    assert_equal expected_results, set.perform
  end

  test "invalid set" do
    # starts_with is not a valid operator
    set = to_set [{ trait: :name, modifiers: [{ operator: :starts_with, values: ["Jerome"] }] }]

    # !todo: what to do?
    skip "TODO: test invalid sets"
  end


private

  def to_set(data)
    SetBuilder::Set.new($friend_traits, Friend.all, data)
  end

end
