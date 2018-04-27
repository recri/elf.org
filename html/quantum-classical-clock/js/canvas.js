/*
** Copyright (C) 2009 by Roger E Critchlow Jr,
** Santa Fe, New Mexico, USA
** rec@elf.org
**
** This program is free software; you can redistribute it and/or
** modify it under the terms of the GNU General Public License
** as published by the Free Software Foundation; either version 2
** of the License, or (at your option) any later version.
** 
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
** 
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
**
** The home page for this source is
**	http://www.elf.org/quantum-classical-clock/
** a copy of the GNU GPL may be found at
**	http://www.gnu.org/copyleft/gpl.html,
*/

/*
** Canvas graphics using SVG attributes.
** convention is: take the same arguments as the svg versions
** but return a function(canvas_context) {} that does the drawing
*/
function test_known(node, attr, known) {
  var unknown = []
  for (var i in attr)
	if (known[i] === undefined)
	  unknown.push(i);
  if (unknown.length > 0)
	alert("canvas.js:test_known:ignored attributes: ["+unknown.join()+"] in "+node);
}

var tregexp = /^ *(rotate|translate|scale)\(([^)]*)\) *(.*)$/;
function make_transform(transform) {
  // left to right? right to left?
  var t = [];
  while (transform !== undefined && transform != '') {
	var result = tregexp.exec(transform);
	var op = result[1];
	var arg = result[2];
	transform = result[3];
	switch (op) {
	case 'rotate': {
	  var phi = new Number(arg) * 2 * Math.PI / 360;
	  t.push(function(context) {
		  context.rotate(phi);
		});
	  continue;
	}
	case 'translate': {
	  var c = arg.split(',');
	  var x = new Number(c[0]), y = new Number(c[1]);
	  t.push(function(context) {
		  context.translate(x, y);
		});
	  continue;
	}
	case 'scale': {
	  var c = arg.split(',');
	  if (c.length == 1) {
		var s = new Number(c[0]);
		t.push(function(context) {
			context.scale(s, s);
		  });
	  } else {
		var sx = new Number(c[0]), sy = new Number(c[1]);
		t.push(function(context) {
			context.scale(new Number(c[0]), new Number(c[1]));
		  });
	  }
	  continue;
	}
	default:
	  alert("unrecognized transform operation: "+op);
	  continue;
	}
  }
  return function(context) {
	for (var i in t)
	  t[i](context);
  };
}
function circle_node(attr) {
  var c = new Object();
  
  var cx = attr.cx === undefined ? 0 : attr.cx;
  var cy = attr.cy === undefined ? 0 : attr.cy;
  var r = attr.r === undefined ? 1 : attr.r;
  var fill = attr.fill === undefined ? 'none' : attr.fill;
  var stroke = attr.stroke === undefined ? 'none' : attr.stroke;
  var opacity = attr.opacity === undefined ? 1.0 : attr.opacity;
  var transform = make_transform(attr.transform);

  test_known('circle', attr, {cx:1, cy:1, r:1, stroke:1, fill:1, opacity:1, 'class':1,transform:1});

  c.setAttribute = function(name, value) {
	alert("attempt to alter circle."+name+" to "+value);
  }
  c.paint = function(context) {
	if (stroke != 'none' || fill != 'none') {
	  context.save();
	  transform(context);
	  context.beginPath();
	  context.arc(cx, cy, r, 0, 2*Math.PI, true);
	  context.globalAlpha = opacity;
	  if (stroke != 'none') {
		context.strokeStyle = stroke;
		context.stroke();
	  }
	  if (fill != 'none') {
		context.fillStyle = fill;
		context.fill();
	  }
	  context.restore();
	}
  }
  return c;
}
function line_node(attr) {
  var l = new Object();
  var x1 = attr.x1 === undefined ? 0 : attr.x1;
  var y1 = attr.y1 === undefined ? 0 : attr.y1;
  var x2 = attr.x2 === undefined ? 0 : attr.x2;
  var y2 = attr.y2 === undefined ? 0 : attr.y2;
  var stroke = attr.stroke === undefined ? 'none' : attr.stroke;
  var width = attr["stroke-width"] === undefined ? 1.0 : attr["stroke-width"];
  var opacity = attr.opacity === undefined ? 1.0 : attr.opacity;
  var transform = make_transform(attr.transform);
	
  test_known('line', attr, {x1:1, y1:1, x2:1, y2:1, stroke:1, 'stroke-width':1, opacity:1, 'class':1,transform:1});
	
  l.setAttribute = function(name, value) {
	alert("attempt to alter line."+name+" to "+value);
  }
  l.paint = function(context) {
	if (stroke != 'none') {
	  context.save();
	  transform(context);
	  context.globalAlpha = opacity;
	  context.strokeStyle = stroke;
	  context.lineWidth = width;
	  context.beginPath();
	  context.moveTo(x1, y1);
	  context.lineTo(x2, y2);
	  context.stroke();
	  context.restore();
	}
  }
  return l;
}
function path_node(attr) {
  alert("path_node called in canvas.js");
}
function polygon_node(attr) {
  var p = new Object();

  var points = attr.points.split(/[ ,]+/);
  var stroke = attr.stroke === undefined ? 'none' : attr.stroke;
  var fill = attr.fill === undefined ? 'none' : attr.fill;
  var width = attr["stroke-width"] === undefined ? 1.0 : attr["stroke-width"];
  var linecap = attr["stroke-linecap"] === undefined ? 'butt' : attr["stroke-linecap"];
  var opacity = attr.opacity === undefined ? 1.0 : attr.opacity;
  var transform = make_transform(attr.transform);

  test_known('polygon', attr, {points:1, stroke:1, fill:1, 'stroke-width':1, 'stroke-linecap':1, opacity:1, 'class':1,transform:1});

  p.setAttribute = function(name, value) {
	alert("attempt to alter polygon."+name+" to "+value);
  }
  p.paint = function(context) {
	if (stroke != 'none' || fill != 'none') {
	  context.save();
	  transform(context);
	  context.globalAlpha = opacity;
	  context.beginPath();
	  try {
	  for (var i = 0; i < points.length; i += 2) {
		var x = points[i], y = points[i+1];
		if (i == 0)
		  context.moveTo(x, y);
		else
		  context.lineTo(x, y);
	  }
	  } catch(e) {
		alert("error in polygon.paint with points = "+points.join());
	  }
	  context.closePath();
	  if (stroke != 'none') {
		context.strokeStyle = stroke;
		context.lineWidth = width;
		context.lineCap = linecap;
		context.stroke();
	  }
	  if (fill != 'none') {
		context.fillStyle = fill;
		context.fill();
	  }
	  context.restore();
	}
  }
  return p;
}
function polyline_node(attr) {
  var p = new Object();
  var points = attr.points.split(/[ ,]+/);
  var stroke = attr.stroke === undefined ? 'none' : attr.stroke;
  var width = attr["stroke-width"] === undefined ? 1.0 : attr["stroke-width"];
  var linecap = attr["stroke-linecap"] === undefined ? 'butt' : attr["stroke-linecap"];
  var opacity = attr.opacity === undefined ? 1.0 : attr.opacity;
  var transform = make_transform(attr.transform);
	
  test_known('polyline', attr, {points:1,stroke:1,'stroke-width':1,'stroke-linecap':1,opacity:1,'class':1,transform:1,fill:1});

  p.setAttribute = function(name, value) {
	alert("attempt to alter polygon."+name+" to "+value);
  }
  p.paint = function(context) {
	if (stroke != 'none') {
	  context.save();
	  transform(context);
	  context.globalAlpha = opacity;
	  context.strokeStyle = stroke;
	  context.lineWidth = width;
	  context.lineCap = linecap;
	  context.beginPath();
	  for (var i = 0; i < points.length; i += 2) {
		var x = points[i], y = points[i+1];
		if (i == 0)
		  context.moveTo(x, y);
		else
		  context.lineTo(x, y);
	  }
	  context.stroke();
	  context.restore();
	}
  }
  return p;
}
function rect_node(attr) {
  var r = new Object();

  var x = attr.x;
  var y = attr.y;
  var width = attr.width;
  var height = attr.height;
  var stroke = attr.stroke === undefined ? 'none' : attr.stroke;
  var fill = attr.fill === undefined ? 'none' : attr.fill;
  var width = attr["stroke-width"] === undefined ? 1.0 : attr["stroke-width"];
  var linecap = attr["stroke-linecap"] === undefined ? 'butt' : attr["stroke-linecap"];
  var opacity = attr.opacity === undefined ? 1.0 : attr.opacity;
  var transform = make_transform(attr.transform);
	
  test_known('rect', attr, {x:1, y:1, width:1, height:1, stroke:1, fill:1, 'stroke-width':1, 'stroke-linecap':1, opacity:1, 'class':1,transform:1});

  r.paint = function(context) {
	if (stroke != 'none' || fill != 'none') {
	  context.save();
	  transform(context);
	  context.globalAlpha = opacity;
	  context.lineWidth = width;
	  context.strokeRect(x, y, width, height);
	  context.beginPath();
	  context.rect(x, y, width, height);
	  if (fill != 'none') {
		context.fillStyle = fill;
		context.fill();
	  }
	  if (stroke != 'none') {
		context.strokeStyle = stroke;
		context.stroke();
	  }
	  context.restore();
	}
  }
  return r;
}
function text_node(text, attr) {
  alert("text_node called in canvas.js");
}
function g_node(attr) {
  var g = new Object();
  
  if ( ! attr) throw("no attr passed to g_node()");

  var children = [];
  var transform = make_transform(attr.transform);

  g.appendChild = function(child) {
	children.push(child);
  };
  g.paint = function(context) {
	context.save();
	transform(context);
	for (var i in children)
	  children[i].paint(context);
	context.restore();
  };
  return g;
}
function use_node(attr) {
  alert("use_node called in canvas.js");
}


