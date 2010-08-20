require 'set_builder/constraint/modifiers/string'
require 'set_builder/constraint/modifiers/date'
require 'set_builder/constraint/modifiers/integer'


module SetBuilder
  class Constraint
    module Modifier
      
      
      
      @registered_modifiers = {}
      
      
      
      def self.to_hash
        hash = {}
        @registered_modifiers.each do |type, modifier_type|
          hash[type.to_s] = modifier_type.to_hash
        end
        hash
      end
      
      
      
      def self.to_json
        to_hash.to_json
      end
      
      
      
      def self.for(type)
        type = get_type(type)
        @registered_modifiers[type] || raise(ArgumentError, "A modifier has not been registered for #{type}")
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
        raise(ArgumentError, "#{klass} must inherit from `SetBuilder::Constraint::Modifier::Base`") unless is_subclass_of?(klass, SetBuilder::Constraint::Modifier::Base)
        raise(ArgumentError, "#{klass} must respond to `operators`") unless klass.respond_to?(:operators)
        raise(ArgumentError, "#{klass}.operators must not be empty") if klass.operators.empty?
      end
      
      
      
      def self.get_type(type)
        if type.is_a?(Symbol)
          type
        else
          type.to_s.downcase.to_sym
        end
      end
      
      
      
    private
      
      
      
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
      # [:date,     SetBuilder::Constraint::Modifier::Date],
      # [:integer,  SetBuilder::Constraint::Modifier::Integer],
      [:string,   SetBuilder::Constraint::Modifier::String]
    )
    
    
  end
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