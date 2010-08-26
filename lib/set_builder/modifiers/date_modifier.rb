require 'set_builder/modifier/base'
require 'set_builder/period'

module SetBuilder
  module Modifiers
    class DateModifier < Modifier::Base
      
      
      
      def self.operators
        {
          :"." => [],
          :before => [:date],
          :after => [:date],
          :on => [:date],
          :in_the_last => [:number, :period]
        }
      end
      
      
      
      def build_conditions_for(selector)
        case operator
        when :".":
          ["#{selector} IS NOT NULL"]
        when :before
          ["#{selector}<?", format_value]
        when :after
          ["#{selector}>?", format_value]
        when :on
          ["#{selector}=?", format_value]
        when :in_the_last
          ["#{selector}>=?", format_value]
        else
          []
        end
      end
      
      
      
    protected
      
      
      
      def format_value
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
          values[0].to_date
        end
      end
      
      
      
    end
  end
end