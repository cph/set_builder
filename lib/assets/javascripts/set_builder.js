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
      var match = value.toString(),
          map = SetBuilder.getValueMap(key);
      if(map) {
        var pair = map.__find(function(i) { return (i[0] == match) });
        return pair ? pair[1] : '(unknown)';
      } else {
        return value;
      }
      // map = _value_maps[key];
      // return map ? map[value.toString()] : value;
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
  if(_trait.requires_direct_object()) _direct_object = args.shift();
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
    if(_trait.noun()) _negative = false;
    return this;
  }
  
  this.negative = function() {
    return _negative;
  }
  
  this.requires_direct_object = function() {
    return _trait.requires_direct_object();
  }
  
  this.prefix = function() {
    return _trait.prefix(_negative);
  }
  
  this.toString = function(include_prefix) {
    var _description = _trait.toString(include_prefix, _negative);
    if(_direct_object) {
      _description += ' ' + SetBuilder.getValue(_trait.direct_object_type(), _direct_object);
    }
    _modifiers.__each(function(modifier) {
      _description += ' ' + modifier.toString(_negative);
    });
    return _description;
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
  
  this.toString = function(negative) {
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

SetBuilder.Trait = function(_raw_data) {

  // window.console.log('new SetBuilder.Trait()');
  // window.console.log(_raw_data);
  var _name = _raw_data[0];
  var _part_of_speech = _raw_data[1].toString().toLowerCase();
  var _modifiers = _raw_data[2] || []; //.collect(function(modifier_name) {
  //     return SetBuilder.Modifiers.__find(modifier_name);
  //   });
  var _direct_object_type;
  
  if(typeof(_name) != 'string') {
    _direct_object_type = _name[1];
    _name = _name[0];
  }
  
  
  
  // Public methods
  
  this.requires_direct_object = function() {
    return !!_direct_object_type;
  }
  
  this.direct_object_type = function() {
    return _direct_object_type;
  }
  
  this.name = function() {
    return _name;
  }
  
  this.noun = function() {
    return (_part_of_speech == 'noun');
  }
  
  this.modifiers = function() {
    return _modifiers;
  }
  
  this.prefix = function(negative) {
    if(negative === undefined) negative = false;
    switch(_part_of_speech) {
      case 'active':
        return negative ? 'who have not' : 'who';
      case 'perfect':
        return negative ? 'who have not' : 'who have';
      case 'passive':
        return negative ? 'who were not' : 'who were';
      case 'reflexive':
        return negative ? 'who are not' : 'who are';
      case 'noun':
        return 'whose';
      default:
        return undefined;
    }
  }
   
  this.toString = function(include_prefix, negative) {
    var prefix = this.prefix(negative);
    if(prefix) { // return an empty string if the prefix is invalid
      return (include_prefix==false) ? this.name() : (prefix + ' ' + this.name());
    } else {
      return '';
    }
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
