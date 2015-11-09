require 'set_builder/modifier/adverb'


module SetBuilder
  module Modifiers
    class DatePreposition < Modifier::Adverb

      def self.operators
        {
          :ever => [],
          :before => [:date],
          :after => [:date],
          :on => [:date],
          :during_month => [:month],
          :during_year => [:year],
          :in_the_last => [:number, :period],
          :between => [:date, :date]
        }
      end

      def build_arel_for(selector)
        case operator
        when :ever
          selector.not_eq(nil)
        when :before
          selector.lt(get_date)
        when :after
          selector.gt(get_date)
        when :on
          selector.eq(get_date)
        when :during_month
          Arel::Nodes::Extract.new(selector, "month").eq(values[0].to_i)
        when :during_year
          Arel::Nodes::Extract.new(selector, "year").eq(values[0].to_i)
        when :in_the_last
          selector.gteq(get_date)
        when :between
          selector.in(Date.parse(values[0])..Date.parse(values[1]))
        end
      end

    protected

      def get_date
        case operator
        when :in_the_last
          case values[1]
          when "years", "year"
            values[0].to_i.years.ago
          when "months", "month"
            values[0].to_i.months.ago
          when "weeks", "week"
            values[0].to_i.weeks.ago
          when "days", "day"
            values[0].to_i.days.ago
          end
        else
          Date.parse values[0]
        end
      end

    end
  end
end
