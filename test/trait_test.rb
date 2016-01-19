require "test_helper"

class TraitTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers


  context "When defining a trait, it" do
    should "take the quoted part of the string as the trait name" do
      assert_equal "died", SetBuilder::Trait.new('who "died"').name
    end

    should "not allow you to define more than one trait name" do
      assert_raise(ArgumentError) { SetBuilder::Trait.new('who "died" "allegedly"') }
    end

    should "not required you to define a trait name" do
      assert_raise(ArgumentError) { SetBuilder::Trait.new('who died') }
    end

    should "assume that it doesn't expect a direct object" do
      refute SetBuilder::Trait.new('who "attended"').requires_direct_object?
    end

    should "take a word prefixed with ':' as the type of the direct object" do
      trait = SetBuilder::Trait.new('who "attended" :school')
      assert_equal :school, trait.direct_object_type
      assert trait.requires_direct_object?
    end

    should "not allow you to define more than one direct object" do
      assert_raise(ArgumentError) { SetBuilder::Trait.new('who "attended" :school :university') }
    end

    should "assume that it is not negatable" do
      refute SetBuilder::Trait.new('who "died"').negatable?
    end

    should "take bracketed text as a phrase to be included if the trait is negated" do
      assert SetBuilder::Trait.new('who [have not] "died"').negatable?
    end

    should "take words wrapped in angle brackets as modifiers" do
      trait = SetBuilder::Trait.new('who were "born" <date>')
      assert_equal [SetBuilder::Modifiers::DatePreposition], trait.modifiers
    end

    should "raise an exception if a modifier isn't defined" do
      assert_raise(ArgumentError) { SetBuilder::Trait.new('who were "born" <nope>') }
    end
  end


end
