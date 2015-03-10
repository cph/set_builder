var SetBuilder = (function() {
  
  var _modifiers;
  var _traits;
  var _value_maps = {};
  
  return {
    init: function(traits, modifiers) {
      registerTraits(traits);
      registerModifiers(modifiers);
    },
    registerTraits: function(traits) {
      _traits = new SetBuilder.Traits(traits);
    },
    registerModifiers: function(modifiers) {
      _modifiers = new SetBuilder.Modifiers(modifiers);
    },
    registerValueMap: function(key, map) {
      _value_maps[key] = map;
    },
    registerValueMaps: function(_data) {
      for(key in _data) {
        _value_maps[key] = _data[key];
      }
    },    
    traits: function() {
      return _traits;
    },
    modifiers: function() {
      return _modifiers;
    },
    getValueMap: function(key) {
      return _value_maps[key];
    },
    getValue: function(key, value) {
      if(Object.prototype.toString.call(value) == '[object Array]') {
        var getValue = arguments.callee;
        var values = value.__collect(function(value) { return getValue(key, value) });
        switch(values.length) {
          case 0: return '';
          case 1: return values[0];
          case 2: return values[0] + ' or ' + values[1];
          default: return values.slice(0, -1).join(', ') + ', or ' + values[values.length - 1];
        }
      }
      
      var match = value.toString(),
          map = SetBuilder.getValueMap(key);
      if(map) {
        var pair = map.__find(function(i) { return (i[0] == match) });
        return pair ? pair[1] : '(unknown)';
      } else {
        return value;
      }
    },
    getValueMaps: function() {
      return Object.keys(_value_maps);
    }
  }
  
})();



/*
      Constraint (c.f. /lib/set_builder/constraint.rb)
      ===========================================================
      
      a constrained trait
*/

SetBuilder.Constraint = function(_trait, args) {
  
  var _direct_object;
  if(typeof(_trait) == 'string') {
    _trait = SetBuilder.traits().__find(_trait);
  }

  args = args.dup();
  if(_trait.requiresDirectObject()) _direct_object = args.shift();
  var _modifiers = _trait.modifiers().collect(function(modifier_type) {
    return SetBuilder.modifiers().apply(modifier_type, args.shift());
  });
  var _negative = false;
  
  
  
  // Public methods
  
  this.trait = function(val) {
    if(val !== undefined) {
      _trait = val;
      _direct_object = undefined;
      _modifiers = [];
    }
    return _trait;
  }
  
  this.direct_object = function(val) {
    if(val !== undefined) {
      _direct_object = val;
    }
    return _direct_object;
  }
  
  this.modifiers = function() {
    return _modifiers;
  }
  
  this.negate = function(value) {
    _negative = value;
    if(!_trait.hasNegative()) _negative = false;
    return this;
  }
  
  this.negative = function() {
    return _negative;
  }
  
  this.requires_direct_object = function() {
    return _trait.requires_direct_object();
  }
  
  this.toString = function() {
    var type, text, i = 0;
    return _trait.tokens().collect(function(token) {
      type = token[0], text = token[1];
      switch(type) {
        case 'string':
          return text;
        case 'name':
          return _trait.name();
        case 'negative':
          return _negative && text;
        case 'direct_object_type':
          return SetBuilder.getValue(text, _direct_object);
        case 'modifier':
          return _modifiers[i++].toString();
        default:
          if(console && console.log) console.log('[SetBuilder.Constraint] unknown type: "' + type + '" (text: "' + text + '")');
          return false;
      }
    }).compact().join(' ');
  }

};



/*
      Modifier (c.f. /lib/set_builder/modifier/base.rb)
      ===========================================================


*/

