module SetBuilder
  module Modifier
    class Base
      
      
      
      def initialize(hash)
        @operator, @values = (hash.is_a?(Hash) ? [hash.first[0].to_sym, hash.first[1]] : [nil, nil])
        @values = [] if @values.nil?
        @values = [@values] unless @values.is_a?(Array)
      end
      
      
      
      attr_reader :operator, :values
      
      
      
      def valid?
        !operator.nil? and 
        (arguments = self.class.operators[operator]) and 
        !arguments.nil? and
        (arguments.length == values.length)
      end
      
      
      
      def to_s(negative=false)
        words = negative ? [self.class.negate(operator).to_s.gsub(/_/, " ")] : [operator.to_s.gsub(/_/, " ")]
        arguments = self.class.operators[operator]
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