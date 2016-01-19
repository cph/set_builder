require "test_helper"

class ConstraintTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers

  test "constraints find correct modifiers" do
    trait = $friend_traits[:name]
    assert_equal 1, trait.modifiers.length

    constraint = trait.apply({modifiers: [{ operator: :is, values: ["Jerome"] }]})
    assert_equal 1, constraint.modifiers.length
    assert_kind_of StringPreposition, constraint.modifiers.first
  end

  test "modifiers should find correct values" do
    trait = $friend_traits[:name]
    constraint = trait.apply({modifiers: [{ operator: :is, values: ["Jerome"] }]})
    modifier = constraint.modifiers.first
    assert_equal :is, modifier.operator
    assert_equal ["Jerome"], modifier.values
  end

  test "constraint should be valid" do
    trait = $friend_traits[:name]
    constraint = trait.apply({modifiers: [{ operator: :is, values: ["Jerome"] }]})
    assert constraint.valid?
  end

end
