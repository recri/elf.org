//
// PNG drawing library for JavaScript.
// Copyright (C) 1999, 2006 by Roger E Critchlow Jr,
// Santa Fe, New Mexico, USA.
//
// Licensed under the Academic Free License version 2.1
//
// The home page for Pnglets is http://www.elf.org/pnglets,
// a copy of the AFL may be found at http://www.opensource.org/licenses/afl-2.1.php,
// Pnglets were inspired by and copied from gd1.3, http://www.boutell.com/gd,
// other parts were inspired by or copied from Tcl/Tk, http://www.scriptics.com,
// and some algorithms were taken from Foley & van Dam 2nd Edition.
//
// Thanks to Alex Vincent for pointing out the advantages of eliminating strict
// javascript warnings.
//

// create a new Pnglet of specified width, height, and depth
// width and height are specified in pixels
// depth was the number of palette entries, but is now ignored
function Pnglet(width,height,depth) {
	this.width = width || 16;
	this.height = height || 16;
	this.depth = depth;
	this.pixels = new Array(height * width);
	// initialize palette hash
	this.palette = new Object();
	this.pindex = []
}

// version string/number
Pnglet.version = "20060128.0";

// test if coordinates are within bounds
Pnglet.prototype.inBounds = function(x,y) { return x >= 0 && x < this.width && y >= 0 && y < this.height; }

// clip an x value to the window width
Pnglet.prototype.clipX = function(x) { return (x < 0) ? 0 : (x >= this.width) ? this.width-1 : x ; }

// clip a y value to the window height
Pnglet.prototype.clipY = function(y) { return (y < 0) ? 0 : (y >= this.height) ? this.height-1 : y ; }

// compute the index into a png for a given pixel
Pnglet.prototype.index = function(x,y) {
	return y*this.width+x;
}

// make a color in a Pnglet
Pnglet.prototype.color = function(red, green, blue, alpha) {
	red = Math.max(0, Math.min(red, 255));
	green = Math.max(0, Math.min(green, 255));
	blue = Math.max(0, Math.min(blue, 255));
	// default the alpha to opaque
	alpha = (typeof alpha == "undefined") ? 255 : alpha;
	// pack the channels into a word
	var rgba = (((((red<<8)+green)<<8)+blue)<<8)+alpha;
	// see if the word is defined
	if ( typeof this.palette[rgba] == "undefined") {
		// define a new color
		this.palette[rgba] = this.pindex.length;
		var c = new Object();
		c.red = red;
		c.green = green;
		c.blue = blue;
		c.alpha = alpha;
		this.pindex.push(c);
	}
	// return the color index
	return this.palette[rgba];
}

// return true if this is a color
Pnglet.prototype.isColor = function(color) {
	return color != null && color >= 0 && color < this.pindex.length;
}

// find the red, green, blue, or alpha value of a Pnglet color
Pnglet.prototype.red = function(color) { return this.isColor(color) ? this.pindex[color].red : false; }
Pnglet.prototype.green = function(color) { return this.isColor(color) ? this.pindex[color].green : false; }
Pnglet.prototype.blue = function(color) { return this.isColor(color) ? this.pindex[color].blue : false; }
Pnglet.prototype.alpha = function(color) { return this.isColor(color) ? this.pindex[color].alpha : false; }
Pnglet.prototype.r = Pnglet.prototype.red;
Pnglet.prototype.g = Pnglet.prototype.green;
Pnglet.prototype.b = Pnglet.prototype.blue;
Pnglet.prototype.a = Pnglet.prototype.alpha;
Pnglet.prototype.rgba = function(color) { return this.isColor(color) ? this.pindex[color].rgba : false; }

