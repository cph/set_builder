require "test_helper"

class DatePrepositionTest < ActiveSupport::TestCase
  include SetBuilder::Modifiers

  attr_reader :table

  setup do
    @table = Arel::Table.new(:people)
  end


  test "should constrain our date queries to A.D." do
    Timecop.freeze do
      time = 5.years.ago
      modifier = DatePreposition.new(operator: :in_the_last, values: [5, "years"])
      assert_equal "\"people\".\"birthday\" >= '#{time}'",
        modifier.build_arel_for(table[:birthday]).to_sql
    end
  end

  test "should constrain dates between two dates with BETWEEN" do
    modifier = DatePreposition.new(operator: :between, values: ["2015-01-01", "2015-12-31"])
    assert_equal "\"people\".\"birthday\" BETWEEN '2015-01-01' AND '2015-12-31'",
      modifier.build_arel_for(table[:birthday]).to_sql
  end


end
