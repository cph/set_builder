require 'test_helper'

class TraitsTest < ActiveSupport::TestCase


  test "traits" do
    expected_traits = %w{awesome born attended died name}
    assert_equal expected_traits, Friend.traits.collect(&:name)
  end
  
  



end


class Friend
  extend SetBuilder::Traits


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