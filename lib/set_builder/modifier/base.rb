module SetBuilder
  module Modifier
    class Base
      
      
      
      def initialize(hash)
        @operator, @values = (hash.is_a?(Hash) ? [hash.first[0].to_sym, hash.first[1]] : [nil, nil])
        @values ||= []
        @values = [@values] unless @values.is_a?(Array)
      end
      
      
      
      attr_reader :operator, :values
      
      
      
      def valid?
        valid_operator?(self.operator) && valid_arguments?(self.values)
      end
      
      
      
      def valid_operator?(operator)
        !operator.nil? && self.class.operators.key?(operator)
      end
      
      
      
      def valid_arguments?(values)
        argument_types = self.class.operators[operator] || []
        return false unless (values.length == argument_types.length)
        values.each_with_index do |value, i|
          return false unless valid_argument_of_type?(value, argument_types[i])
        end
        true
      end
      
      
      
      def valid_argument_of_type?(argument, type)
        validator = "valid_#{type}_argument?"
        if respond_to?(validator)
          send(validator, argument)
        else
          true
        end
      end
      
      
      
      def valid_date_argument?(string)
        begin
          Date.parse(string)
          true
        rescue
          false
        end
      end
      
      
      
      def to_s(negative=false)
        words = negative ? [self.class.negate(operator).to_s.gsub(/_/, " ")] : [operator.to_s.gsub(/_/, " ")]
        arguments = self.class.operators[operator] || []
        (0...arguments.length).each do |i|
          # p "ValueMap.to_s(#{arguments[i]} (#{arguments[i].class}), #{values[i]} (#{values[i].class})): #{ValueMap.to_s(arguments[i], values[i])}"
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