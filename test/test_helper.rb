require "rubygems"
require "rails"
require "rails/test_help"
require "active_support/core_ext"
require "set_builder"
require "pry"
require "support/fake_connection"
require "timecop"

require "minitest/reporters"
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Sample class used by tests

SetBuilder::ValueMap.register(:school, [[1, "Concordia"], [2, "McKendree"]])

friends = Arel::Table.new(:friends)

$friend_traits = SetBuilder::Traits.new do

  trait('who are [not] "awesome"') do |query, scope|
    scope << {:conditions => {:awesome => true}}
  end

  trait('who [have not] "died"') do |query, scope|
    scope << {:conditions => {:alive => false}}
  end

  trait('who were "born" <date>') do |query, scope|
    scope << {:conditions => query.modifiers[0].build_arel_for(friends[:birthday]).to_sql}
  end

  trait('whose "age" <number>') do |query, scope|
    scope << {:conditions => query.modifiers[0].build_arel_for(friends[:age]).to_sql}
  end

  trait('who have [not] "attended" :school') do |query, scope|
    scope << {
      :joins => "INNER JOIN schools ON friends.school_id=schools.id",
      :conditions => {"schools.id" => query.direct_object}
    }
  end

  trait('whose "name" <string>') do |query, scope|
    scope << {:conditions => query.modifiers[0].build_arel_for(friends[:name]).to_sql}
  end
end


class Friend

  # by stubbing out `all`, we can unit test `Set#perform`
  def self.all
    []
  end


  # Stubs so that Arel can SQL
  class << self
    attr_accessor :connection_pool

    def connection
      connection_pool.connection
    end
  end
  @connection_pool = Fake::ConnectionPool.new

end

Arel::Table.engine = Friend
