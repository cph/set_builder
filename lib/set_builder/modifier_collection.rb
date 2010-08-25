module SetBuilder
  class ModifierCollection < Array
    
    
    
    # def [](index)
    #   case index
    #   when Symbol, String
    #     index = index.to_s
    #     self.find {|trait| trait.name == index}
    #   else
    #     super
    #   end
    # end
    
    
    
    def to_hash
      hash = {}
      each do |modifier|
        hash[Modifier.name(modifier)] = modifier.to_hash
      end
      hash
    end
    
    
    
    def to_json
      to_hash.to_json
    end
    
    
    
    # def modifiers
    #   inject([]) {|modifiers, trait| modifiers.concat(trait.modifiers)}.uniq
    # end
    
    
    
  end
end