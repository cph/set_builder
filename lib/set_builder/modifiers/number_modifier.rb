require 'set_builder/modifier/verb'


module SetBuilder
  module Modifiers
    class NumberModifier < Modifier::Verb
      
      
      
      def self.operators
        {
          :is => [:number],
          :is_less_than => [:number],
          :is_greater_than => [:number],
          :is_between => [:number, :number]
        }
      end
      
      
      
      def build_conditions_for(selector)
        case operator
        when :is
          ["#{selector}=?", value]
        when :is_less_than
          ["#{selector}<?", value]
        when :is_greater_than
          ["#{selector}>?", value]
        when :is_between
          ["#{selector}>=? AND #{selector}<=?", values[0], values[1]]
        end
      end
      
      
      
      def build_arel_for(selector)
        case operator
        when :is
          selector.eq(value)
        when :is_less_than
          selector.lt(value)
        when :is_greater_than
          selector.gt(value)
        when :is_between
          selector.gteq(values[0]).and(selector.lteq(values[1]))
        end
      end
      
      
      
    end
  end
end
