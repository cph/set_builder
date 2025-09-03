module SetBuilder
  class TraitBuilder
    attr_reader :traits

    def initialize(traits)
      @traits = traits
    end

    def trait(trait_expression, **options, &block)
      traits << Trait.new(trait_expression, **options, &block)
    end

  end
end
