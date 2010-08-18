require 'set_builder/inflector'
require 'set_builder/constraint'

module SetBuilder
  module Trait
    class Base
    
    
      ### initialization
      def initialize(name, part_of_speech, options={}, &block)
        @name = name
        @part_of_speech = part_of_speech
      end
    
    
      ### macros
      attr_reader :name, :part_of_speech
    
    
      def singular
        @singular ||= SetBuilder::Inflector.singular(part_of_speech, name)
      end
    
      def plural
        @plural ||= SetBuilder::Inflector.plural(part_of_speech, name)
      end
    
      def to_s
        plural
      end
      
      
      
      def apply(*args)
        SetBuilder::Constraint.new(self, *args)
      end

    
    end
  end
end