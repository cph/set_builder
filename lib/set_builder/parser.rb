module SetBuilder
  module Parser

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
      when :name, :modifier, :arg then lexeme[1...-1]
      when :enum then lexeme[1...-1].split("|")
      when :direct_object_type then lexeme[1..-1]
      else lexeme
      end
    end

    LEXER = {
      name: /("[^"]+")/,
      direct_object_type: /(:[\w\-\.]+)/,
      enum: /(\[[^\]]+\])/,
      modifier: /(<\w+>)/,
      arg:  /(\{[^\}]+\})/
    }.freeze

  end
end
