require 'rubygems'
require 'set_builder'
require 'active_support'
require 'active_support/test_case'
require 'redgreen'


# Sample class

class Friend < ActiveRecord::Base
  extend SetBuilder


  trait("awesome", :reflexive) do |query|
    {:conditions => {:awesome => true}}
  end

  trait("born", :passive, :modifiers => [Date]) do |query|
    {:conditions => query.prepositions.first.build_conditions_for("friends.birthday")}
  end

  trait({"attended" => String}, :perfect) do |query|
    {
      :joins => "INNER JOIN schools ON friends.school_id=schools.id",
      :conditions => {"schools.name" => query.school}
    }
  end

  trait("died", :active) do |query|
    {:conditions => {:alive => false}}
  end

  trait("name", String) do |query|
    {:conditions => query.build_conditions_for("friends.name")}
  end


end