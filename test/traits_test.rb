require 'test_helper'

class TraitsTest < ActiveSupport::TestCase


  test "traits" do
    expected_traits = %w{awesome born attended died name}
    assert_equal expected_traits, Friend.traits.collect(&:name)
  end
  
  test "traits' accessor" do
    traits = Friend.traits
    assert_kind_of SetBuilder::Traits, traits
    assert_equal "awesome", traits[0].name
    assert_kind_of SetBuilder::Trait::Base, traits[:born]
  end
  
  



end


class Friend
  extend SetBuilder


  trait "awesome", :reflexive do |query|
    {:conditions => {:awesome => true}}
  end

  trait "born", :passive, :prepositions => [Date] do |query|
    {:conditions => query.prepositions.first.build_conditions_for("friends.birthday")}
  end

  trait "attended", :perfect, :params => [:school] do |query|
    {
      :joins => "INNER JOIN schools ON friends.school_id=schools.id",
      :conditions => {"schools.name" => query.school}
    }
  end

  trait "died", :active do |query|
    {:conditions => {:alive => false}}
  end

  trait "name", String do |query|
    {:conditions => query.build_conditions_for("friends.name")}
  end


end