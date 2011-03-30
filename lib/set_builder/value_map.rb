module SetBuilder
  module ValueMap
    
    
    
    @registered_value_maps = {}
    
    
    
    def self.registered?(name)
      name = name.to_sym
      @registered_value_maps.key?(name)
    end
    
    
    
    def self.to_s(name, value)
      name = name.to_sym
      map = @registered_value_maps[name]
      if map
        pair = map.find {|pair| pair[0] == value}
        pair ? pair[1].to_s : "(unknown)"
      else
        value.to_s
      end
    end
    
    
    
    def self.for(name)
      name = name.to_sym
      @registered_value_maps[name] || raise(ArgumentError, "A value map has not been registered for #{value}")
    end
    
    
    
    def self.register_collection(name, collection, name_method = :name, id_method = :id)
      map = collection.map {|i| [i.send(id_method).to_s, i.send(name_method)]}
      register(name, map)
    end
    
    
    
    def self.register(name, map)
      raise "map is expected to be an array of pairs" unless map.is_a?(Array)
      name = name.to_sym
      @registered_value_maps[name] = map
    end
    
    
    
    def self.to_json
      @registered_value_maps.to_json
    end
    
    
    
  end
  
  
  
end