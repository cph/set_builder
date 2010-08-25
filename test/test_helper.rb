require 'rubygems'
require 'set_builder'
require 'active_support'
require 'active_support/test_case'
require 'redgreen'




# Sample class used by tests

class Friend
  extend SetBuilder


  trait(:is, "awesome") do |query|
    scoped({:conditions => {:awesome => true}})
  end

  trait(nil, "died") do |query|
    scoped({:conditions => {:alive => false}})
  end

  # this trait accepts modifiers --- an adverbial clause
  trait(:was, "born", :date) do |query|
    scoped({:conditions => query.modifiers[0].build_conditions_for("friends.birthday")})
  end

  # this trait has a direct object
  trait(:has, {"attended" => :string}) do |query|
    scoped({
      :joins => "INNER JOIN schools ON friends.school_id=schools.id",
      :conditions => {"schools.name" => query.direct_object}
    })
  end

  # this trait is a noun
  # also modifiers can be classes
  trait(:whose, "name", StringModifier) do |query|
    scoped({:conditions => query.modifiers[0].build_conditions_for("friends.name")})
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