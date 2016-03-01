require "set_builder/parser"

module SetBuilder
  module Modifier
    class Arguments
      attr_reader :arguments, :expression, :tokens

      include Parser

      def initialize(expression)
        @expression = expression.respond_to?(:each) ? map_legacy_arguments(expression) : expression
        @tokens = parse(@expression)
      end

      def arity
        types.count
      end

      def types
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

    end
  end
end
