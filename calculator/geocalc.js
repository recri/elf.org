//////////////////////////////////////////////////////////////////////
//
// Stack machine
//
function Calculator(form) {
  this.form = form;
  this.reg = new Object();
  this.clear();
}

//////////////////////////////////////////////////////////////////////
//
// Accumulator manipulations as strings
//
// Append a character to the accumulator value
Calculator.prototype.inchar = function(string) {
  if (this.lift) {
    this.lift = false;
    this.dup();
    this.syncOutput();
    this.erase = true;
  }
  if (this.erase) {
    this.erase = false;
    this.form.a.value = '';
  }
  this.form.a.value += string;
}

// Delete the last character entered into the accumulator
Calculator.prototype.backsp = function() {
  var v = this.form.a.value;
  if (v.length == 1 && v == "0")
    this.clear();
  else if (v.length > 1)
    this.form.a.value = v.substring(0, v.length-1);
  else
    this.form.a.value = '0';
}

// Regular expressions for deciding how to change sign
// FIX.ME - change sign needs work
Calculator.prototype.re1 = new RegExp("e$");
Calculator.prototype.re2 = new RegExp("e[+]$");
Calculator.prototype.re3 = new RegExp("e[-]$");
Calculator.prototype.re4 = new RegExp("^[-]");
Calculator.prototype.re5 = new RegExp("^[+]");
      
// Change the sign of the current accumulator
// or the current accumulator exponent.
// And if the current accumulator has more than
// one component to it, then negate?
Calculator.prototype.changeSign = function() {
  var v = this.form.a.value;
  if (this.re1.test(v))
    v += '-';
  else if (this.re2.test(v))
    v = v.substring(0, v.length-1) + '-';
  else if (this.re3.test(v))
    v = v.substring(0, v.length-1) + '+';
  else if (this.re4.test(v))
    v = '+' + v.substring(1);
  else if (this.re5.test(v))
    v = '-' + v.substring(1);
  else
    v = '-' + v;
  this.form.a.value = v;
}

//////////////////////////////////////////////////////////////////////
//
// Synchronize display and stack.
//
// Synchronize display to stack.
Calculator.prototype.syncInput = function() {
  this.a = parseCNumber(this.form.a.value);
}

// Synchronize stack to display.
Calculator.prototype.syncOutput = function() {
  // this.form.t.value = this.t.toString();
  // this.form.c.value = this.c.toString();
  this.form.b.value = this.b.toString();
  this.form.a.value = this.a.toString();
}

// Synchronize around pure stack operation and set flags
Calculator.prototype.sync = function(op, erase, lift, etc1, etc2) {
  this.syncInput();
  this[op](etc1, etc2);
  this.syncOutput();
  this.erase = erase;
  this.lift = lift;
}

//////////////////////////////////////////////////////////////////////
//
// Pure stack operations
//
// Drop the top of stack
Calculator.prototype.drop = function() { this.a = this.b; this.b = this.c; this.c = this.t; }

// Duplicate the top of stack
Calculator.prototype.dup = function() { this.t = this.c; this.c = this.b; this.b = this.a; }

// Swap the top two elements on the stack
Calculator.prototype.swap = function() { var s = this.a; this.a = this.b; this.b = s; }
  
// Roll the elements of the stack up.
Calculator.prototype.rollup = function() { var r = this.t; this.dup(); this.a = r;  }

// Roll the elements of the stack down.
Calculator.prototype.rolldn = function() { var r = this.a; this.drop(); this.t = r; }

// Store to register
Calculator.prototype.sto = function() {
  var reg = prompt("Register to store");
  if (reg != null)
    this.reg[reg] = this.a;
}

// Recall from register
Calculator.prototype.rcl = function() {
  var reg = prompt("Register to recall");  
  if (reg != null)
    if ((this.a = this.reg[reg]) == null)
      this.a = new CNumber(0);
}

////////////////////////////////
//
// Impure stack operations
//
// Clear the stack
Calculator.prototype.justclear = function() { this.t = this.c = this.b = this.a = new CNumber(0); }

// Binary operation.
Calculator.prototype.justbinary = function(op) { this.b = this.b[op](this.a); this.drop(); }

// Unary operation.
Calculator.prototype.justunary = function(op, etc) { this.a = this.a[op](etc); }

// Nilary operation.
Calculator.prototype.justnilary = function(op, etc) { this[op](); }

// No operation
Calculator.prototype.noop = function() { ; }

//////////////////////////////////////////////////////////////////////
//
// Stack operations from buttons
//
// Enter the accumulator onto the stack
Calculator.prototype.enter = function() { this.sync('dup', true, false); }

// Clear the calculator
Calculator.prototype.clear = function() { this.sync('justclear', true, false); }

// Perform a binary operation.
Calculator.prototype.binary = function(op) { this.sync('justbinary', false, true, op); }

// Perform a unary operation
Calculator.prototype.unary = function(op, etc) { this.sync('justunary', false, true, op, etc); }

// Perform a nilary operation
Calculator.prototype.nilary = function(op, etc) { this.sync('justnilary', false, true, op, etc); }

