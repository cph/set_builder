require 'set_builder/modifier/verb'


module SetBuilder
  module Modifiers
    class NumberPreposition < Modifier::Verb
      
      
      
      def self.operators
        {
          :exactly => [:number],
          :less_than => [:number],
          :greater_than => [:number],
          :between => [:number, :number]
        }
      end
      
      
      
      def build_conditions_for(selector)
        case operator
        when :exactly
          ["#{selector}=?", value]
        when :less_than
          ["#{selector}<?", value]
        when :greater_than
          ["#{selector}>?", value]
        when :between
          ["#{selector}>=? AND #{selector}<=?", values[0], values[1]]
        end
      end
      
      
      
      def build_arel_for(selector)
        case operator
        when :exactly
          selector.eq(value)
        when :less_than
          selector.lt(value)
        when :greater_than
          selector.gt(value)
        when :between
          selector.gteq(values[0]).and(selector.lteq(values[1]))
        end
      end
      
      
      
    end
  end
end
