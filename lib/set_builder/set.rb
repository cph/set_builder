module SetBuilder
  class Set



    def initialize(traits, scope, raw_data)
      @traits = traits
      @scope = scope
      @set = self.class.normalize(raw_data)
    end



    attr_reader :traits, :scope



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
    # Exports this set in raw data
    #
    def to_a
      set
    end



    #
    # Returns an instance of ActiveRecord::NamedScope::Scope
    # which can fetch the objects which belong to this set
    #
    def perform
      constraints.inject(scope) { |scope, constraint| constraint.perform(scope) }
    end



    def self.normalize(constraints)
      hash_to_array(constraints).map do |constraint|
        constraint = constraint.symbolize_keys
        if constraint[:modifiers]
          constraint[:modifiers] = hash_to_array(constraint[:modifiers]).map do |modifier|
            modifier = modifier.symbolize_keys
            modifier[:values] = hash_to_array(modifier[:values]) if modifier[:values]
            modifier
          end
        end
        constraint
      end
    end

    def self.hash_to_array(hash)
      return hash.values if hash.is_a?(Hash)
      Array(hash)
    end



  private



    attr_reader :set

    def get_constraints
      set.map do |constraint|
        trait_name = constraint.fetch(:trait) do
          raise ArgumentError, ":trait is missing from the given constraint`"
        end
        trait = traits[trait_name]
        raise SetBuilder::TraitNotFound, "\"#{trait_name}\" is not a trait in `traits`" unless trait
        trait.apply(constraint)
      end
    end



  end
end
