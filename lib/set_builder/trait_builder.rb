module SetBuilder
  class TraitBuilder
    attr_reader :traits

    def initialize(traits)
      @traits = traits
    end

    def trait(trait_expression, &block)
      traits << Trait.new(trait_expression, &block)
    end

  end
end
