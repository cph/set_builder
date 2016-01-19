require "set_builder/constraint"
require "set_builder/modifier"


module SetBuilder
  class Trait
    attr_reader :expression, :tokens, :name, :modifiers, :direct_object_type, :negative



    def initialize(expression, &block)
      @expression = expression
      @tokens = parse(expression)
      @block = block

      names = find_all(:name)
      raise ArgumentError, "A trait must be defined with a name" if names.none?
      raise ArgumentError, "A trait must be defined with only one name" if names.length > 1
      @name = names[0]

      direct_object_types = find_all(:direct_object_type)
      raise ArgumentError, "A trait may define only one direct object" if direct_object_types.length > 1
      @direct_object_type = direct_object_types[0].to_sym if direct_object_types[0]

      @negative = find(:negative)
      @modifiers = find_all(:modifier).map { |modifier_type| Modifier[modifier_type] }
    end



    def requires_direct_object?
      !@direct_object_type.nil?
    end
    alias :direct_object_required? :requires_direct_object?

    def negatable?
      negative.present?
    end



    def to_s(negative=false)
      parsed_expression.reject do |token, _|
        [:modifier, :direct_object_type].include?(token) || (!negative && token == :negative)
      end.map do |token, value|
        token == :name ? name : value
      end.join(" ")
    end

    def as_json(*)
      tokens.map { |(token, value)| [token.to_s, value] }
    end

    def apply(constraint)
      SetBuilder::Constraint.new(self, constraint, &@block)
    end



  private



    def find_all(token)
      tokens.select { |(_token, _)| _token == token }.map { |(_, value)| value }
    end

    def find(token)
      find_all(token).first
    end



    def parse(trait_definition)
      regex = Regexp.union(LEXER.values)
      trait_definition.split(regex).map do |lexeme|
        [token_for(lexeme), value_for(lexeme)] unless lexeme.strip.empty?
      end.compact
    end

    def token_for(lexeme)
      LEXER.each { |token, pattern| return token if pattern.match(lexeme) }
      return :string
    end

    def value_for(lexeme)
      lexeme.to_s.strip.gsub(/[<>"\[\]:]/, "")
    end

    LEXER = {
      name: /("[^"]+")/,
      direct_object_type: /(:[\w\-\.]+)/,
      negative: /(\[[^\]]+\])/,
      modifier: /(<\w+>)/
    }.freeze



  end
end