// blend a foreground color onto a background color
Pnglet.prototype.blend = function(top, bot) {
//	resultAlpha = (topAlpha * 255 + (255 - topAlpha) * bottomAlpha + 127) / 255;
//	resultColor = (topAlpha * topColor + (((255 - topAlpha) * bottomAlpha + 127) / 255) * bottomColor +  127) / resultAlpha;
	var topA = this.a(top);
	var botA = this.a(bot);
	var tmpA = (255 - topA) * botA + 127;
	var cmpA = (tmpA / 255);
	var a = Math.floor((topA * 255 + tmpA) / 255);
	var r = Math.floor((topA * this.r(top) + cmpA * this.r(bot) + 127) / a);
	var g = Math.floor((topA * this.g(top) + cmpA * this.g(bot) + 127) / a);
	var b = Math.floor((topA * this.b(top) + cmpA * this.b(bot) + 127) / a);
	return this.color(r, g, b, a);
}
		
// draw a point or points
Pnglet.prototype.point = function(pointColor, x0, y0) {
	var a = arguments;
	this.pointNXY(pointColor, (a.length-1)/2, function(i) { return a[2*i+1]; }, function(i) { return a[2*i+2]; });
}

// draw exactly one point
Pnglet.prototype.point1 = function(color, x, y) {
	var a = this.alpha(color);
	if (a == 255) {
		this.pixels[this.index(x,y)] = color;			// overwrite
	} else if (a == 0) {
		;												// ignore
	} else {
		var i = this.index(x,y);
		var c = this.isColor(this.pixels[i]) ? this.pixels[i] : this.bkgd;
		this.pixels[i] = this.blend(color, c);
	}
}

// draw a series of points
Pnglet.prototype.pointNXY = function(pointColor, n, x, y) {
	if ( ! this.isColor(pointColor))
		return;
	for (var i = 0; i < n; i += 1) {
		var x1 = x(i), y1 = y(i);
		if (this.inBounds(x1,y1))
			this.point1(pointColor, x1, y1);
	}
}

// read a pixel 
Pnglet.prototype.getPoint = function(x,y) {
	var c;
	if (this.inBounds(x,y))
		c = this.pixels[this.index(x,y)];
	return this.isColor(c) ? c : this.color(0,0,0,0);
}

// draw a horizontal line
Pnglet.prototype.horizontalLine = function(lineColor, x1, x2, y) {
	if ( ! this.isColor(lineColor))
		return;
	x1 = this.clipX(x1);
	x2 = this.clipX(x2);
	var x;
	if (x1 < x2)
		for (x = x1; x <= x2; x += 1)
			this.point1(lineColor, x, y);
	else
		for (x = x2; x <= x1; x += 1)
			this.point1(lineColor, x, y);
}

// draw a vertical line
Pnglet.prototype.verticalLine = function(lineColor, x, y1, y2) {
	if ( ! this.isColor(lineColor))
		return;
	y1 = this.clipY(y1);
	y2 = this.clipY(y2);
	var y;
	if (y1 < y2)
		for (y = y1; y <= y2; y += 1)
			this.point1(lineColor, x, y);
	else
		for (y = y2; y <= y1; y += 1)
			this.point1(lineColor, x, y);
}

// draw a general line
Pnglet.prototype.generalLine = function(lineColor, x1, y1, x2, y2) {
	if ( ! this.isColor(lineColor))
		return;
	var dx = Math.abs(x2-x1), dy = Math.abs(y2-y1);
	var incr1, incr2, d, x, y, xend, yend, xdirflag, ydirflag, xinc, yinc;
	if (dy <= dx) {
		d = 2*dy - dx;
		incr1 = 2*dy;
		incr2 = 2 * (dy - dx);
		if (x1 > x2) {
			x = x2;
			y = y2;
			ydirflag = -1;
			xend = x1;
		} else {
			x = x1;
			y = y1;
			ydirflag = 1;
			xend = x2;
		}
		yinc = (((y2 - y1) * ydirflag) > 0) ? 1 : -1;
		this.point(lineColor, x, y);
		while (x++ < xend) {
			if (d < 0) {
				d += incr1;
			} else {
				y += yinc;
				d += incr2;
			}
			this.point(lineColor, x, y);
		}
	} else {			/* dy > dx */
		d = 2*dx - dy;
		incr1 = 2*dx;
		incr2 = 2 * (dx - dy);
		if (y1 > y2) {
			y = y2;
			x = x2;
			yend = y1;
			xdirflag = -1;
		} else {
			y = y1;
			x = x1;
			yend = y2;
			xdirflag = 1;
		}
		xinc = (((x2 - x1) * xdirflag) > 0) ? 1 : -1;
		this.point(lineColor, x, y);
		while (y++ < yend) {
			if (d < 0) {
				d += incr1;
			} else {
				x += xinc;
				d += incr2;
			}
			this.point(lineColor, x, y);
		}
	}
}

