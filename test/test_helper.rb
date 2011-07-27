require 'rubygems'
require 'set_builder'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/test_case'



# Mocks NamedScope so that composed scoping can be tested

class FakeScope
  
  def initialize(args)
    args = [args] unless args.is_a?(Array)
    @composed_scope = args
  end
  
  def scoped(args)
    FakeScope.new(@composed_scope + [args])
  end
  
  def composed_scope
    @composed_scope
  end
  
end



# Sample class used by tests

SetBuilder::ValueMap.register(:school, [[1, "Concordia"], [2, "McKendree"]])

class Friend
  extend SetBuilder


  trait(:is, "awesome") do |query|
    {:conditions => {:awesome => true}}
  end

  trait(nil, "died") do |query|
    {:conditions => {:alive => false}}
  end

  # this trait accepts modifiers --- an adverbial clause
  trait(:was, "born", :date) do |query|
    {:conditions => query.modifiers[0].build_conditions_for("friends.birthday")}
  end

  # this trait has a direct object
  trait(:has, {"attended" => :school}) do |query|
    {
      :joins => "INNER JOIN schools ON friends.school_id=schools.id",
      :conditions => {"schools.id" => query.direct_object}
    }
  end

  # this trait is a noun
  # also modifiers can be classes
  trait(:whose, "name", StringModifier) do |query|
    {:conditions => query.modifiers[0].build_conditions_for("friends.name")}
  end
  
  
  
  # by stubbing out scoped, we can unit test the `performed` features
  def self.scoped(*args)
    FakeScope.new(args)
  end
  
  
  
end