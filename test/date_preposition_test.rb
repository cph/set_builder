require 'test_helper'

class DatePrepositionTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers

  attr_reader :table

  setup do
    @table = Arel::Table.new(:people)
  end


  test "should constrain our date queries to A.D." do
    Timecop.freeze do
      time = 5.years.ago
      modifier = DatePreposition.new(in_the_last: [5, "years"])
      assert_equal "\"people\".\"birthday\" >= '#{time}'", modifier.build_arel_for(table[:birthday]).to_sql
    end
  end


end