// draw a line
Pnglet.prototype.line = function(lineColor, x0, y0) {
	var a = arguments;
	this.lineNXY(lineColor, (a.length-1)/2, function(i) { return a[2*i+1]; }, function(i) { return a[2*i+2]; });
}

Pnglet.prototype.lineNXY = function(lineColor, n, x, y) {
	if ( ! this.isColor(lineColor))
		return;
	var x1 = x(0), y1 = y(0);
	for (var i = 1; i < n; i += 1) {
		var x2 = x(i), y2 = y(i);
		if (x1 == x2)
			this.verticalLine(lineColor, x1, y1, y2);
		else if (y1 == y2)
			this.horizontalLine(lineColor, x1, x2, y1);
		else
			this.generalLine(lineColor, x1, y1, x2, y2);
		x1 = x2;
		y1 = y2;
	}
}

// draw a polygon
Pnglet.prototype.polygon = function(outlineColor, fillColor, x1, y1) {
	var a = arguments;
	this.polygonNXY(outlineColor, fillColor, (a.length-2)/2, function(i) {return a[2*i+2];}, function(i) {return a[2*i+3];});
}

Pnglet.prototype.polygonNXY = function(outlineColor, fillColor, n, x, y) {
	if (n <= 0)
		return;
	if (this.isColor(fillColor))
		this.concaveNXY(fillColor, n, x, y);
	if (this.isColor(outlineColor))
		this.lineNXY(outlineColor, n+1, function(i) { return x(i%n); }, function(i) { return y(i%n); });
}

/*
 * Concave Polygon Scan Conversion
 * by Paul Heckbert
 * from "Graphics Gems", Academic Press, 1990
 */
Pnglet.prototype.concaveNXY = function(fillColor, n, ptx, pty) {
	function Edge(ex, edx, ei) {	/* a polygon edge */
		this.x = ex;	/* x coordinate of edge's intersection with current scanline */
		this.dx = edx;	/* change in x with respect to y */
		this.i = ei;	/* edge number: edge i goes from pt[i] to pt[i+1] */
	}
	function cdelete(di) {	/* remove edge i from active list */
		for (var j = 0; j < active.length; j += 1)
			if (active[j].i == di)
				active.splice(j, 1);
	}
	function cinsert(ii, iy) {	/* append edge i to end of active list */
		var ij = ii<n-1 ? ii+1 : 0;
		var px, py, qx, qy;
		if (pty(ii) < pty(ij)) {
			px = ptx(ii); py = pty(ii);
			qx = ptx(ij); qy = pty(ij);
		} else {
			px = ptx(ij); py = pty(ij);
			qx = ptx(ii); qy = pty(ii);
		}
		/* initialize x position at intersection of edge with scanline y */
		var dx = (qx-px)/(qy-py);
		active.push(new Edge(dx*(iy+.5-py)+px, dx, ii));
	}

	var ind = new Array(n);		/* list of vertex indices, sorted by pt[ind[j]].y */
	var active = new Array(0);		/* start with an empty active list */

	/* create y-sorted array of indices ind[k] into vertex list */
	for (var k = 0; k < n; k += 1) ind[k] = k;
	ind.sort(function(i1, i2) { return pty(i1) <= pty(i2) ? -1 : 1; });
	k = 0;                        /* ind[k] is next vertex to process */
	var y0 = Math.max(0, Math.ceil(pty(ind[0])+.5));			/* ymin of polygon */
	var y1 = Math.min(this.height, Math.floor(pty(ind[n-1])-.5));	/* ymax of polygon */

	for (var y = y0; y <= y1; y += 1) {		/* step through scanlines */
		/* scanline y is at y+.5 in continuous coordinates */

		/* check vertices between previous scanline and current one, if any */
		for (; k<n && pty(ind[k]) <= y+.5; k += 1) {
			/* to simplify, if pt.y=y+.5, pretend it's above */
			/* invariant: y-.5 < pt[i].y <= y+.5 */
			var i = ind[k];	

			/*
			 * insert or delete edges before and after vertex i (i-1 to i,
			 * and i to i+1) from active list if they cross scanline y
			 */
			var j = (i-1+n)%n;		/* vertex previous to i */
			if (pty(j) <= y-.5)	{	/* old edge, remove from active list */
				cdelete(j);
			} else if (pty(j) > y+.5) {	/* new edge, add to active list */
				cinsert(j, y);
			}
			if (i != ind[k]) {
				alert("Your browser's implementation of JavaScript is seriously broken,\n"+
					"as in variables are changing value of their own volition.\n"+
					"You should upgrade to a newer version browser.");
				return;
			}
			j = (i+1)%n;		/* vertex next after i */
			if (pty(j) <= y-.5)	{	/* old edge, remove from active list */
				cdelete(i);
			} else if (pty(j) > y+.5) {	/* new edge, add to active list */
				cinsert(i, y);
			}
		}

		/* sort active edge list by active[j].x */
		active.sort(function(u,v) { return u.x <= v.x ? -1 : 1; });

		/* draw horizontal segments for scanline y */
		for (j = 0; j < active.length; j += 2) {	/* draw horizontal segments */
			/* span 'tween j & j+1 is inside, span tween j+1 & j+2 is outside */
			var xl = Math.ceil(active[j].x+.5);		/* left end of span */
			if (xl<0) xl = 0;
			var xr = Math.floor(active[j+1].x-.5);	/* right end of span */
			if (xr>this.width-1) xr = this.width-1;
			if (xl<=xr)
				this.horizontalLine(fillColor, xl, xr, y);	/* draw pixels in span */
			active[j].x += active[j].dx;	/* increment edge coords */
			active[j+1].x += active[j+1].dx;
		}
	}
}

