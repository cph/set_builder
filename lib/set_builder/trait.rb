require 'set_builder/constraint'
require 'set_builder/modifier'


module SetBuilder
  class Trait
    
    attr_reader :name, :parsed_expression, :part_of_speech, :modifiers, :direct_object_type
    
    LEXER = { 
      name: /("[^"]+")/,
      direct_object_type: /(:\w+)/,
      negative: /(\[[^\]]+\])/,
      modifier: /(<\w+>)/
    }.freeze
    
    def initialize(trait_expression, &block)
      @parsed_expression = parse(trait_expression)
      @__part_of_speech = parsed_expression.select { |token, value| token == :string }.first[1].split(' ').first.to_sym rescue nil
      @part_of_speech = get_part_of_speech(@__part_of_speech)
      @block = block
      @name = parsed_expression.select { |token, value| token == :name }.first[1]
      @direct_object_type = parsed_expression.select { |token, value| token == :direct_object_type }.first
      @direct_object_type = @direct_object_type ? @direct_object_type[1] : nil
      @modifiers = parsed_expression.select { |token, value| token == :modifier }.map { |_, modifier| Modifier[modifier.to_sym]  }
    end
    
    def requires_direct_object?
      !@direct_object_type.nil?
    end
    alias :direct_object_required? :requires_direct_object?

    def noun?
      (self.part_of_speech == :noun)
    end

    def to_s(negative=false)
      case part_of_speech
      when :active
        negative ? "who have not #{name}" : "who #{name}"
      when :perfect
        negative ? "who have not #{name}" : "who have #{name}"
      when :passive
        negative ? "who were not #{name}" : "who were #{name}"
      when :reflexive
        negative ? "who are not #{name}" : "who are #{name}"
      when :noun
        "whose #{name}"
      end
    end
    
    def to_json
      array = []
      array << (requires_direct_object? ? [name, @direct_object_type] : name)
      array << part_of_speech
      array << modifiers.collect{|klass| Modifier.name(klass)} unless modifiers.empty?
      array.to_json
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

    def get_part_of_speech(arg)
      case arg
      when :is, :are, :reflexive
        :reflexive
      when nil, :active
        :active
      when :was, :were, :passive
        :passive
      when :has, :have, :perfect
        :perfect
      when :whose, :noun
        :noun
      end
    end

  end
end
