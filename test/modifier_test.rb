require "test_helper"

class ModifierTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers



  test "should be valid if `values` is omitted for an operator that expects no arguments" do
    preposition = SetBuilder::Modifiers::DatePreposition.new(operator: "ever", values: [])
    assert_equal [], preposition.values
    assert preposition.valid?

    preposition = SetBuilder::Modifiers::DatePreposition.new(operator: "ever")
    assert_equal [], preposition.values
    assert preposition.valid?
  end

  test "should not flatten double-wrapped `values`" do
    preposition = SetBuilder::Modifiers::DatePreposition.new(operator: "on", values: [["2015-01-01"]])
    assert_equal [["2015-01-01"]], preposition.values
    assert preposition.valid?
  end

  test "should be valid if `values` is not wrapped in an array" do
    preposition = SetBuilder::Modifiers::DatePreposition.new(operator: "on", values: "2015-01-01")
    assert_equal ["2015-01-01"], preposition.values
    assert preposition.valid?
  end



  test "get type with string" do
    assert_equal StringPreposition, SetBuilder::Modifier["StringPreposition"]
  end

  test "get type with symbol" do
    assert_equal StringPreposition, SetBuilder::Modifier[:string]
  end

  test "registering a modifier" do
    assert_raises ArgumentError do
      SetBuilder::Modifier.for(:hash)
    end
    SetBuilder::Modifier.register(:hash, HashModifier)
    assert_nothing_raised ArgumentError do
      SetBuilder::Modifier.for(:hash)
    end
  end

  test "registering an invalid modifier" do
    assert_raises ArgumentError do
      SetBuilder::Modifier.register(:hash, InvalidHashModifier)
    end
  end

  test "converting modifier to json" do
    expected_results = {
      "contains"            => [["arg", "string"]],
      "does_not_contain"    => [["arg", "string"]],
      "begins_with"         => [["arg", "string"]],
      "does_not_begin_with" => [["arg", "string"]],
      "ends_with"           => [["arg", "string"]],
      "does_not_end_with"   => [["arg", "string"]],
      "is"                  => [["arg", "string"]],
      "is_not"              => [["arg", "string"]]
    }.to_json
    assert_equal expected_results, SetBuilder::Modifier.for(:string).to_json
  end

  test "converting modifiers to json" do
    expected_results = {
      "date" => {
        "ever"        => [],
        "before"      => [["arg", "date"]],
        "after"       => [["arg", "date"]],
        "on"          => [["arg", "date"]],
        "during_month"=> [["arg", "month"]],
        "during_year" => [["arg", "year"]],
        "in_the_last" => [["arg", "number"], ["string", " "], ["arg", "period"]],
        "between"     => [["arg", "date"], ["string", " and "], ["arg", "date"]]
      },
      "number" => {
        "is"=>[["arg", "number"]],
        "is_less_than"=>[["arg", "number"]],
        "is_greater_than"=>[["arg", "number"]],
        "is_between"=>[["arg", "number"], ["string", " and "], ["arg", "number"]]
      },
      "string" => {
        "contains"            => [["arg", "string"]],
        "does_not_contain"    => [["arg", "string"]],
        "begins_with"         => [["arg", "string"]],
        "does_not_begin_with" => [["arg", "string"]],
        "ends_with"           => [["arg", "string"]],
        "does_not_end_with"   => [["arg", "string"]],
        "is"                  => [["arg", "string"]],
        "is_not"              => [["arg", "string"]]
      }
    }
    assert_equal expected_results, $friend_traits.modifiers.to_hash
  end


end


class InvalidHashModifier
end

class HashModifier < SetBuilder::Modifier::Verb

  def self.operators
    [:has_key]
  end

end