// draw a rectangle
Pnglet.prototype.rectangle = function(outlineColor, fillColor, x0,y0,x1,y1) {
	if (this.isColor(fillColor))
		for (var y = y0; y < y1; y += 1)
			this.horizontalLine(fillColor, x0+1, x1-2, y);
	if (this.isColor(outlineColor)) {
		this.horizontalLine(outlineColor, x0, x1-1, y0);
		this.horizontalLine(outlineColor, x0, x1-1, y1-1);
		this.verticalLine(outlineColor, x0, y0, y1-1);
		this.verticalLine(outlineColor, x1-1, y0, y1-1);
	}
}

// draw an arc
Pnglet.prototype.arc = function(outlineColor, cx,cy,w,h, s,e) {
	var p = this.midpointEllipse(cx,cy, w,h, s,e);
	function x(i) { return p[i*2]; };
	function y(i) { return p[i*2+1]; };
	this.lineNXY(outlineColor, p.length/2, x, y);
}

// draw an oval
Pnglet.prototype.oval = function(outlineColor, fillColor, cx,cy,w,h) {
	var p = this.midpointEllipse(cx,cy, w,h, 0,359);
	function x(i) { return p[i*2]; };
	function y(i) { return p[i*2+1]; };
	this.polygonNXY(outlineColor, fillColor, p.length/2, x, y);
}

// draw an arc with chord
Pnglet.prototype.chord = function(outlineColor, fillColor, cx,cy,w,h, s,e) {
	var p = this.midpointEllipse(cx,cy, w,h, s,e);
	function x(i) { return p[i*2]; };
	function y(i) { return p[i*2+1]; };
	this.polygonNXY(outlineColor, fillColor, p.length/2, x, y);
}

// draw an arc with pieslice
Pnglet.prototype.pieslice = function(outlineColor, fillColor, cx,cy,w,h, s,e) {
	var p = this.midpointEllipse(cx,cy, w,h, s,e);
	p[p.length] = cx;
	p[p.length] = cy;
	function x(i) { return p[i*2]; };
	function y(i) { return p[i*2+1]; };
	this.polygonNXY(outlineColor, fillColor, p.length/2, x, y);
}

