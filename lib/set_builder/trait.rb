require 'set_builder/constraint'
require 'set_builder/inflector'
require 'set_builder/modifier'

module SetBuilder
  class Trait
    
    
    
    def initialize(name, part_of_speech, *args, &block)
      case name
      when Hash
        @name, @direct_object_type = name.first[0], name.first[1]
      else
        @name = name
      end
      @part_of_speech, @block = part_of_speech, block
      @modifiers = (args||[]).collect {|modifier| Modifier[modifier]}
    end
    
    
    
    attr_reader :name, :part_of_speech, :modifiers
    
    
    
    def requires_direct_object?
      !@direct_object_type.nil?
    end
    alias :direct_object_required? :requires_direct_object?
    
    
    
    def singular
      @singular ||= SetBuilder::Inflector.singular(part_of_speech, name)
    end
    
    
    
    def plural
      @plural ||= SetBuilder::Inflector.plural(part_of_speech, name)
    end
    
    
    
    def to_s
      plural
    end
    
    
    
    def to_json
      array = []
      array << (requires_direct_object? ? [name, @direct_object_type] : name)
      array << part_of_speech
      array << modifiers.collect{|klass| Modifier.name(klass)} unless modifiers.empty?
      array.to_json
    end
    
    
    
    def apply(*args)
      SetBuilder::Constraint.new(self, *args, &@block)
    end
    
    
    
  end
end