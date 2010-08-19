require 'activerecord'
require 'set_builder/traits'
require 'set_builder/set'


module SetBuilder
  
  
  def self.extended(base)
    base.instance_variable_set("@traits", SetBuilder::Traits.new)
  end
  
  
  attr_reader :traits
  
  
  def find_set(set)
    set = SetBuilder::Set.new(self, set)
    set.perform
  end
  
  
protected
  
  
  def trait(name, part_of_speech_or_type, options={}, &block)
    klass = part_of_speech_or_type.is_a?(Class) ? Trait::Noun : Trait::Predicate
    trait = klass.new(name, part_of_speech_or_type, options, &block)
    traits << trait
  end
  
  
end