// oval arcs
// generate points of oval circumference
// midpoint ellipse, Foley & van Dam, 2nd Edition, p. 90, 1990
Pnglet.prototype.midpointEllipse = function(cx,cy, w,h, s,e) {
	var a = Math.floor(w/2), b = Math.floor(h/2);
	var a2 = a*a, b2 = b*b, x = 0, y = b;
	var d1 = b2 - a2*b + a2/4;
	cx = Math.floor(cx);
	cy = Math.floor(cy);
	var p = new Array();

	// quadrant I, anticlockwise
	p.push(x,-y);
	while (a2*(y-1/2) > b2*(x+1)) {
		if (d1 < 0) {
			d1 += b2*(2*x+3);
		} else {
			d1 += b2*(2*x+3) + a2*(-2*y + 2);
			y -= 1;
		}
		x += 1;
		p.unshift(x,-y);
	}
	var d2 = b2*(x+1/2)*(x+1/2) + a2*(y-1)*(y-1) - a2*b2;
	while (y > 0) {
		if (d2 < 0) {
			d2 += b2*(2*x+2) + a2*(-2*y+3);
			x += 1;
		} else {
			d2 += a2*(-2*y+3);
		}
		y -= 1;
		p.unshift(x,-y);
	}
	// quadrant II, anticlockwise
	var n4 = p.length;
	for (var i = n4-4; i >= 0; i -= 2)
		p.push(-p[i], p[i+1]);
	// quadrants III and IV, anticlockwise
	var n2 = p.length;
	for (i = n2-4; i > 0; i -= 2)
		p.push(p[i], -p[i+1]);

	// compute start and end indexes from start and extent
	e %= 360;
	if (e < 0) {
		s += e;
		e = -e;
	}
	s %= 360;
	if (s < 0)
		s += 360;
	var is = Math.floor(s/359 * p.length/2);
	var ie = Math.floor(e/359 * p.length/2)+1;
	p = p.slice(is*2).concat(p.slice(0, is*2)).slice(0, ie*2);

	// displace to center
	for (i = 0; i < p.length; i += 2) {
		p[i] += cx;
		p[i+1] += cy;
	}
	return p;
}

// fill a region 
// from gd1.3 with modifications
Pnglet.prototype.fill = function(outlineColor,fillColor,x,y) {
	if (outlineColor) {			// fill to outline color
		/* Seek left */
		var leftLimit = -1;
		for (var i = x; i >= 0 && this.getPoint(i, y) != outlineColor; i -= 1)
			leftLimit = i;
	
		if (leftLimit == -1)
			return;

		/* Seek right */
		var rightLimit = x;
		for (i = (x+1); i < this.width && this.getPoint(i, y) != outlineColor; i += 1)
			rightLimit = i;

		/* fill extent found */
		this.horizontalLine(fillColor, leftLimit, rightLimit, y);

		/* Seek above and below */
		for (var dy = -1; dy <= 1; dy += 2) {
			if (this.inBounds(x,y+dy)) {
				var lastBorder = 1;
				for (i = leftLimit; i <= rightLimit; i++) {
					var c = this.getPoint(i, y+dy);
					if (lastBorder) {
						if ((c != outlineColor) && (c != fillColor)) {	
							this.fill(outlineColor, fillColor, i, y+dy);
							lastBorder = 0;
						}
					} else if ((c == outlineColor) || (c == fillColor)) {
						lastBorder = 1;
					}
				}
			}
		}
    
	} else {			// flood fill color at x, y 
		/* Test for completion */
		var oldColor = this.getPoint(x, y);
		if (oldColor == fillColor)
			return;

		/* Seek left */
		leftLimit = (-1);
		for (i = x; i >= 0 && this.getPoint(i, y) == oldColor; i--)
			leftLimit = i;

		if (leftLimit == -1)
			return;

		/* Seek right */
		rightLimit = x;
		for (i = (x+1); i < this.width && this.getPoint(i, y) == oldColor; i++)
			rightLimit = i;

		/* Fill extent found */
		this.horizontalLine(fillColor, leftLimit, rightLimit, y);

		/* Seek above and below */
		for (dy = -1; dy <= 1; dy += 2) {
			if (this.inBounds(x,y+dy)) {
				lastBorder = 1;
				for (i = leftLimit; i <= rightLimit; i++) {
					c = this.getPoint(i, y+dy);
					if (lastBorder) {
						if (c == oldColor) {	
							this.fill(null, fillColor, i, y+dy);
							lastBorder = 0;
						}
					} else if (c != oldColor) {
						lastBorder = 1;
					}
				}
			}
		}
	}
}

