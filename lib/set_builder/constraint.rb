require "set_builder/modifier"


module SetBuilder
  class Constraint
    attr_reader :trait, :direct_object, :params, :modifiers
    delegate :direct_object_required?,
             :direct_object_type,
             :to => :trait



    #
    # Sample constraints:
    #
    #     { trait: :awesome }
    #     { trait: :attended, school: 2 }
    #     { trait: :died }
    #     { trait: :name, modifiers: [{ operator: :is, values: ["Jerome"] }] }
    #
    def initialize(trait, params, &block)
      @trait, @block = trait, block
      @params = params

      @negative = trait.negatable? && params.fetch(:negative, false)
      @direct_object = params[direct_object_type] if trait.requires_direct_object?
      modifiers = params.fetch(:modifiers, [])
      @modifiers = trait.modifiers.each_with_index.map { |modifier, i|
        modifier.new(modifiers[i] || {}) }
    end



    def valid?
      errors.none?
    end

    def errors
      [].tap do |errors|
        errors.push "#{direct_object_type} is blank" if direct_object_required? && direct_object.nil?
        errors.concat modifiers.flat_map(&:errors)
      end
    end

    def negative?
      @negative
    end



    def to_s
      @description ||= begin
        description = trait.to_s(@negative)
        description << " #{ValueMap.to_s(direct_object_type, direct_object)}" if direct_object_required?
        description << " #{modifiers.collect{|m| m.to_s(@negative)}.join(" ")}" unless modifiers.empty?
        description
      end
    end



    def perform(scope)
      @block.call(self, scope)
    end



  end
end
