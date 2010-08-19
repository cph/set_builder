require 'set_builder/constraint/modifiers/base'

module SetBuilder
  class Constraint
    module Modifier
      class String < Base
        
        
        
        def self.operators
          {
            :contains => [String],
            :begins_with => [String],
            :ends_with => [String],
            :is => [String],
          }
        end
        
        
        
        def valid?
          arguments = self.class.operators[operator]
          !arguments.nil? and (arguments.length == values.length)
        end
        
        
        
        def build_conditions_for(selector)
          case operator
          when :is
            ["#{selector}=?", values[0]]
          else
            ["#{selector} LIKE ?", get_like_value_for_operator]
          end
        end
        
        
        
        def to_s
          "#{operator} #{values.to_sentence}"
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
end