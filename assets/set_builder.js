
var SetBuilder = (function() {
  
  function SetConstructor(data) {
    this._data = data;
  }
  
  SetConstructor.prototype.data = function() {
    return this._data;
  }
  
  
  
  
  return {
    Set: SetConstructor
  }
  
})()
