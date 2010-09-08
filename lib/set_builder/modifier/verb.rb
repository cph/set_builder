require 'set_builder/modifier/base'


module SetBuilder
  module Modifier
    class Verb < Base
      
      
      
    protected
      
      
      
      def negate(selector, operator)
        conditions = build_conditions_for(selector, operator)
        conditions[0] = "NOT(#{conditions[0]})"
        conditions        
      end
      
      
      
    end
  end
end