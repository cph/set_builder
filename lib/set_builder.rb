require "active_record"
require "active_support/core_ext"
require "set_builder/traits"
require "set_builder/errors/trait_not_found"
require "set_builder/modifiers"
require "set_builder/value_map"
require "set_builder/set"
require "set_builder/engine"


module SetBuilder
  @__value_map = ValueMap

  def self.value_map
    @__value_map
  end

  def self.value_map=(value_map)
    @__value_map = value_map
  end
end
