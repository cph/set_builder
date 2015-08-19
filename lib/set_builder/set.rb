module SetBuilder
  class Set
    
    
    
    def initialize(model, scope, raw_data)
      @model = model
      @scope = scope
      @set = raw_data
    end
    
    
    
    attr_reader :model, :scope



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
      constraints.inject(scope) { |scope, constraint| constraint.perform(scope) }
    end



  private



    attr_reader :set

    def get_constraints
      set.inject([]) do |constraints, line|
        negate, trait_name, args = false, line.first.to_s, line[1..-1]
        trait_name, negate = trait_name[1..-1], true if (trait_name[0..0] == "!")
        trait = model.traits[trait_name]
        raise("\"#{trait_name}\" is not a trait for #{model}") unless trait
        constraints << trait.apply(*args).negate(negate)
      end
    end



  end
end
