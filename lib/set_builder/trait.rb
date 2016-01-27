require "set_builder/constraint"
require "set_builder/modifier"


module SetBuilder
  class Trait
    attr_reader :expression, :tokens, :name, :modifiers, :direct_object_type, :enums



    def initialize(expression, &block)
      @expression = expression.to_s.strip
      @tokens = parse(expression)
      @block = block

      names = find_all(:name)
      raise ArgumentError, "A trait must be defined with a name" if names.none?
      raise ArgumentError, "A trait must be defined with only one name" if names.length > 1
      @name = names[0]

      direct_object_types = find_all(:direct_object_type)
      raise ArgumentError, "A trait may define only one direct object" if direct_object_types.length > 1
      @direct_object_type = direct_object_types[0].to_sym if direct_object_types[0]

      @enums = find_all(:enum)
      raise ArgumentError, "An enum must define more than one option" if enums.any? { |options| options.length < 2 }

      @modifiers = find_all(:modifier).map { |modifier_type| Modifier[modifier_type] }
    end



    def requires_direct_object?
      !@direct_object_type.nil?
    end
    alias :direct_object_required? :requires_direct_object?



    def to_s
      expression
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



    def parse(expression)
      tokenizer = Regexp.union(LEXER.values)
      expression.split(tokenizer).each_with_object([]) do |lexeme, output|
        next if lexeme.empty?
        token = token_for(lexeme)
        output.push [token, value_for(token, lexeme)]
      end
    end

    def token_for(lexeme)
      LEXER.each { |token, pattern| return token if pattern.match(lexeme) }
      :string
    end

    def value_for(token, lexeme)
      case token
      when :name then lexeme[1...-1]
      when :enum then lexeme[1...-1].split("|")
      when :modifier then lexeme[1...-1]
      when :direct_object_type then lexeme[1..-1]
      else lexeme
      end
    end

    LEXER = {
      name: /("[^"]+")/,
      direct_object_type: /(:[\w\-\.]+)/,
      enum: /(\[[^\]]+\])/,
      modifier: /(<\w+>)/
    }.freeze



  end
end
