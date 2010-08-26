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
      (map ? map[value] : value).to_s
    end
    
    
    
    def self.for(name)
      name = name.to_sym
      @registered_value_maps[name] || raise(ArgumentError, "A value map has not been registered for #{value}")
    end
    
    
    
    def self.register(name, map, name_method = :name, id_method = :id)
      name = name.to_sym
      if map.is_a?(Array)
        map = map.inject({}){|hash, i| hash[i.send(id_method).to_s] = i.send(name_method); hash}
      end
      @registered_value_maps[name] = map
    end
    
    
    
    def self.to_json
      @registered_value_maps.to_json
    end
    
    
    
  end
  
  
  
end