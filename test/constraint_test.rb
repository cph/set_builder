require "test_helper"

class ConstraintTest < ActiveSupport::TestCase
  include SetBuilder


  test "constraints find correct modifiers" do
    trait = $friend_traits[:name]
    assert_equal 1, trait.modifiers.length

    constraint = trait.apply({modifiers: [{ operator: :is, values: ["Jerome"] }]})
    assert_equal 1, constraint.modifiers.length
    assert_kind_of Modifiers::StringPreposition, constraint.modifiers.first
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


  context "#to_s" do
    should "carry over arbitrary text in the trait definition" do
      trait = Trait.new('who "died", tragically')
      assert_equal "who died, tragically", trait.apply({}).to_s
    end

    should "interpolate direct objects" do
      trait = Trait.new('who "attended" :school')
      assert_equal "who attended Concordia", trait.apply({school: 1}).to_s
    end

    should "interpolate modifiers" do
      trait = Trait.new('who was "born" <date>')
      assert_equal "who was born on 2016-01-01", trait.apply({
        modifiers: [{ operator: "on", values: ["2016-01-01"] }] }).to_s
    end
  end


end
