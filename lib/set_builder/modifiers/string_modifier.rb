require 'set_builder/modifier/verb'


module SetBuilder
  module Modifiers
    class StringModifier < Modifier::Verb
      
      
      
      def self.operators
        {
          :contains => [:string],
          :does_not_contain => [:string],
          :begins_with => [:string],
          :does_not_begin_with => [:string],
          :ends_with => [:string],
          :does_not_end_with => [:string],
          :is => [:string],
          :is_not => [:string]
        }
      end
      
      
      
      def self.negate(operator)
        case operator
        when :contains
          "does not contain"
        when :begins_with
          "does not begin with"
        when :ends_with
          "does not end with"
        when :is
          "is not"
        end
      end
      
      
      
      def build_conditions_for(selector)
        case operator
        when :does_not_contain
          negate(:contains)
        when :does_not_begin_with
          negate(:begins_with)
        when :does_not_end_with
          negate(:ends_with)
        when :is_not
          negate(:is)
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