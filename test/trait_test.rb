require "test_helper"

class TraitTest < ActiveSupport::TestCase
  include SetBuilder


  context "When defining a trait, it" do
    should "strip any leading or trailing whitespace" do
      assert_equal 'who "died"', Trait.new(' who "died" ').to_s
    end

    should "take the quoted part of the string as the trait name" do
      assert_equal "died", Trait.new('who "died"').name
    end

    should "not allow you to define more than one trait name" do
      assert_raise(ArgumentError) { Trait.new('who "died" "allegedly"') }
    end

    should "not required you to define a trait name" do
      assert_raise(ArgumentError) { Trait.new('who died') }
    end

    should "assume that it doesn't expect a direct object" do
      refute Trait.new('who "attended"').requires_direct_object?
    end

    should "take a word prefixed with ':' as the type of the direct object" do
      trait = Trait.new('who "attended" :school')
      assert_equal :school, trait.direct_object_type
      assert trait.requires_direct_object?
    end

    should "not allow you to define more than one direct object" do
      assert_raise(ArgumentError) { Trait.new('who "attended" :school :university') }
    end

    should "have no enums unless defined" do
      assert_equal 0, Trait.new('who "died"').enums.length
    end

    should "take bracketed text as a built-in set of alternatives" do
      trait = Trait.new('who [have|have not] "died"')
      assert_equal [["have", "have not"]], trait.enums
    end

    should "require you to define at least two alternatives" do
      assert_raise(ArgumentError) { Trait.new('who [have not] "died"') }
    end

    should "take words wrapped in angle brackets as modifiers" do
      trait = Trait.new('who were "born" <date>')
      assert_equal [Modifiers::DatePreposition], trait.modifiers
    end

    should "raise an exception if a modifier isn't defined" do
      assert_raise(ArgumentError) { Trait.new('who were "born" <nope>') }
    end
  end


end
