require 'test_helper'

class StringPrepositionTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers

  attr_reader :table

  setup do
    @table = Arel::Table.new(:fruits)
  end


  test "#build_arel_for should generate the correct SQL" do
    modifier = StringPreposition.new(does_not_contain: ["banana"])
    assert_equal "(\"fruits\".\"name\" IS NULL OR \"fruits\".\"name\" NOT LIKE '%banana%')",
      modifier.build_arel_for(table[:name]).to_sql
  end


end
