// Vectors or Points
function Vector(x, y, z) { this[0] = x; this[1] = y; this[2] = z; }
Vector.x = new Vector(1,0,0);
Vector.y = new Vector(0,1,0);
Vector.z = new Vector(0,0,1);
Vector.prototype.neg = function() { return new Vector(-this[0], -this[1], -this[2]); }
Vector.prototype.add = function(u) { return new Vector(this[0]+u[0], this[1]+u[1], this[2]+u[2]); }
Vector.prototype.sub = function(u) { return new Vector(this[0]-u[0], this[1]-u[1], this[2]-u[2]); }
Vector.prototype.scale = function(s) { return new Vector(s*this[0], s*this[1], s*this[2]); }
Vector.prototype.dot = function(u) { return this[0]*u[0]+this[1]*u[1]+this[2]*u[2]; }
Vector.prototype.length2 = function() { return this.dot(this); }
Vector.prototype.length = function() { return Math.sqrt(this.length2()); }
Vector.prototype.normalize = function() { return this.scale(1/this.length()); }
Vector.prototype.cross = function(u) { return new Vector(this[1]*u[2]-this[2]*u[1], this[2]*u[0]-this[0]*u[2], this[0]*u[1]-this[1]*u[0]); }
Vector.prototype.equals = function(u) { return this[0] == u[0] && this[1] == u[1] && this[2] == u[2]; }
