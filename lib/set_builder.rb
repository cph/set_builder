require 'active_record'
require 'active_support/core_ext'
require 'set_builder/traits'
require 'set_builder/modifiers'
require 'set_builder/value_map'
require 'set_builder/set'
require 'set_builder/engine'


module SetBuilder
    
  def self.extended(base)
    base.instance_variable_set("@traits", SetBuilder::Traits.new)
    base.send(:include, SetBuilder::Modifiers)
  end
  
  
  attr_reader :traits
  
  def modifiers
    traits.modifiers
  end
  
  def that_belong_to(set)
    SetBuilder::Set.new(self, to_scope, set)
  end
  
  def to_scope
    scoped
  end

protected

  def trait(trait_expression, &block)
    traits << Trait.new(trait_expression, &block)
  end
  
end
