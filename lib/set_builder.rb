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
  
  
  # @query_builders = {
  #   :string => SetBuilder::QueryBuilder::String,
  #   :date => SetBuilder::QueryBuilder::Date,
  #   
  # }
  # 
  # 
  # def self.register_query_builder(type, klass)
  #   type = type.name.downcase.to_sym if type.is_a?(Class)
  #   @query_builders[type] = klass
  # end
  
  
end