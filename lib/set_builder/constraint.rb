module SetBuilder
  class Constraint
    
    
    
    def initialize(trait, *args)
      @trait = trait
    end
    
    
    
    attr_reader :trait
    
    
    
    def valid?
    end
    
    
    
    def to_s
      trait.to_s
    end
    
    
    
    def perform
    end
    
    
    
  end
end