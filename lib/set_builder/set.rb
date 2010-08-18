module SetBuilder
  class Set
    
    
    
    def initialize(model_or_scope, set)
      @set = set
      case model_or_scope # or association?
      when ActiveRecord::NamedScope::Scope
        @model, @scope = model_or_scope.proxy_scope, model_or_scope
      else
        @model, @scope = model_or_scope, model_or_scope.scoped()
      end
    end
    
    
    
    attr_reader :model
    
    
    
    def constraints
      @constraints ||= get_constraints
    end
    
    
    
    #
    # Returns true if all of the constraints in this set are valid
    #
    def valid?
      constraints.all?(&:valid?)
    end
    
    

    #
    # Describes this set in natural language
    #    
    def to_s
      constraints.to_sentence
    end
    
    
    
    #
    # Returns an instance of ActiveRecord::NamedScope::Scope
    # which can fetch the objects which belong to this set
    #    
    def perform
      constraints.inject(@scope) {|scope, constraint| scope = constraint.perform(scope)}
    end
    
    
    
  private
    
    
    
    def get_constraints
      @set.inject([]) do |constraints, line|
        trait_name, args = line.first, line[1..-1]
        trait = model.traits[trait_name]
        constraints << trait.apply(*args) if trait
      end
    end
    
    
    
  end
end