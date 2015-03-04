require "rubygems"
require "rails"
require "rails/test_help"
require "active_support/core_ext"
require "set_builder"
require "pry"
require "support/fake_connection"



# Sample class used by tests

SetBuilder::ValueMap.register(:school, [[1, "Concordia"], [2, "McKendree"]])

class Friend
  extend SetBuilder

  trait('is "awesome"') do |query, scope|
    scope << {:conditions => {:awesome => true}}
  end

  trait('"died"') do |query, scope|
    scope << {:conditions => {:alive => false}}
  end

  trait('was "born" <date>') do |query, scope|
    scope << {:conditions => query.modifiers[0].build_conditions_for("friends.birthday")}
  end

  trait('whose "age" <number>') do |query, scope|
    scope << {:conditions => query.modifiers[0].build_conditions_for("friends.age")}
  end

  trait('has [not] "attended" :school') do |query, scope|
    scope << {
      :joins => "INNER JOIN schools ON friends.school_id=schools.id",
      :conditions => {"schools.id" => query.direct_object}
    }
  end

  trait('whose "name" <string>') do |query, scope|
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
