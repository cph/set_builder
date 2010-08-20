var SetBuilder = (function() {
  
  var _modifiers;
  var _traits;
  
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
    traits: function() {
      return _traits;
    },
    modifiers: function() {
      return _modifiers;
    }
  }
  
})();



/*
      Constraint (c.f. /lib/set_builder/constraint.rb)
      ===========================================================
      
      a constrained trait
*/

SetBuilder.Constraint = function(_trait, args) {

  args = args.dup();
  var _direct_object;
  if(_trait.requires_direct_object()) _direct_object = args.shift();
  var _modifiers = _trait.modifiers().collect(function(modifier_type) {
    return SetBuilder.modifiers().apply(modifier_type, args.shift());
  });
  var _description;
  
  
  
  // Public methods
  
  this.trait = function() {
    return _trait;
  }
  
  this.direct_object = function() {
    return _direct_object;
  }
  
  this.modifiers = function() {
    return _modifiers;
  }
  
  this.requires_direct_object = function() {
    return _trait.requires_direct_object();
  }
  
  this.toString = function() {
    if(!_description) {
      _description = _trait.toString();
      if(_direct_object) {
        _description += ' ' + _direct_object
      }
      _modifiers.each(function(modifier) {
        _description += ' ' + modifier.toString();
      });
    }
    return _description;
  }

}



/*
      Modifier (c.f. /lib/set_builder/modifier/base.rb)
      ===========================================================


*/

SetBuilder.Modifier = function(_name, _operator, _values) {
  
  
  
  // Public methods
  
  this.name = function() {
    return _name;
  }
  
  this.operators = function() {
    return _operators;
  }
  
  this.values = function() {
    return _values;
  }
  
  this.toString = function() {
    return _operator + ' ' + _values.toSentence();
  }

}



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
  this.operators_for = function(name) {
    return Object.keys(_operators_for(name));
  }
  
  // Returns the names of the arguments a given operator anticipates
  this.params_for_operator = function(name, operator_name) {
    var params = _operators_for(name)[operator_name];
    if(params) {
      return params;
    } else {
      throw ('"' + operator.toString() + '" is not an operator for the ' + name + ' modifier.');
    }
  }
  
  this.apply = function(name, args) {
    var operator = Object.keys(args)[0];
    var params = this.params_for_operator(name, operator);
    var values = (args||{})[operator];

    if(!(values instanceof Array)) values = [values];
    if(values.length != params.length) throw ('The operator "' + operator.toString() + '" expects ' + params.length + ' arguments.');
    
    return new SetBuilder.Modifier(name, operator, values);
  }

}



/*
      Set (c.f. /lib/set_builder/set.rb)
      ===========================================================
      
      a set of constrained traits that describe a group
*/

SetBuilder.Set = function(_raw_data) {
  
  if(!_raw_data) _raw_data = [];
  // if(!_traits) _traits = SetBuilder.traits();

  var _constraints = [];
  _raw_data.each(function(line) {
    var trait = SetBuilder.traits().find(line[0]);
    var args = line.slice(1);
    if(trait) {
      _constraints.push(trait.apply(args));
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
  
}



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
  var _modifiers = _raw_data.slice(2); // .collect(function(modifier_name) {
  //     return SetBuilder.Modifiers.find(modifier_name);
  //   });
  var _direct_object;
  
  if(typeof(_name) != 'string') {
    _direct_object = _name[1];
    _name = _name[0];
  }
  
  
  
  // Public methods
  
  this.requires_direct_object = function() {
    return !!_direct_object;
  }
  
  this.name = function() {
    return _name;
  }
  
  this.modifiers = function() {
    return _modifiers;
  }
  
  this.prefix = function() {
    switch(_part_of_speech) {
      case 'active':
        return 'who';
      case 'perfect':
        return 'who have';
      case 'passive':
        return 'who were';
      case 'reflexive':
        return 'who are';
      case 'noun':
        return 'whose';
      default:
        return undefined;
    }    
  }
   
  this.toString = function() {
    var prefix = this.prefix();
    if(prefix) {
      return prefix + ' ' + this.name();
    } else {
      return '';
    }
  }

  this.apply = function(args) {
    return new SetBuilder.Constraint(this, args);
  }

}



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
  
  this.find = function(name) {
    return _traits.find(function(trait) {
      return (trait.name() == name);
    });
  }

}
