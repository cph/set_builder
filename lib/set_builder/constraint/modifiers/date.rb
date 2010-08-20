require 'set_builder/constraint/modifiers/base'

module SetBuilder
  class Constraint
    module Modifier
      class Date < Base
        
        
        
        def self.operators
          {
            :before => [::Date],
            :after => [::Date],
            :on => [::Date]
          }
        end
        
        
        
        def build_conditions_for(selector)
          case operator
          when :before
            ["#{selector} < ", format_value]
          when :after
            ["#{selector} > ", format_value]
          when :on
            ["#{selector} = ", format_value]
          end
        end
        
        
        
      private
        
        
        
        def format_value
          values[0]
        end
        
        
        
      end
    end
  end
end