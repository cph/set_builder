require 'test_helper'

class TraitsTest < ActiveSupport::TestCase


  test "traits" do
    expected_traits = %w{awesome born attended died name}
    assert_equal expected_traits, Friend.traits.collect(&:name)
  end
  
  test "traits' accessor" do
    traits = Friend.traits
    assert_kind_of SetBuilder::Traits, traits
    assert_equal "awesome", traits[0].name, "Array getter should still work like normal"
    assert_kind_of SetBuilder::Trait::Base, traits[:born], "If you pass a string or symbol Traits should lookup a trait by name"
  end
  
  test "trait method is protected" do
    assert_raises NoMethodError, "this method is for use within class definition" do
      Friend.trait
    end
  end


end
