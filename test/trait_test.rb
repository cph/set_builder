require 'test_helper'

class TraitTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers


  test "constraints find correct modifiers" do
    trait = Friend.traits[:name]
    assert_equal 1, trait.modifiers.length

    constraint = trait.apply({:is => "Jerome"})
    assert_equal 1, constraint.modifiers.length
    assert_kind_of StringPreposition, constraint.modifiers.first
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

  # test "traits whose direct objects support value mapping should be able to enumerate their values" do
  #   trait = Friend.traits[:attended]
  #   expected_map = {1 => "Concordia", 2 => "McKendree"}
  #   actual_map = trait.
  # end
  
  test "constraint should be valid" do
    trait = Friend.traits[:name]
    constraint = trait.apply({:is => "Jerome"})
    assert constraint.valid?
  end


end
