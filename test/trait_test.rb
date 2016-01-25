require "test_helper"

class TraitTest < ActiveSupport::TestCase
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

  test "traits correctly expect direct objects" do
    trait_requires_direct_object = {
      :awesome => false,
      :born => false,
      :attended => true,
      :died => false,
      :name => false
    }
    trait_requires_direct_object.each do |trait, expected_value|
      assert_equal expected_value, $friend_traits[trait].requires_direct_object?
    end
  end

  test "traits correctly allow negation" do
    trait_is_negatable = {
      :awesome => true,
      :born => false,
      :attended => true,
      :died => true,
      :name => false
    }
    trait_is_negatable.each do |trait, expected_value|
      assert_equal expected_value, $friend_traits[trait].negatable?
    end
  end

  test "constraint should be valid" do
    trait = $friend_traits[:name]
    constraint = trait.apply({modifiers: [{ operator: :is, values: ["Jerome"] }]})
    assert constraint.valid?
  end


end
