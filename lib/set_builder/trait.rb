require 'set_builder/constraint'
require 'set_builder/modifier'


module SetBuilder
  class Trait
    
    
    
    def initialize(name, part_of_speech, *args, &block)
      case name
      when Hash
        @name, @direct_object_type = name.first[0].to_s, name.first[1]
      else
        @name = name.to_s
      end
      @part_of_speech, @block = part_of_speech, block
      @modifiers = (args||[]).collect {|modifier| Modifier[modifier]}
    end
    
    
    
    attr_reader :name, :part_of_speech, :modifiers, :direct_object_type
    
    
    
    def requires_direct_object?
      !@direct_object_type.nil?
    end
    alias :direct_object_required? :requires_direct_object?
    
    
    
    def to_s(negative=false)
      case part_of_speech
      when :active
        negative ? "who have not #{name}" : "who #{name}"
      when :perfect
        negative ? "who have not #{name}" : "who have #{name}"
      when :passive
        negative ? "who were not #{name}" : "who were #{name}"
      when :reflexive
        negative ? "who are not #{name}" : "who are #{name}"
      when :noun
        "whose #{name}"
      end
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