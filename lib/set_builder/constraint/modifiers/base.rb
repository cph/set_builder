module SetBuilder
  class Constraint
    module Modifier
      class Base
        
        
        
        def initialize(hash)
          @operator, @values = hash.first[0], hash.first[1]
          @values = [@values] unless @values.is_a?(Array)
        end
        
        
        
        attr_reader :operator, :values
        
        
        
        def valid?
          raise NotImplementedError
        end
        
        
        
      end
    end
  end
end