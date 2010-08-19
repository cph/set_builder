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
        
        
        
        def to_s
          "#{operator} #{values.to_sentence}"
        end
        
        
        
      end
    end
  end
end