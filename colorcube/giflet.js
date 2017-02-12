// Make a giflet, an inline gif object.
function Giflet(name, width, height, data) {
  this.name = name;
  this.width = width;
  this.height = height;
  this.data = data;
}

// Generate a string containing an image tag with this giflet
Giflet.prototype.img = function(scalex, scaley, name, border) {
  if ( ! scalex) scalex = 1;
  if ( ! scaley) scaley = 1;
  var w = Math.floor(this.width*scalex);
  var h = Math.floor(this.height*scaley);
  var i = '<img width="' + w + '" height="' + h + '"';
  if (name && name != "") i += ' name="' + name + '"';
  if (border >= 0) i += ' border="' + border +'"';
  return i + ' src='+this.src()+'>';
}

// Generate a string containing an url which represents a gif image
Giflet.prototype.src = function() {
  return 'javascript:'+this.name+'.data';
}

// Generate a javascript string literal for a giflet url.
Giflet.prototype.string = function(quote) {
  var s = '', q = quote.charCodeAt(0), e = '\\'.charCodeAt(0);
  for (var i = 0; i < this.data.length; i += 1) {
    var c = this.data.charCodeAt(i);
    if (c < 32 || c >= 127 || c == q || c == e)
      s += (c < 16) ? ('\\x0'+c.toString(16)) : ('\\x'+c.toString(16));
    else
      s += String.fromCharCode(c);
  }
  return quote+s+quote;
}

// giflet for a 1x1 image of specified color.
function Gifblock(r, g, b) {
  function hexString(i) { return (i < 16 ? '0' : '')+i.toString(16); }
  function hexColor(r,g,b) { return hexString(r)+hexString(g)+hexString(b); }
  var name = 'i'+hexColor(r,g,b);
  if ( ! Giflet[name]) 
    Giflet[name] = new Giflet("Giflet."+name, 1, 1, 'GIF87a\1\0\1\0\200\0\0'+String.fromCharCode(r,g,b)+'\0\0\0,\0\0\0\0\1\0\1\0\0\2\2D\1\0;');
  return Giflet[name];
}

// giflet for a 1x1 image of transparent color.
Giflet.transparent = new Giflet('Giflet.transparent', 1, 1, 'GIF89a\1\0\1\0\200\0\0\377\377\377\0\0\0!\371\4\1\0\0\0\0,\0\0\0\0\1\0\1\0\0\2\2D\1\0;');

// giflet for a black square rotated 45 degrees
Giflet.c119 = new Giflet('Giflet.c119',38,38,'GIF87a&\0&\0\302\0\0\0\0\0\177\177\177???\377\377\377\277\277\277\0\0\0\0\0\0\0\0\0,\0\0\0\0&\0&\0\0\3\2078\272\334+\301\311I\233\0@\324\315/\316\134\350x\37(\212di\236U\252\256\354\370\276Zl\315sm\17.\376\351\254\236\357\27\23\16\211\250\343\21H1*KL\331S\31}L\247U\347\225v\333^uZo\216\47\26\13\10eo\4\235~\352\330m\37\23\36WU\351uX\3\337\2562\370f!\200_\47\203T1\206r;\211\134;\3\214H\216\217\207\222\13\211~\2138\230\216|\233\222t\236\225l\241\225\217\244\12\11\0;');
