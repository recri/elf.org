//
// this test depends on images.js loading before us.
//
var inline_images = (gif && gif.usto);

//
// key abstraction
//
function Key(r,c,w,img,help,func,op,etc) {
  this.r = r;			/* row */
  this.c = c;			/* column */
  this.w = w;			/* column span, 0, 1 or 2 */
  if (w == 0) return;
  this.n = 'r'+r+'c'+c;		/* name */
  this.up = 'images/u'+img+'.gif'; /* key up image, file */
  this.dn = 'images/p'+img+'.gif'; /* key down image, file */
  this.upimg = new Image();
  this.dnimg = new Image();
  this.upimg.src = this.up;
  this.dnimg.src = this.dn;
  this.help = help;
  this.func = func;		/* key press function */
  this.op = op;			/* key press operand */
  this.etc = etc;		/* key press etc */
}

//
// key prototypes
//
Key.prototype.mouseover = function() {
    status = this.help; return true;
}
Key.prototype.keypress = function() {
    return void document.calc[this.func](this.op, this.etc);
}
Key.prototype.mousedown = function() {
    document.images[this.n].src = this.dn; return true;
}
Key.prototype.mouseup = function() {
    document.images[this.n].src = this.up; return true;
}
Key.prototype.mouseout = function() {
    document.images[this.n].src = this.up; status = ''; return true;
}

//
// build the keypad
//
var keypad = [
	    [[1,'sto',  'store value',  'nilary','sto'],
	     [1,'rcl',  'recall value', 'nilary','rcl'],
	     [1,'sqrt', 'square root',  'unary','sqrt'],
	     [1,'cos',  'cosine',       'unary','cos'],
 	     [1,'sin',  'sine',         'unary','sin'],
	     [1,'tan',  'tangent',      'unary','tan'],
	     [1,'blank','',             'nilary','noop'],
	     [1,'blank','',             'nilary','noop']],
	    [[2,'enter','enter value',  'enter'],
	     [0],
	     [1,'xchg', 'exchange',     'nilary','swap'],
	     [1,'down', 'roll down',    'nilary','rolldn'],
	     [1,'bsp',  'back space',   'backsp'],
	     [1,'inv',  'inverse',      'unary','inverse'],
	     [1,'norm', 'normalize',    'unary', 'normalize'],
	     [1,'clr',  'clear',        'clear']],
	    [[1,'x',    'x basis',      'inchar','x'],
	     [1,'seven','digit 7',      'inchar','7'],
	     [1,'eight','digit 8',      'inchar','8'],
	     [1,'nine', 'digit 9',      'inchar','9'],
	     [1,'divide','divide',      'binary','divide'],
	     [1,'inner','inner',        'binary','inner'],
	     [1,'g0','grade 0',         'unary','grade',0],
	     [1,'g1','grade 1',         'unary','grade',1]],
	    [[1,'y','y basis',          'inchar','y'],
	     [1,'four','digit 4',       'inchar','4'],
	     [1,'five','digit 5',       'inchar','5'],
	     [1,'six','digit 6',        'inchar','6'],
	     [1,'times','multiply',     'binary','multiply'],
	     [1,'outer','outer',        'binary','outer'],
	     [1,'g2','grade 2',         'unary','grade',2],
	     [1,'g3','grade 3',         'unary','grade',3]],
	    [[1,'z','z basis',          'inchar','z'],
	     [1,'one','digit 1',        'inchar','1'],
	     [1,'two','digit 2',        'inchar','2'],
	     [1,'three','digit 3',      'inchar','3'],
	     [1,'minus','subtract',     'binary','subtract'],
	     [1,'rev','reversion',      'unary','reverse'],
	     [1,'geven','even grade',   'unary','grade','even'],
	     [1,'godd','odd grade',     'unary','grade','odd']],
	    [[1,'neg','change sign',    'changeSign'],
	     [1,'zero','digit 0',       'inchar','0'],
	     [1,'dec','decimal point',  'inchar','.'],
	     [1,'exp','enter exponent', 'inchar','e'],
	     [1,'plus','add',           'binary','add'],
	     [1,'mag','magnitude',      'unary','magnitude'],
	     [1,'ref','reflect a by b', 'binary','reflect'],
	     [1,'rot','rotate a by b',  'binary','rotate']]
];

for (var r = 0; r < keypad.length; r += 1)
  for (var c = 0; c < keypad[r].length; c += 1)
    keypad[r][c] = new Key(r,c,keypad[r][c][0],keypad[r][c][1],keypad[r][c][2],
			   keypad[r][c][3],keypad[r][c][4],keypad[r][c][5],keypad[r][c][6]);

//
// generate keypad
//
function generate() {
  document.write('<form name="geocalc" onSubmit="return false">\n',
		 '<table cellspacing="0" cellpadding="0" border="0" frame="border" rules="none">\n');

  // Title bar?
  // <tr><td><i><b>12G</b></i><td colspan=7 align="right"><i><b>RPN</b> GEOMETRIC</i></tr>
  // Register t?
  // <tr align="center" valign="middle"><td>t:<td colspan="7"><input type="text" name="t" size="50"></tr>
  // Register c?
  // <tr align="center" valign="middle"><td>c:<td colspan="7"><input type="text" name="c" size="50"></tr>

  document.write('<tr align="center" valign="middle">\n',
		 '<td colspan="8"><input type="text" name="b" size="45"></td>\n',
		 '</tr>\n',
		 '<tr align="center" valign="middle">\n',
		 '<td colspan="8"><input type="text" name="a" size="45" onChange="calc[\'enter\']()"></td>\n',
		 '</tr>\n');
  for (var i in keypad) {
    document.write('<tr align="center" valign="middle">\n');
    for (var j in keypad[i]) {
      var k = 'keypad['+i+']['+j+']';
      var key = keypad[i][j];
      
      if (key.w == 0) continue;

      document.write('<td colspan="'+key.w+'"><a href="javascript:'+k+'.keypress();"\n',
		     'onmouseover="return '+k+'.mouseover();"\n',
		     'onmousedown="return '+k+'.mousedown();"\n',
		     'onmouseup="return '+k+'.mouseup();"\n',
		     'onmouseout="return '+k+'.mouseout();"\n',
		     '><img height="28" width="'+(key.w*52)+'" border="0" src="'+key.up+'" name="'+key.n+'"></a></td>\n');
    }
  }
  document.write('<tr><td colspan="8" align="center">\n',
		 'Copyright &copy; 1999, <a href="mailto:rec@elf.org">Roger E Critchlow Jr</a>, Santa Fe, New Mexico.  ',
		 '<a href="http://www.elf.org" target="_blank">elf.org</a>.</td></tr>\n',
		 '</table>\n',
		 '</form>\n');
}
