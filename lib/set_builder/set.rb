module SetBuilder
  class Set
    
    
    
    def initialize(model_or_scope, raw_data)
      @model, @scope = get_model_and_scope(model_or_scope)
      @set = raw_data
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
      constraints.inject(@scope) {|scope, constraint| constraint.perform(scope)}
    end
    
    
    
  private
    
    
    
    def get_constraints
      @set.inject([]) do |constraints, line|
        negate, trait_name, args = false, line.first.to_s, line[1..-1]
        trait_name, negate = trait_name[1..-1], true if (trait_name[0..0] == "!")
        trait = model.traits[trait_name]
        raise("\"#{trait_name}\" is not a trait for #{model}") unless trait
        constraints << trait.apply(*args).negate(negate)
      end
    end
    
    
    
    # !todo: this can be overriden or factored out to allow SetBuilder 
    #   to be used with other ORMs like DataMapper
    def get_model_and_scope(model_or_scope)
      case model_or_scope # or association?
      when ActiveRecord::NamedScope::Scope
        [model_or_scope.proxy_scope, model_or_scope]
      else
        [model_or_scope, model_or_scope.scoped({})]
      end      
    end
    
    
    
  end
end