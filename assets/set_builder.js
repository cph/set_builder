/*
      Extensions to core objects to provide Ruby-like idioms
      ===========================================================
*/


Array.prototype.toSentence = function() {
  switch(this.length) {
    case 0:
      return '';
    case 1:
      return this[0];
    case 2:
      return this[0].toString() + ' and ' + this[1].toString();
    default:
      return this.slice(0, -1).join(', ') + ', and ' + this[this.length - 1].toString();
  }
}

Array.prototype.each = function(fn) {
  for(i=0; i<this.length; i++) {
    fn(this[i]);
  }
}

Array.prototype.collect = function(fn) {
  var new_array = [];
  for(i=0; i<this.length; i++) {
    new_array.push(fn(this[i]));
  }
  return new_array;
}

Array.prototype.inject = function(memo, fn) {
  for(i=0; i<this.length; i++) {
    memo = fn(memo, this[i]);
  }
  return memo;
}

Array.prototype.find = function(fn) {
  for(i=0; i<this.length; i++) {
    if(fn(this[i])) {
      return this[i];
    }
  }
  return null;
}


/*
      The SetBuilder namespace
      ===========================================================
*/

var SetBuilder; if(!SetBuilder) SetBuilder={};



/*
      Constraint (c.f. /lib/set_builder/constraint.rb)
      ===========================================================
      
      a constrained trait
*/

SetBuilder.Constraint = function(_trait, args) {

  var _direct_object;
  if(_trait.requires_direct_object) {
    _direct_object = args.shift();
  }
  var _modifiers = []; // TODO
  var _description;
  
  
  
  // Public methods
  
  this.trait = function() {
    return _trait;
  }
  
  this.direct_object = function() {
    return _direct_object;
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
      // description << " #{modifiers.join(" ")}" unless modifiers.empty?
    }
    return _description;
  }

}



/*
      Set (c.f. /lib/set_builder/set.rb)
      ===========================================================
      
      a set of constrained traits that describe a group
*/

SetBuilder.Set = function(_traits, _raw_data) {
  
  if(!_raw_data) _raw_data = [];
  var _constraints = _raw_data.inject([], function(constraints, line) {
    var args = line.slice(1, -1);
    var trait = _traits.find(line[0]);
    if(trait) {
      constraints.push(trait.apply(args))
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

  var _name = _raw_data.shift();
  var _part_of_speech = _raw_data.shift().toString().toLowerCase();
  var _modifiers = _raw_data.shift();
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
   
  this.toString = function() {
    switch(_part_of_speech) {
      case 'active':
        return 'who ' + this.name();
      case 'perfect':
        return 'who have ' + this.name();
      case 'passive':
        return 'who were ' + this.name();
      case 'reflexive':
        return 'who are ' + this.name();
      case 'noun':
        return 'whose ' + this.name();
      default:
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
  
  this.find = function(name) {
    return _traits.find(function(trait) {
      return (trait.name() == name);
    });
  }

}

// SetBuilder.Traits.prototype = new Array();
// SetBuilder.Traits.constructor = SetBuilder.Traits;

