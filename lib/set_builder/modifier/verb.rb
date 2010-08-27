require 'set_builder/modifier/base'


module SetBuilder
  module Modifier
    class Verb < Base
      
      
      
    protected
      
      
      
      def negate(operator)
        conditions = build_conditions_for(operator)
        conditions[0] = "NOT(#{conditions[0]})"
        conditions        
      end
      
      
      
    end
  end
end