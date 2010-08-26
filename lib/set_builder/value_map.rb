module SetBuilder
  module ValueMap
    
    
    
    @registered_value_maps = {}
    
    
    
    def self.registered?(value)
      @registered_value_maps.key?(value)
    end
    
    
    
    def self.to_s(name, value)
      map = @registered_value_maps[name]
      (map ? map[value] : value).to_s
    end
    
    
    
    def self.value_map_for(value)
      @registered_value_maps[value] || raise(ArgumentError, "A value map has not been registered for #{value}")
    end
    
    
    
    def self.register(value, map)
      @registered_value_maps[value] = map
    end
    
    
    
  end
  
  
  
end