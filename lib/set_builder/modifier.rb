require 'set_builder/modifiers'
require 'set_builder/modifier/adverb'
require 'set_builder/modifier/verb'

module SetBuilder
  module Modifier
    
    
    
    @registered_modifiers = {}
    
    
    
    def self.registered?(klass)
      @registered_modifiers.values.member?(klass)
    end
    
    
    
    def self.name(klass)
      @registered_modifiers.each do |key, value|
        return key if (value == klass)
      end
      klass.name
    end
    
    
    
    def self.for(type)
      type = get_type(type)
      @registered_modifiers[type] || raise(ArgumentError, "A modifier has not been registered for #{type}")
    end
    
    
    
    def self.[](klass_or_symbol)
      klass_or_symbol.is_a?(Class) ? SetBuilder::Modifier.valid_modifier!(klass_or_symbol) : SetBuilder::Modifier.for(klass_or_symbol)
    end
    
    
    
    # 
    # Usage
    #   register(type, modifier)
    #   register([type, modifier], [type, modifier])
    #   register(type, modifier, type, modifier)
    #
    def self.register(*args)
      args, i = args.flatten, 0
      while args[i+1]
        type, modifier_klass = get_type(args[i]), args[i+1]
        valid_modifier!(modifier_klass) # || raise(ArgumentError, "#{modifier_klass} is not a valid modifier")
        @registered_modifiers[type] = modifier_klass
        i += 2
      end
    end
    
    
    
    def self.valid_modifier!(klass)
      raise(ArgumentError, "#{klass} must inherit from either `SetBuilder::Modifier::Verb` or `SetBuilder::Modifier::Adverb`") unless (is_subclass_of?(klass, SetBuilder::Modifier::Adverb) or is_subclass_of?(klass, SetBuilder::Modifier::Verb))
      raise(ArgumentError, "#{klass} must respond to `operators`") unless klass.respond_to?(:operators)
      raise(ArgumentError, "#{klass}.operators must not be empty") if klass.operators.empty?
      klass
    end
    
    
    
  private
    
    
    
    def self.get_type(type)
      if type.is_a?(Symbol)
        type
      else
        type.to_s.downcase.to_sym
      end
    end
    
    
    
    def self.is_subclass_of?(klass, superklass)
      sc = klass
      while (sc = sc.superclass)
        return true if (sc == superklass)
      end
      false
    end
    
    
    
  end
  
  
  
  #
  # Force predefined modifiers to pass `valid_modifier?`
  #
  Modifier.register(
    [:date,     Modifiers::DatePreposition],
    [:number,   Modifiers::NumberPreposition],
    [:string,   Modifiers::StringPreposition]
  )
  
  
  
end







#
# Why is the below not working?
#

# class Class
#   
#   
#   
#   def is_subclass_of?(klass)
#     sc = self
#     while (sc = sc.superclass)
#       return true if (sc == klass)
#     end
#     false
#   end
#   
#   
#   
# end
