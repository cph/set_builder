require 'set_builder/traits'
require 'set_builder/inflector'


# module SetBuilder
#   
#   
#   @query_builders = {
#     :string => SetBuilder::QueryBuilder::String,
#     :date => SetBuilder::QueryBuilder::Date,
#     
#   }
#   
#   
#   def self.register_query_builder(type, klass)
#     type = type.name.downcase.to_sym if type.is_a?(Class)
#     @query_builders[type] = klass
#   end
#   
#   
# end