SetBuilder.Modifier = function(_name, _operator, _values, _params) {
  
  
  
  // Public methods
  
  this.name = function() {
    return _name;
  }
  
  this.operator = function() {
    return _operator;
  }
  
  this.values = function() {
    return _values;
  }
  
  this.toString = function() {
    var words = [_operator.replace(/_/, ' ')];
    for(var i=0; i<_values.length; i++) {
      words.push(SetBuilder.getValue(_params[i], _values[i]));
    }
    return words.join(' ');
  }

};



/*
      Modifiers (c.f. /lib/set_builder/modifier.rb)
      ===========================================================
      
      [
        [modifier_name, {
          operator: ['argument 1 type', 'argument 2 type'],
          another_operator: ['argument 1 type'],
          yet_another_operator: []
        }]
      ]
*/

SetBuilder.Modifiers = function(_modifiers) {
  
  var keys = Object.keys(_modifiers);
  
  function _operators_for(name) {
    var operators = _modifiers[name];
    if(operators) {
      return operators;
    } else {
      throw ('"' + name.toString() + '" is not a registered modifier.');
    }
  }
  
  
  
  // Public methods
  this.length = function() {
    return keys.length;
  }
  
  // Returns the names of the operators allowed for the given modifier
  this.operators_for = function(modifier_type) {
    return Object.keys(_operators_for(modifier_type));
  }
  
  // Returns the names of the arguments a given operator anticipates
  this.params_for_operator = function(modifier_type, operator_name) {
    if(!operator_name) throw 'An operator name was not supplied.'
    var params = _operators_for(modifier_type)[operator_name];
    if(params) {
      return params;
    } else {
      throw ('"' + operator_name.toString() + '" is not an operator for the ' + modifier_type + ' modifier.');
    }
  }
  
  // Examples of Usage:
  //
  // An operator that takes one argument:
  //   apply('date', {'before': ['2012-11-12']})
  //
  // An operator that takes two arguments:
  //   apply('date', {'in_the_last': [5, 'days']})
  //
  //
  // `args` is expected to be an object that has one key and one value.
  //
  this.apply = function(modifier_type, args) {
    args = args || {};
    var operator = Object.keys(args)[0];
    if(!operator) throw 'An operator name was not supplied.'
    
    var params = this.params_for_operator(modifier_type, operator);
    var values = (args)[operator];

    if(!(values instanceof Array)) values = [values];
    if(values.length != params.length) {
      throw ('The operator "' + operator.toString() + '" expects ' + params.length + ' arguments but received ' + values.length + '.');
    }
    
    return new SetBuilder.Modifier(name, operator, values, params);
  }

};



/*
      Set (c.f. /lib/set_builder/set.rb)
      ===========================================================
      
      a set of constrained traits that describe a group
*/

SetBuilder.Set = function(_raw_data) {
  if(!_raw_data) _raw_data = [];
  
  var _constraints = [];
  _raw_data.__each(function(line) {
    var trait_name = line[0];
    var negative = false;
    if(trait_name[0] == '!') {
      negative = true;
      trait_name = trait_name.slice(1);
    }
    var trait = SetBuilder.traits().__find(trait_name);
    var args = line.slice(1);
    if(trait) {
      _constraints.push(trait.apply(args).negate(negative));
    } else if(window.console && window.console.log) {
      window.console.log('trait not found with name "' + line[0] + '"');
    }
  });
  
  
  
  // Public methods
  
  this.data = function() {
    
    // TODO: write the data structure from constraints!
    
  }
  
  this.constraints = function() {
    return _constraints;
  }
  
  this.toString = function() {
    return this.constraints().toSentence();
  }
  
};



/*
      Trait (c.f. /lib/set_builder/trait/base.rb)
      ===========================================================
      
      an individual trait that can be constrained
*/

