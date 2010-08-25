require 'set_builder/modifier/base'
require 'set_builder/period'

module SetBuilder
  module Modifiers
    class NumberModifier < Modifier::Base
      
      
      
      def self.operators
        {
          :is => [:number],
          :is_less_than => [:number],
          :is_greater_than => [:number],
        }
      end
      
      
      
      def build_conditions_for(selector)
        case operator
        when :is
          ["#{selector}=", format_value]
        when :is_less_than
          ["#{selector}<", format_value]
        when :is_greater_than
          ["#{selector}>", format_value]
        end
      end
      
      
      
    private
      
      
      
      def format_value
        values[0]
      end
      
      
      
    end
  end
end