require 'test_helper'

class TraitsTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers


  test "traits" do
    expected_traits = %w{attended awesome born died name}
    assert_equal expected_traits, Friend.traits.collect(&:name).sort
  end
  
  test "traits' accessor" do
    traits = Friend.traits
    assert_kind_of SetBuilder::Traits, traits
    assert_equal "awesome", traits[0].name, "Array getter should still work like normal"
    assert_kind_of SetBuilder::Trait, traits[:born], "If you pass a string or symbol Traits should lookup a trait by name"
  end
  
  test "trait method is protected" do
    assert_raises NoMethodError, "this method is for use within class definition" do
      Friend.trait
    end
  end
  
  test "collection of modifiers" do
    expected_modifiers = %w{DateModifier StringModifier}.collect {|name| "SetBuilder::Modifiers::#{name}"}
    assert_equal expected_modifiers, Friend.traits.modifiers.collect(&:name).sort
  end
  
  test "to_json" do
    expected_json = [['awesome', 'reflexive'],
                     ['died', 'active'],
                     ['born', 'passive', ['date']],
                     [['attended', 'string'], 'perfect'],
                     ['name', 'noun', ['string']]].to_json
    assert_equal expected_json, Friend.traits.to_json
  end


end