// smoothed points
Pnglet.prototype.smoothPoint = function(smoothSteps, pointColor, x0, y0) {
	var a = arguments, self = this, n = (a.length-2)/2;
	this.smooth(smoothSteps,
              function(n, x, y) { self.pointNXY(pointColor, n, x, y); },
              n,
              function(i) { return a[2*i+2]; },
              function(i) { return a[2*i+3]; });
}

// smoothed polyline
Pnglet.prototype.smoothLine = function(smoothSteps, lineColor, x0, y0) {
	var a = arguments, self = this, n = (a.length-2)/2;
	this.smooth(smoothSteps,
              function(n, x, y) { self.lineNXY(lineColor, n, x, y); },
              n,
              function(i) { return a[2*i+2]; },
              function(i) { return a[2*i+3]; });
}

// smoothed polygon
Pnglet.prototype.smoothPolygon = function(smoothSteps, outlineColor, fillColor, x0, y0) {
	var a = arguments, self = this, n = (a.length-3)/2 + 1;
	this.smooth(smoothSteps,
              function(n, x, y) { self.polygonNXY(outlineColor, fillColor, n, x, y); },
              n,
              function(i) { return a[2*(i%(n-1))+3]; },
              function(i) { return a[2*(i%(n-1))+4]; });
}
    
