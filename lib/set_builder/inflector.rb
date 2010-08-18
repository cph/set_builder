module SetBuilder
  module Inflector


    def self.singular(part_of_speech, name)
      case part_of_speech
      when :active
        "who #{name}"
      when :perfect
        "who has #{name}"
      when :passive
        "who was #{name}"
      when :reflexive
        "who is #{name}"
      when :noun
        "whose #{name}"
      end
    end


    def self.plural(part_of_speech, name)
      case part_of_speech
      when :active
        "who #{name}"
      when :perfect
        "who have #{name}"
      when :passive
        "who were #{name}"
      when :reflexive
        "who are #{name}"
      when :noun
        "whose #{name}"
      end
    end


  end
end