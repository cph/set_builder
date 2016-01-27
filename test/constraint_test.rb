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



  context "A constraint" do
    should "be invalid if it is missing a direct object" do
      trait = Trait.new('who "attended" :school')
      constraint = trait.apply({})
      assert_match /school is blank/, constraint.errors.join
    end

    should "be invalid if it is missing an enumeration" do
      trait = Trait.new('who [is|is not] "awesome"')
      constraint = trait.apply({})
      assert_match /should have values for 1 enums/, constraint.errors.join
    end

    should "be invalid if it supplies an unexpected value for an enumeration" do
      trait = Trait.new('who [is|is not] "awesome"')
      constraint = trait.apply(enums: ["is totally"])
      assert_match /should be 'is' or 'is not'/, constraint.errors.join
    end

    should "be invalid if it supplies an unexpected value for a modifier's operator" do
      trait = Trait.new('whose "name" <string>')
      constraint = trait.apply(modifiers: [{ operator: "starts_with", values: ["Jer"] }])
      assert_match /should be :contains, :does_not_contain, :begins_with, :does_not_begin_with, :ends_with, :does_not_end_with, :is, or :is_not/, constraint.errors.join
    end
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

    should "interpolate enums" do
      trait = Trait.new('who [was|was not] "born" in [Russia|Ukraine]')
      assert_equal "who was born in Ukraine", trait.apply({enums: ["was", "Ukraine"] }).to_s
    end
  end


end
