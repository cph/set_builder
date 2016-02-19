require "pry"

module SetBuilder
  module Modifier
    class Arguments
      attr_reader :arguments, :expression, :tokens

      def initialize(expression)
        @expression = expression.respond_to?(:each) ? map_legacy_arguments(expression) : expression
        @tokens = parse
      end

      def arity
        list.count
      end

      def list
        @types ||= @tokens
          .select { |token, _| token == :arg }
          .map { |_, type| type }
      end

      def as_json(*)
        tokens.map { |(token, value)| [token.to_s, value] }
      end

      def to_s(values)
        _values = values.dup
        tokens.map do |token, token_value|
          if token == :arg
            ValueMap.to_s(token_value, _values.shift)
          else
            token_value
          end
        end.join
      end

    private

      def map_legacy_arguments(arguments)
        _expression = arguments.map { |arg| "{#{arg}}" }.join(" ")
        puts "DEPRECATED: SetBuilder::Modifier should use expression style argumenents now e.g.-> \"#{_expression}\""
        _expression
      end

      def parse
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
        when :arg then lexeme[1...-1]
        when :enum then lexeme[1...-1].split("|")
        else lexeme
        end
      end

      LEXER = {
        arg:  /(\{[^\}]+\})/,
        enum: /(\[[^\]]+\])/
      }.freeze

    end
  end
end
