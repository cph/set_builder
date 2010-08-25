require 'set_builder/trait'
require 'set_builder/modifier_collection'


module SetBuilder
  class Traits < Array
    
    
    
    def [](index)
      case index
      when Symbol, String
        index = index.to_s
        self.find {|trait| trait.name == index}
      else
        super
      end
    end
    
    
    
    def to_json
      "[#{collect(&:to_json).join(",")}]"
    end
    
    
    
    def modifiers
      inject(ModifierCollection.new) do |modifiers, trait|
        trait.modifiers.each do |modifier|
          modifiers << modifier unless modifiers.member?(modifier)
        end
      end
    end
    
    
    
  end
end