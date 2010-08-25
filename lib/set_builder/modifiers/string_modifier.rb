require 'set_builder/modifier/base'

module SetBuilder
  module Modifiers
    class StringModifier < Modifier::Base
      
      
      
      def self.operators
        {
          :contains => [:string],
          :begins_with => [:string],
          :ends_with => [:string],
          :is => [:string]
        }
      end
      
      
      
      def build_conditions_for(selector)
        case operator
        when :is
          ["#{selector}=?", values[0]]
        else
          ["#{selector} LIKE ?", get_like_value_for_operator]
        end
      end
      
      
      
    private
      
      
      
      def get_like_value_for_operator
        case operator
        when :contains
          "%#{values[0]}%"
        when :begins_with
          "#{values[0]}%"
        when :ends_with
          "%#{values[0]}"
        end
      end
      
      
      
    end
  end
end