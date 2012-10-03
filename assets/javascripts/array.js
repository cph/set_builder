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
