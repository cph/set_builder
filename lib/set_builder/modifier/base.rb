module SetBuilder
  module Modifier
    class Base
      
      
      
      def initialize(hash)
        @operator, @values = hash.first[0].to_sym, hash.first[1]
        @values = [@values] unless @values.is_a?(Array)
      end
      
      
      
      attr_reader :operator, :values
      
      
      
      def valid?
        arguments = self.class.operators[operator]
        !arguments.nil? and (arguments.length == values.length)
      end
      
      
      
      def to_s
        "#{operator} #{values.to_sentence}"
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