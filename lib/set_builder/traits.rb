require 'set_builder/trait/noun'
require 'set_builder/trait/predicate'

module SetBuilder
  module Traits
    
    
    def traits
      @traits ||= []
    end
    
    
    def trait(name, part_of_speech_or_type, options={}, &block)
      klass = part_of_speech_or_type.is_a?(Class) ? Trait::Noun : Trait::Predicate
      trait = klass.new(name, part_of_speech_or_type, options, &block)
      traits << trait
    end
    
    
  end
end