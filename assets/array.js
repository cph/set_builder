/*
      Extensions to core objects to provide Ruby-like idioms
      ===========================================================
*/


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

Array.prototype.each = function(fn) {
  for(i=0; i<this.length; i++) {
    fn(this[i]);
  }
}

Array.prototype.collect = function(fn) {
  var new_array = [];
  for(var i=0; i<this.length; i++) {
    new_array.push(fn(this[i]));
  }
  return new_array;
}

Array.prototype.inject = function(memo, fn) {
  for(var i=0; i<this.length; i++) {
    memo = fn(memo, this[i]);
  }
  return memo;
}

Array.prototype.find = function(fn) {
  for(var i=0; i<this.length; i++) {
    if(fn(this[i])) {
      return this[i];
    }
  }
  return null;
}