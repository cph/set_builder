gem 'minitest'
require "rubygems"
require "rails"
require "rails/test_help"
require "active_support/core_ext"
require "turn"
require "set_builder"
require "pry"
require "support/fake_connection"



# Sample class used by tests

SetBuilder::ValueMap.register(:school, [[1, "Concordia"], [2, "McKendree"]])

class Friend
  extend SetBuilder


  trait(:is, "awesome") do |query, scope|
    scope << {:conditions => {:awesome => true}}
  end

  trait(nil, "died") do |query, scope|
    scope << {:conditions => {:alive => false}}
  end

  # this trait accepts modifiers --- an adverbial clause
  trait(:was, "born", :date) do |query, scope|
    scope << {:conditions => query.modifiers[0].build_conditions_for("friends.birthday")}
  end

  trait(:whose, "age", :number) do |query, scope|
    scope << {:conditions => query.modifiers[0].build_conditions_for("friends.age")}
  end

  # this trait has a direct object
  trait(:has, {"attended" => :school}) do |query, scope|
    scope << {
      :joins => "INNER JOIN schools ON friends.school_id=schools.id",
      :conditions => {"schools.id" => query.direct_object}
    }
  end

  # this trait is a noun
  # also modifiers can be classes
  trait(:whose, "name", StringModifier) do |query, scope|
    scope << {:conditions => query.modifiers[0].build_conditions_for("friends.name")}
  end
  
  
  
  # by stubbing out scoped, we can unit test the `performed` features
  def self.to_scope
    []
  end
  
  
  
  # Stubs so that Arel can SQL
  
  attr_accessor :connection_pool
  
  def initialize
    @connection_pool = Fake::ConnectionPool.new
  end
  
  def connection
    connection_pool.connection
  end
  
  
  
end

Arel::Table.engine = Arel::Sql::Engine.new(Friend.new)