// generate smoothSteps points for the line segment connecting
// each consecutive pair of points in x(i), y(i).
// adapted from the source for tk8.1b3, http://www.scriptics.com
Pnglet.prototype.smooth = function(smoothSteps, fNXY, n, x, y) {
	var control = new Array(8);
	var outputPoints = 0;
	var dblPoints = new Array();

	// compute numSteps of smoothed points
	// according to the basis in control[]
	// placing points into coordPtr[coordOff]
	function smoothPoints(control, numSteps, coordPtr, coordOff) {
		for (var i = 1; i <= numSteps; i++, coordOff += 2) {
			var t = i/numSteps, t2 = t*t, t3 = t2*t,
			u = 1.0 - t, u2 = u*u, u3 = u2*u;
			coordPtr[coordOff+0] = control[0]*u3 + 3.0 * (control[2]*t*u2 + control[4]*t2*u) + control[6]*t3;
			coordPtr[coordOff+1] = control[1]*u3 + 3.0 * (control[3]*t*u2 + control[5]*t2*u) + control[7]*t3;
		}
	}

	/*
	 * If the curve is a closed one then generate a special spline
	 * that spans the last points and the first ones.  Otherwise
	 * just put the first point into the output.
	 */

	var closed = (x(0) == x(n-1)) && (y(0) == y(n-1));
	if (closed) {
		control[0] = 0.5*x(n-2) + 0.5*x(0);
		control[1] = 0.5*y(n-2) + 0.5*y(0);
		control[2] = 0.167*x(n-2) + 0.833*x(0);
		control[3] = 0.167*y(n-2) + 0.833*y(0);
		control[4] = 0.833*x(0) + 0.167*x(1);
		control[5] = 0.833*y(0) + 0.167*y(1);
		control[6] = 0.5*x(0) + 0.5*x(1);
		control[7] = 0.5*y(0) + 0.5*y(1);
		dblPoints[2*outputPoints+0] = control[0];
		dblPoints[2*outputPoints+1] = control[1];
		outputPoints += 1;
		smoothPoints(control, smoothSteps, dblPoints, 2*outputPoints);
		outputPoints += smoothSteps;
	} else {
		dblPoints[2*outputPoints+0] = x(0);
		dblPoints[2*outputPoints+1] = y(0);
		outputPoints += 1;
	}

	for (var i = 2; i < n; i += 1) {
		var j = i - 2;
		/*
		 * Set up the first two control points.  This is done
		 * differently for the first spline of an open curve
		 * than for other cases.
		 */
		if ((i == 2) && !closed) {
			control[0] = x(j);
			control[1] = y(j);
			control[2] = 0.333*x(j) + 0.667*x(j+1);
			control[3] = 0.333*y(j) + 0.667*y(j+1);
		} else {
			control[0] = 0.5*x(j) + 0.5*x(j+1);
			control[1] = 0.5*y(j) + 0.5*y(j+1);
			control[2] = 0.167*x(j) + 0.833*x(j+1);
			control[3] = 0.167*y(j) + 0.833*y(j+1);
		}

		/*
		 * Set up the last two control points.  This is done
		 * differently for the last spline of an open curve
		 * than for other cases.
		 */

		if ((i == (n-1)) && !closed) {
			control[4] = .667*x(j+1) + .333*x(j+2);
			control[5] = .667*y(j+1) + .333*y(j+2);
			control[6] = x(j+2);
			control[7] = y(j+2);
		} else {
			control[4] = .833*x(j+1) + .167*x(j+2);
			control[5] = .833*y(j+1) + .167*y(j+2);
			control[6] = 0.5*x(j+1) + 0.5*x(j+2);
			control[7] = 0.5*y(j+1) + 0.5*y(j+2);
		}

		/*
		 * If the first two points coincide, or if the last
		 * two points coincide, then generate a single
		 * straight-line segment by outputting the last control
		 * point.
		 */

		if (((x(j) == x(j+1)) && (y(j) == y(j+1)))
		 || ((x(j+1) == x(j+2)) && (y(j+1) == y(j+2)))) {
			dblPoints[2*outputPoints+0] = control[6];
			dblPoints[2*outputPoints+1] = control[7];
			outputPoints += 1;
			continue;
		}

		/*
		 * Generate a Bezier spline using the control points.
		 */
		smoothPoints(control, smoothSteps, dblPoints, 2*outputPoints);
		outputPoints += smoothSteps;
	}

	// draw the points
	// anonymous functions don't work here
	// they result in "undefined" point values
	function myx(i) { return Math.round(dblPoints[2*i]); }
	function myy(i) { return Math.round(dblPoints[2*i+1]); }
	fNXY(outputPoints, myx, myy);
}

