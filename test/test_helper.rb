require 'rubygems'
require 'set_builder'
require 'active_support'
require 'active_support/test_case'
require 'redgreen'




# Sample class used by tests

class Friend
  extend SetBuilder


  trait("awesome", :reflexive) do |query|
    scoped({:conditions => {:awesome => true}})
  end

  trait("died", :active) do |query|
    scoped({:conditions => {:alive => false}})
  end

  # this trait accepts modifiers --- an adverbial clause
  trait("born", :passive, :modifiers => [Date]) do |query|
    scoped({:conditions => query.prepositions.first.build_conditions_for("friends.birthday")})
  end

  # this trait has a direct object
  trait({"attended" => String}, :perfect) do |query|
    scoped({
      :joins => "INNER JOIN schools ON friends.school_id=schools.id",
      :conditions => {"schools.name" => query.school}
    })
  end

  # this trait is a noun
  trait("name", String) do |query|
    scoped({:conditions => query.build_conditions_for("friends.name")})
  end
  
  
  
  # by stubbing out scoped, we can unit test the `performed` features
  
  # !todo: to test constraint.perform, would it be good for `scoped` to return a new object each time?
  
  def self.scoped(*args)
    @composed_scope ||= []
    @composed_scope << args unless args.blank?
    self
  end
  
  def self.composed_scope
    @composed_scope || []
  end
  
  def self.reset_composed_scope
    @composed_scope = []
  end
  
  
  
end