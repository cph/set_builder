require 'set_builder/trait/base'

module SetBuilder
  module Trait
    class Noun < Trait::Base
    
    
      ### initialization
      def initialize(name, type, options={}, &block)
        super(name, :noun, options, &block)
        @type = type
      end


    end
  end
end