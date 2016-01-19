require "test_helper"

class TraitTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers

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

end
