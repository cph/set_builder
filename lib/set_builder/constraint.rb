require "set_builder/modifier"


module SetBuilder
  class Constraint
    attr_reader :trait, :params, :direct_object, :enums, :modifiers
    delegate :direct_object_required?,
             :direct_object_type,
             :to => :trait



    #
    # Sample constraints:
    #
    #     { trait: :awesome }
    #     { trait: :attended, school: 2 }
    #     { trait: :died, enums: ["have not"] }
    #     { trait: :name, modifiers: [{ operator: :is, values: ["Jerome"] }] }
    #
    def initialize(trait, params, &block)
      @trait, @block = trait, block
      @params = params

      @direct_object = params[direct_object_type] if trait.requires_direct_object?
      @enums = params[:enums] || []
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
        if enums.length != trait.enums.length
          errors.push "should have values for #{trait.enums.length} enums"
        else
          trait.enums.each_with_index do |expected_values, i|
            errors.push "enum ##{i + 1} should be #{expected_values.map { |value| "'#{value}'" }.to_sentence(two_words_connector: " or ", last_word_connector: ", or ")}" unless expected_values.member?(enums[i])
          end
        end
        errors.concat modifiers.flat_map(&:errors)
      end
    end



    def to_s
      @description ||= stringify(trait.tokens)
    end



    def perform(scope)
      @block.call(self, scope)
    end



  private

    def stringify(tokens)
      enum_index = 0
      modifier_index = 0
      tokens.map do |token, value|
        case token
        when :string then value
        when :name then trait.name
        when :enum then enums[enum_index].to_s.tap { enum_index += 1 }
        when :direct_object_type then ValueMap.to_s(value, direct_object)
        when :modifier then modifiers[modifier_index].to_s.tap { modifier_index += 1 }
        else raise NotImplementedError, "Unrecognized token type #{token.inspect}"
        end
      end.join
    end

  end
end
