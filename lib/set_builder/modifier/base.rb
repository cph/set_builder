module SetBuilder
  module Modifier
    class Base
      attr_reader :operator, :values



      def initialize(params)
        params.symbolize_keys!
        @operator = params[:operator]
        @operator = @operator.to_sym if @operator
        @values = Array(params[:values])
      end



      def value
        values[0]
      end



      def valid?
        errors.none?
      end

      def errors
        [].tap do |errors|
          errors.concat errors_with_operator
          errors.concat errors_with_values
        end
      end

      def errors_with_operator
        [].tap do |errors|
          if operator.blank?
            errors.push "operator is blank"
          else
            errors.push "#{operator.inspect} is not recognized. It should be #{self.class.operators.keys.to_sentence(two_words_connector: " or ", last_word_connector: ", or ")}" unless self.class.operators.key?(operator)
          end
        end
      end

      def errors_with_values
        [].tap do |errors|
          types = self.class.operators[operator] || []
          if values.length != types.length
            errors.push "wrong number of arguments; expected #{types.length} (#{types.join(", ")})"
          else
            errors.concat values.each_with_index.flat_map { |value, i| errors_with_value_type(value, types[i]) }
          end
        end
      end

      def errors_with_value_type(value, type)
        validator = "errors_with_#{type}_value"
        if respond_to?(validator)
          Array(public_send(validator, value)).compact
        else
          []
        end
      end



      def errors_with_date_value(string)
        return "date is blank" if string.to_s.blank?
        Date.parse(string.to_s)
        nil
      rescue
        "#{string.inspect} is not a valid date"
      end

      def errors_with_number_value(string)
        return "number is blank" if string.to_s.blank?
        "#{string.inspect} is not a valid number" unless string.to_s =~ /\A\d+\Z/
      end



      def to_s(negative=false)
        words = negative ? [self.class.negate(operator).to_s.gsub(/_/, " ")] : [operator.to_s.gsub(/_/, " ")]
        arguments = self.class.operators[operator] || []
        (0...arguments.length).each do |i|
          words << ValueMap.to_s(arguments[i], values[i])
        end
        words.join(" ")
      end



      def self.negate(operator)
        operator
      end



      def self.to_hash
        hash = {}
        operators.each do |operator, array|
          hash[operator.to_s] = array.map {|type| type.to_s }
        end
        hash
      end



      def self.to_json
        to_hash.to_json
      end



    end
  end
end
