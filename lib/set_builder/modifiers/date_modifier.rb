require 'set_builder/modifier/base'
require 'set_builder/period'

module SetBuilder
  module Modifiers
    class DateModifier < Modifier::Base
      
      
      
      def self.operators
        {
          '.' => [],
          :before => [:date],
          :after => [:date],
          :on => [:date],
          :in_the_last => [:number, :period]
        }
      end
      
      
      
      def build_conditions_for(selector)
        case operator
        when :before
          ["#{selector}<", format_value]
        when :after
          ["#{selector}>", format_value]
        when :on
          ["#{selector}=", format_value]
        when :in_the_last
          ["#{selector_for_period(selector)}<=", format_value]
        end
        []
      end
      
      
      
    private
      
      
      
      def format_value
        values[0]
      end
      
      
      
      # !todo: this might not result in *exactly* expected values
      def selector_for_period(selector)
        # datediff = "DATEDIFF(CURDATE(), #{selector})"
        case values[1]
        when "years", "year"
          "DATEDIFF(CURDATE(), #{selector})/365"
        when "months", "month"
          "DATEDIFF(CURDATE(), #{selector})/30"
        when "weeks", "week"
          "(DATEDIFF(CURDATE(), #{selector})/7)"
        when "days", "day"
          "DATEDIFF(CURDATE(), #{selector})"
        end
      end
      
      
      
    end
  end
end