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
    
    
    
    def self.register(name, map)
      name = name.to_sym
      @registered_value_maps[name] = map
    end
    
    
    
  end
  
  
  
end