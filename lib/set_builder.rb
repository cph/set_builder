require 'activerecord'
require 'set_builder/traits'
require 'set_builder/modifiers'
require 'set_builder/set'


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
    SetBuilder::Set.new(self, set)
  end
  
  
protected
  
  
  
  def trait(*args, &block)
    part_of_speech = get_part_of_speech(args.shift)
    name = args.shift
    traits << Trait.new(name, part_of_speech, *args, &block)
  end
  
  
  def get_part_of_speech(arg)
    case arg
    when :is, :are, :reflexive
      :reflexive
    when nil, :active
      :active
    when :was, :were, :passive
      :passive
    when :has, :have, :perfect
      :perfect
    when :whose, :noun
      :noun
    end
  end
  
  
end