SetBuilder.Trait = function(_tokens) {
  
  var type, text;
  var _name, _modifiers = [], _direct_object_type, _negative;
  _tokens.each(function(token) {
    type = token[0], text = token[1];
    switch(type) {
      case 'name':
        _name = text;
        break;
      case 'modifier':
        _modifiers.push(text);
        break;
      case 'direct_object_type':
        _direct_object_type = text;
        break;
      case 'negative':
        _negative = text;
        break;
    }
  });
  
  
  // Public methods
  
  this.requiresDirectObject = function() {
    return !!_direct_object_type;
  }
  
  this.direct_object_type = function() {
    return _direct_object_type;
  }
  
  this.name = function() {
    return _name;
  }
  
  this.hasNegative = function() {
    return !!_negative;
  }
  
  this.modifiers = function() {
    return _modifiers;
  }
  
  this.tokens = function() {
    return _tokens;
  }

  this.apply = function(args) {
    return new SetBuilder.Constraint(this, args);
  }

};



/*
      Traits (c.f. /lib/set_builder/traits.rb)
      ===========================================================

      a collection of traits that allows fetching by name
*/

SetBuilder.Traits = function(_raw_data) {
  
  var _traits = _raw_data.collect(function(line) {
    return new SetBuilder.Trait(line);
  });
  
  
  // Public methods
  
  this.length = function() {
    return _traits.length;
  }
  
  this.names = function() {
    return _traits.collect(function(trait) {
      return trait.name();
    });
  }
  
  this.__find = function(name) {
    return _traits.__find(function(trait) {
      return (trait.name() == name);
    });
  }

};





/*
      Extensions to core objects to provide Ruby-like idioms
      ===========================================================
*/

if(!Object.keys) {
  Object.keys = function(o) {
    var keys = [];
    for(key in o) {
      keys.push(key);
    }
    return keys;  
  }
}



//
// .toSentence
//
if(!Array.prototype.toSentence) {
  Array.prototype.toSentence = function() {
    switch(this.length) {
      case 0:
        return '';
      case 1:
        return this[0].toString();
      case 2:
        return this[0].toString() + ' and ' + this[1].toString();
      default:
        return this.slice(0, -1).join(', ') + ', and ' + this[this.length - 1].toString();
    }
  }
}



//
// .dup
//
Array.prototype.__dup = function(fn) {
  return this.slice(0);
}
if(!Array.prototype.dup) Array.prototype.dup = Array.prototype.__dup;



//
// .each
// Distinct from Prototype's each which catches exceptions (ew!)
// so that if Prototype defines each, I can still call __each
//
Array.prototype.__each = function(fn) {
  for(var i=0, len=this.length; i<len; i++) {
    fn(this[i], i);
  }
}
if(!Array.prototype.each) Array.prototype.each = Array.prototype.__each;



//
// .collect
//
Array.prototype.__collect = function(fn) {
  var new_array = [];
  for(var i=0; i<this.length; i++) {
    new_array.push(fn(this[i]));
  }
  return new_array;
}
if(!Array.prototype.collect) Array.prototype.collect = Array.prototype.__collect;



//
// .inject
//
Array.prototype.__inject = function(memo, fn) {
  for(var i=0; i<this.length; i++) {
    memo = fn(memo, this[i]);
  }
  return memo;
}
if(!Array.prototype.inject) Array.prototype.inject = Array.prototype.__inject;



//
// .compact
//
Array.prototype.__compact = function() {
  var new_array = [];
  for(var i=0; i<this.length; i++) {
    if(this[i]) {
      new_array.push(this[i]);
    }
  }
  return new_array;
}
if(!Array.prototype.compact) Array.prototype.compact = Array.prototype.__compact;



//
// .find
//
Array.prototype.__find = function(fn) {
  for(var i=0; i<this.length; i++) {
    if(fn(this[i])) {
      return this[i];
    }
  }
  return null;
}
if(!Array.prototype.find) Array.prototype.find = Array.prototype.__find;

//
// .select
//
Array.prototype.__select = function(fn) {
  var results = [];
  for(var i=0; i<this.length; i++) {
    if(fn(this[i])) {
      results.push(this[i]);
    }
  }
  return results;
}
if(!Array.prototype.select) Array.prototype.select = Array.prototype.__select;
