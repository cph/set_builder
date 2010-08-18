require 'query_builder/predicate'
require 'query_builder/predicate_builder'

module QueryBuilder
  module Predicates
    
    
    def predicates
      @predicates ||= []
    end
    
    
    def predicate(name, &block)
      predicate = Predicate.new(name)
      if block_given?
        yield PredicateBuilder.new(predicate)
      end
      predicates << predicate
    end
    
    
  end
end