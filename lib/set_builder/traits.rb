require 'set_builder/trait/noun'
require 'set_builder/trait/predicate'

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
    
    
  end
end