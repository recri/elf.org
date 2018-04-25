//
// implement missing methods of Array
//
// pop() - nn 4
// push() - nn 4
// shift() - nn 4
// splice() - nn 4
// unshift() - nn 4
//
if (Array.prototype.pop == null) Array.prototype.pop = function() {
  var pop = this[this.length-1];
  this.length -= 1;
  return pop;
}
if (Array.prototype.push == null) Array.prototype.push = function() {
  var an = arguments.length, tn = this.length
    for (var i = 0; i < an; i += 1) this[tn+i] = arguments[i];
  return this.length;
}
if (Array.prototype.shift == null ) Array.prototype.shift = function() {
  for (var i = 1; i < this.length; i += 1) this[i-1] = this[i];
  return --this.length;
}
if (Array.prototype.splice == null) Array.prototype.splice = function(start, deleteCount, value) {
  var ret = new Array();
  for (var i = start; i < this.length-deleteCount; i += 1) {
	if (i < start+deleteCount) {
      ret[i-start] = this[i];
	}
	this[i] = this[i+deleteCount];
  }
  var insertCount = arguments.length-2;
  if (insertCount) {
	for (i = this.length-deleteCount-insertCount-1; i >= start; i -= 1) {
      this[i+insertCount] = this[i];
      this[i] = arguments[i-start+2];
	}
  }
  if (insertCount-deleteCount != 0) this.length += insertCount-deleteCount;
  return ret;
}
if (Array.prototype.unshift == null) Array.prototype.unshift = function() {
  var n = arguments.length;
  for (var i = this.length+n-1; i > 0; i -= 1) this[i] = this[i-n];
  for (i = 0; i < n; i += 1) this[i] = arguments[i];
  return this.length;
}
