require 'set_builder/trait'
require 'set_builder/trait_builder'
require 'set_builder/modifier_collection'


module SetBuilder
  class Traits < Array



    def initialize(&block)
      TraitBuilder.new(self).instance_eval(&block) if block_given?
    end



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
      # !nb: not sure why inject was failing but it was modifying trait.modifiers!
      @modifiers = ModifierCollection.new
      each do |trait|
        trait.modifiers.each do |modifier|
          @modifiers << modifier unless @modifiers.member?(modifier)
        end
      end
      @modifiers
    end



  end
end
