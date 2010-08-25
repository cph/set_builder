require 'test_helper'

class TraitTest < ActiveSupport::TestCase


  test "constraints find correct modifiers" do
    trait = Friend.traits[:name]
    assert_equal 1, trait.modifiers.length

    constraint = trait.apply({:is => "Jerome"})
    assert_equal 1, constraint.modifiers.length
    assert_kind_of SetBuilder::Constraint::Modifier::StringModifier, constraint.modifiers.first
  end
  
  test "modifiers should find correct values" do
    trait = Friend.traits[:name]
    modifier = trait.apply({:is => "Jerome"}).modifiers.first
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
      assert_equal expected_value, Friend.traits[trait].requires_direct_object?
    end
  end
  
  test "constraint should be valid" do
    trait = Friend.traits[:name]
    constraint = trait.apply({:is => "Jerome"})
    assert constraint.valid?
  end


end
