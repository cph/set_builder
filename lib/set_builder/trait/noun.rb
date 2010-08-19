require 'set_builder/trait/base'

module SetBuilder
  module Trait
    class Noun < Trait::Base
      
      
      
      def initialize(name, type, options={}, &block)
        raise(ArgumentError, "The name of a noun trait cannot be a Hash: nouns do not accept direct objects") if name.is_a?(Hash)
        options[:modifiers] = [type]
        super(name, :noun, options, &block)
      end
      
      
      
    end
  end
end