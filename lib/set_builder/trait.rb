require 'set_builder/constraint'
require 'set_builder/modifier'


module SetBuilder
  class Trait

    attr_reader :name, :parsed_expression, :part_of_speech, :modifiers, :direct_object_type

    LEXER = {
      name: /("[^"]+")/,
      direct_object_type: /(:[\w\-\.]+)/,
      negative: /(\[[^\]]+\])/,
      modifier: /(<\w+>)/
    }.freeze

    def initialize(trait_expression, &block)
      @parsed_expression = parse(trait_expression)
      @name, @direct_object_type = find(:name), find(:direct_object_type)
      @block = block
      @modifiers = find_all(:modifier).map { |modifier| Modifier[modifier]  }
    end

    def requires_direct_object?
      !@direct_object_type.nil?
    end
    alias :direct_object_required? :requires_direct_object?

    def negative?
      find(:negative)
    end

    def to_s(negative=false)
      parsed_expression.reject do |token, _|
        [:modifier, :direct_object_type].include?(token) || (!negative && token == :negative)
      end.map do |token, value|
        token == :name ? name : value
      end.join(" ")
    end

    def find_all(token)
      parsed_expression.select { |(_token, _)| _token == token }.map { |(_, value)| value }
    end

    def find(token)
      find_all(token).first
    end

    def as_json(*)
      parsed_expression.map { |(token, value)| [token.to_s, value] }
    end

    def apply(*args)
      SetBuilder::Constraint.new(self, *args, &@block)
    end

  private

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

  end
end
