require "test_helper"

class TraitsTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers


  test "traits" do
    expected_traits = %w{age attended awesome born died name}
    assert_equal expected_traits, $friend_traits.collect(&:name).sort
  end

  test "traits' accessor" do
    traits = $friend_traits
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
    expected_modifiers = %w{DatePreposition NumberPreposition StringPreposition}.collect {|name| "SetBuilder::Modifiers::#{name}"}
    assert_equal expected_modifiers, $friend_traits.modifiers.collect(&:name).sort
  end

  test "two collections of traits can be concatenated with `+`" do
    traits1 = SetBuilder::Traits.new do
      trait('who are [not] "awesome"') { |query, scope| }
    end

    traits2 = SetBuilder::Traits.new do
      trait('who are [not] "living"') { |query, scope| }
    end

    combined_traits = traits1 + traits2
    assert_kind_of SetBuilder::Traits, combined_traits
    assert_equal %w{awesome living}, combined_traits.map(&:name)
  end

  test "two collections of traits can be concatenated with `concat`" do
    traits1 = SetBuilder::Traits.new do
      trait('who are [not] "awesome"') { |query, scope| }
    end

    traits2 = SetBuilder::Traits.new do
      trait('who are [not] "living"') { |query, scope| }
    end

    combined_traits = traits1.concat traits2
    assert_kind_of SetBuilder::Traits, combined_traits
    assert_equal %w{awesome living}, combined_traits.map(&:name)
  end

  test "to_json" do
    expected_json = [[["string","who are"],
      ["negative","not"],
      ["name","awesome"]],
     [["string","who"],
      ["negative","have not"],
      ["name","died"]],
     [["string","who were"],
      ["name","born"],
      ["modifier","date"]],
     [["string","whose"],
      ["name","age"],
      ["modifier","number"]],
     [["string","who have"],
      ["negative","not"],
      ["name","attended"],
      ["direct_object_type","school"]],
     [["string","whose"],
      ["name","name"],
      ["modifier","string"]]].to_json
    assert_equal expected_json, $friend_traits.to_json
  end


end
