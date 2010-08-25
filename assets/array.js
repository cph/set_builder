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
if(!Array.prototype.dup) {
  Array.prototype.dup = function(fn) {
    return this.slice(0);
  }
}

// Array.each = function(array, fn) {
//   for(i=0, len=array.length; i<len; i++) {
//     fn(array[i]);
//   }
// }

if(!Array.prototype.each) {
  Array.prototype.each = function(fn) {
    for(i=0, len=this.length; i<len; i++) {
      fn(this[i]);
    }
  }
}

// Array.collect = function(array, fn) {
//   var new_array = [];
//   for(var i=0; i<array.length; i++) {
//     new_array.push(fn(array[i]));
//   }
//   return new_array;
// }

if(!Array.prototype.collect) {
  Array.prototype.collect = function(fn) {
    var new_array = [];
    for(var i=0; i<this.length; i++) {
      new_array.push(fn(this[i]));
    }
    return new_array;
  }
}

if(!Array.prototype.inject) {
  Array.prototype.inject = function(memo, fn) {
    for(var i=0; i<this.length; i++) {
      memo = fn(memo, this[i]);
    }
    return memo;
  }
}

if(!Array.prototype.find) {
  Array.prototype.find = function(fn) {
    for(var i=0; i<this.length; i++) {
      if(fn(this[i])) {
        return this[i];
      }
    }
    return null;
  }
}