// output a PNG string
Pnglet.prototype.output = function() {
	// pixel data and row filter identifier size
	var width = this.width;
	var height = this.height;
	var pix_size = height*(4*width+1);

	// deflate header, pix_size, block headers, adler32 checksum
	var data_size = 2 + pix_size + 5*Math.floor((pix_size+0xffff-1)/0xffff) + 4;

	// offsets and sizes of Png chunks
	var ihdr_offs = 0;							// IHDR offset and size
	var ihdr_size = 4+4+13+4;
	var idat_offs = ihdr_offs+ihdr_size;		// IDAT offset and size
	var idat_size = 4+4+data_size+4;
	var iend_offs = idat_offs+idat_size;		// IEND offset and size
	var iend_size = 4+4+4;
	var png_size = iend_offs+iend_size;			// total PNG size

	// array of one byte strings
	var png = new Array(png_size);

	// compute the output index for a pixel byte
	// c is 0, 1, 2, or 3 for r, g, b, or a
	// c may be -1 for the filter byte if x == 0
	function outputIndex(x,y,c) {
		var i = y*(4*width+1)+4*x+c+1;
		var j = idat_offs+8+2+Math.floor((i/0xffff)+1)*5+i;
		return j;
	}

	// functions for initializing data
	function initialize(png, offs, str) {
		for (var i = 1; i < arguments.length; i += 1)
			if (typeof arguments[i].length != "undefined")
				for (var j = 0; j < arguments[i].length; j += 1)
					png[offs++] = arguments[i].charAt(j);
	}
	function byte2(w) { return String.fromCharCode((w>>8)&255, w&255); }
	function byte4(w) { return String.fromCharCode((w>>24)&255, (w>>16)&255, (w>>8)&255, w&255); }
	function byte2lsb(w) { return String.fromCharCode(w&255, (w>>8)&255); };

	// initialize everything to zero byte
	var zero = String.fromCharCode(0);
	for (var i = 0; i < png_size; i += 1)
		png[i] = zero;

	// initialize non-zero elements
	initialize(png, ihdr_offs, byte4(ihdr_size-12), 'IHDR',
				byte4(width), byte4(height), String.fromCharCode(8, 6));	// 8 bit channel, truecolor with alpha
	initialize(png, idat_offs, byte4(idat_size-12), 'IDAT');
	initialize(png, iend_offs, byte4(iend_size-12), 'IEND');

	// initialize deflate header
	var header = ((8 + (7<<4)) << 8) | (3 << 6);	// FIX.ME - this magic number needs documentation
	header += 31 - (header % 31);					// FIX.ME - this magic number needs documentation
	initialize(png, idat_offs+8, byte2(header));

	// copy filter+pixel data into holes in deflate blocks
	for (var y = 0; y < height; y += 1) {
		for (var x = 0; x < width; x += 1) {
			var color = this.pindex[this.getPoint(x,y)];
			png[outputIndex(x,y,0)] = String.fromCharCode(color.red);
			png[outputIndex(x,y,1)] = String.fromCharCode(color.green);
			png[outputIndex(x,y,2)] = String.fromCharCode(color.blue);
			png[outputIndex(x,y,3)] = String.fromCharCode(color.alpha);
		}
	}

	// initialize deflate block headers
	for (i = 0; i*0xffff < pix_size; i += 1) {
		var size, bits;
		if (i + 0xffff < pix_size) {
			size = 0xffff;
			bits = String.fromCharCode(0);
		} else {
			size = pix_size - i*0xffff;
			bits = String.fromCharCode(1);
		}
		initialize(png, idat_offs+8+2+i*(5+0xffff), bits, byte2lsb(size), byte2lsb(~size));
	}

	// compute adler32 of filter + pixel data in holes
	var BASE = 65521; /* largest prime smaller than 65536 */
	var NMAX = 5552;  /* NMAX is the largest n such that 255n(n+1)/2 + (n+1)(BASE-1) <= 2^32-1 */
	var s1 = 1;
	var s2 = 0;
	var n = NMAX;
	for (var y = 0; y < height; y += 1)
		for (var x = 0; x < width; x += 1) {
			var minc = (x == 0) ? -1 : 0;
			for (var c = minc; c < 4; c += 1) {
				s1 += png[outputIndex(x,y,c)].charCodeAt(0);
				s2 += s1;
				if ((n -= 1) == 0) {
					s1 %= BASE;
					s2 %= BASE;
					n = NMAX;
				}
			}
		}
	s1 %= BASE;
	s2 %= BASE;
	initialize(png, idat_offs+idat_size-8, byte4((s2 << 16) | s1));

	// compute crc32 of the PNG chunks
	function crc32(png, offs, size) {
		var crc = -1;		// initialize crc
		for (var i = 4; i < size-4; i += 1)
			crc = Pnglet.crc32_table[(crc ^ png[offs+i].charCodeAt(0)) & 0xff] ^ ((crc >> 8) & 0x00ffffff);
		initialize(png, offs+size-4, byte4(crc ^ -1));
	}

	crc32(png, ihdr_offs, ihdr_size);
	crc32(png, idat_offs, idat_size);
	crc32(png, iend_offs, iend_size);

	// convert PNG to string
	return "\211PNG\r\n\032\n"+png.join('');
}

/* Table of CRCs of all 8-bit messages. */
Pnglet.crc32_table = new Array(256);
for (var n = 0; n < 256; n++) {
	var c = n;
	for (var k = 0; k < 8; k++) {
		if (c & 1)
			c = -306674912 ^ ((c >> 1) & 0x7fffffff);
		else
			c = (c >> 1) & 0x7fffffff;
	}
	Pnglet.crc32_table[n] = c;
}

