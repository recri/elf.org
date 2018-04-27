/*
** hand object
*/
function hand_node(attr, id, r, d) {
  var error = window.alert;
  var log = window.alert;
  var info = window.alert;
  var warn = window.alert;

  /*
  ** rotation string caching
  */
  var rotate = [];

  function rotate_string(phi) {
	if (rotate[phi] === undefined) rotate[phi] = "rotate("+phi+")";
	return rotate[phi];
  }

  /*
  ** attribute merging
  */
  function merge_attr(attr1, attr2) {
	if (attr2)
	  for (var i in attr2)
		if (attr1[i] === undefined)
		  attr1[i] = attr2[i];
	return attr1;
  }

  /*
  ** supply the hand shape parameters.
  ** for lozenge:
  ** wr is the length of the hand
  ** wx is the radius at the widest point
  ** wy is the half-width at the widest point
  ** for bar:
  */
  function hand_shape_params(shape, id, r, d, attr2) {
	var attr1;
	if (shape == 'lozenge') {
	  switch (id) {
	  case 'h':
		attr1 = {shape: 'lozenge', id: id, wr: 2*r/3, wx: 4*r/9, wy: r/30, fill:'black', stroke:'black', opacity: 1};
		return merge_attr(attr1, attr2);
	  case 'm':
		attr1 = {shape: 'lozenge', id: id, wr: r, wx: 2*r/3, wy: r/30, fill:'black', stroke:'black', opacity: 1};
		return merge_attr(attr1, attr2);
	  case 's':
		attr1 = {shape: 'lozenge', id: id, wr: r, wx:7*r/8, wy: r/75, fill:'red', stroke:'red', opacity: 1};
		return merge_attr(attr1, attr2);
	  }
	} else if (shape == 'bar') {
	  switch (id) {
	  case 'h':
	    attr1 = {shape: 'line', id: id, r1: 2*r/3, r2: 0, "stroke-width": 15, fill:'black', stroke:'black', opacity: 1, "stroke-linecap": 'round'};
	    return merge_attr(attr1, attr2);
	  case 'm':
	    attr1 = {shape: 'line', id: id, r1: r,     r2: 0, "stroke-width": 10, fill:'black', stroke:'black', opacity: 1, "stroke-linecap": 'round'};
	    return merge_attr(attr1, attr2);
	  case 's':
	    attr1 = {shape: 'line', id: id, r1: r,     r2: 0, "stroke-width": 5,  fill:'red',   stroke:'red',   opacity: 1, "stroke-linecap": 'round'};
	    return merge_attr(attr1, attr2);
	  }
	} else if (shape == 'circle' || shape == 'square' || shape == 'diamond' || shape == 'triangle') {
	  if (d === undefined)
		d = 2 * Math.PI * r / 60;
	  attr1 = {shape: shape, id: id, r: r, d: d}
	  return merge_attr(attr1, attr2);
	}
	error('unknown '+id+' hand shape: '+shape);
  }

  /*
  ** more complicated constructors.  - graphics agnostic
  ** note that this function identical to the svg.js version
  ** but this one returns functions where the other returns nodes
  */
  function hand_shape_node(t) {
	var attr = {};

	if (t.id !== undefined) 
	  attr["class"] = t.id+"-hand";
	attr.transform = "";
	if (t.theta !== undefined)
	  attr.transform += rotate_string(t.theta+90);
	else
	  attr.transform += rotate_string(90);
	if (t.r !== undefined)
	  attr.transform += " translate(0,"+(-t.r)+")";
	if (t.scale !== undefined)
	  attr.transform += " scale("+t.scale+")";
	if (t.color !== undefined)
	  attr.fill = attr.stroke = t.color;
	else if (t.fill !== undefined || t.stroke !== undefined) {
	  if (t.fill !== undefined)
		attr.fill = t.fill;
	  if (t.stroke !== undefined)
		attr.stroke = t.stroke;
	} else
	  attr.fill = attr.stroke = 'black';

	if (t.opacity !== undefined)
	  attr.opacity = t.opacity;
	if (t["stroke-width"] !== undefined)
	  attr["stroke-width"] = t["stroke-width"];
	if (t["stroke-linecap"] !== undefined)
	  attr["stroke-linecap"] = t["stroke-linecap"];
	if (t["stroke-linejoin"] !== undefined)
	  attr["stroke-linejoin"] = t["stroke-linejoin"];

	// fill-opacity, stroke-opacity

	var func = {
	circle: function() {
		attr.r = t.d/2;
		return circle_node(attr);
	  },
	square: function() {
		attr.points = [ -t.d/2, -t.d/2, t.d/2, -t.d/2, t.d/2, t.d/2, -t.d/2, t.d/2 ].join();
		return polygon_node(attr);
	  },
	diamond: function() {
		attr.points = [ 0, t.d/2, t.d/2, 0, 0, -t.d/2, -t.d/2, 0 ].join();
		return polygon_node(attr);
	  },
	triangle: function() {
		attr.points = [ t.d/2, t.d/2, 0, -t.d/2, -t.d/2, +t.d/2 ].join();
		return polygon_node(attr);
	  },
	lozenge: function() {
		attr.points = "0,0 "+t.wy+","+(-t.wx)+" 0,"+(-t.wr)+" "+(-t.wy)+","+(-t.wx);
		return polygon_node(attr);
	  },
	line: function() {
		attr.points = [0, -t.r1, 0, -t.r2].join();
		return polyline_node(attr);
	  }
	};
	if (func[t.shape] !== undefined)
	  return func[t.shape]();
	else {
	  alert("shape = "+t.shape+" did not match any case");
	  return null;
	}
  }

  function classical_hand_node(attr, id, r, d, ni) {
	// make a node
	var hand = g_node({id: id});
	// get the shape attributes
	var t = hand_shape_params(attr.hand_shape, id, r, d);
	// append the shaped node to the node
	hand.appendChild(hand_shape_node(t));
	// arrange to be able to position the hand
	if (attr.impl == 'svg') {
	  hand.setAngle = function(phi, j) {
		this.setAttribute('transform', rotate_string(phi));
	  }
	  return hand;
	}
	if (attr.impl == 'canvas') {
	  hand.setAngle = function(phi, j) {
		this.rotation = phi/360*2*Math.PI;
	  }
	  hand.old_paint = hand.paint;
	  hand.paint = function(context) {
		context.save();
		context.rotate(this.rotation);
		this.old_paint(context);
		context.restore();
	  }
	  return hand;
	}
	error("failed to return a hand from classical_hand_node");
  }

  function quantum_hand_node(attr, id, r, d, ni, nj) {
	var is_svg = attr.impl == 'svg';
	// make the quantum "hand" position holder
	var hand = g_node({id: id});
	// get the shape attributes
	var t = hand_shape_params(attr.hand_shape, id, r, d);
	// radius of shift register
	var one = d / 2;
	// get the defs section
	var defs = is_svg ? document.getElementById("defs") : null;
	// set up the step identifier array
	hand.step_id = [];
	// set up array of objects
	hand.hands = [];
	// loop over the different fractional positions
	for (var j = 0; j < nj; j += 1) {
	  var f = j / nj;
	  hand.step_id.push('#'+id+"_"+j);
	  if (is_svg)
		hand.hands.push(g_node({id: hand.step_id[j].substr(1)}));
	  else
		hand.hands.push([]);
	  for (var i = 0; i < ni; i += 1) {
		var c = Phi_at(f, i, ni);
		var mag = cpxmag(c);
		if (mag > attr.mag_cut) {
		  t.theta = i/ni*360;
		  if (attr.hand_style.indexOf('dwindle') >= 0)
			t.scale = Math.sqrt(mag);
		  if (attr.hand_style.indexOf('thin') >= 0)
			t.scale = mag+",1";
		  if (attr.hand_style.indexOf('fade') >= 0)
			t.opacity = mag;
		  if (attr.hand_style.indexOf('phase') >= 0) {
			var rmag = Math.abs(c.r);
			if (is_svg) {
			  var color = interpolate_color(attr.real_color, attr.imag_color, rmag/mag);
			  t.fill = color;
			  t.stroke = color;
			} else {
			  t.frac = rmag/mag;
			  t.real = attr.real_color;
			  t.imag = attr.imag_color;
			}
		  }
		  if (is_svg)
			hand.hands[j].appendChild(hand_shape_node(t));
		  else
			hand.hands[j].push(merge_attr({}, t));
		}
	  }
	  if (is_svg)
		defs.appendChild(hand.hands[j]);
	}
	if (is_svg) {
	  hand.use_id = "u_"+id;
	  hand.appendChild(use_node({id: hand.use_id}));
	  hand.setAngle = function(phi, j) {
		this.setAttribute('transform', rotate_string(phi));
		set_href(document.getElementById(this.use_id), this.step_id[j]);
	  }
	  return hand;
	} else {
	  // this isn't all required by canvas, it's the mobile webkit
	  // which craps out on the untweaked rendering.
	  hand.rotation = 0;
	  hand.step = null;
	  hand.setAngle = function(phi, j) {
		this.rotation = phi/360*2*Math.PI;
		this.step = hand.hands[j];
		if (this.step[0].shape !== undefined) {
		  for (var i in this.step) {
			var t = this.step[i];
			if (t.frac !== undefined)
			  t.fill = t.stroke = interpolate_color(t.real, t.imag, t.frac);
			this.step[i] = t = hand_shape_node(t);
		  }
		}
	  }
	  hand.paint = function(context) {
		context.save();
		context.rotate(this.rotation);
		for (var i in this.step)
		  this.step[i].paint(context);
		context.restore();
	  }
	  return hand;
	}
	error("failed to return a hand from quantum_hand_node");
  }

  var node;
  if (attr.kind == 'continuous' || attr.kind == 'discrete') {
	  if (attr.dial == '3ring') {
		if (id == "h")
		  node = classical_hand_node(attr, id, r-3.5*d, 0.95*d, 12*attr.sph);
		else if (id == "m")
		  node = classical_hand_node(attr, id, r-2.5*d, 0.95*d, 60);
		else if (id == "s")
		  node = classical_hand_node(attr, id, r-1.5*d, 0.95*d, 60);
	  } else if (attr.dial == 'face') {
		if (id == "h")
		  node = classical_hand_node(attr, id, r-1.5*d, 0.95*d, 12*attr.sph);
		else if (id == "m")
		  node = classical_hand_node(attr, id, r-1.5*d, 0.95*d, 60);
		else if (id == "s")
		  node = classical_hand_node(attr, id, r-1.5*d, 0.95*d, 60);
	  }
  } else if (attr.kind == 'quantum') {
	  if (attr.dial == '3ring') {
		if (id == "h")
		  node = quantum_hand_node(attr, id, r-3.5*d, 0.95*d, 12*attr.sph, Math.floor(attr.hour_steps/attr.sph));
		else if (id == "m")
		  node = quantum_hand_node(attr, id, r-2.5*d, 0.95*d, 60, attr.minute_steps);
		else if (id == "s")
		  node = quantum_hand_node(attr, id, r-1.5*d, 0.95*d, 60, attr.second_steps);
	  } else if (attr.dial == 'face') {
		if (id == "h")
		  node = quantum_hand_node(attr, id, r-1.5*d, 0.95*d, 12*attr.sph, Math.floor(attr.hour_steps/attr.sph));
		else if (id == "m")
		  node = quantum_hand_node(attr, id, r-1.5*d, 0.95*d, 60, attr.minute_steps);
		else if (id == "s")
		  node = quantum_hand_node(attr, id, r-1.5*d, 0.95*d, 60, attr.second_steps);
	  }
  } else if (attr.kind == 'qcsr') {
	if (id == 'd')
	  node = classical_hand_node(attr, id, r-1.5*d, 0.95*d, 60);
	else if (id == 'c') 
	  node = classical_hand_node(attr, id, r-2.5*d, 0.95*d, 60);
	else if (id == 'q')
	  node = quantum_hand_node(attr, id, r-3.5*d, 0.95*d, 60, attr.second_steps);
  }
  if (node === undefined)
	error("hand_node for "+attr.kind+", "+attr.dial+", and "+id+" is undefined");
  return node;
}

/*
** clock object
*/
function clock() {
  var error = window.alert;
  var log = window.alert;
  var info = window.alert;
  var warn = window.alert;

  /*
  ** find an element in a list
  */
  function member(x, l) {
	for (var i in l)
	  if (x == l[i])
		return x;
	error("value "+x+" is not a member of "+l.join());
  }

  /*
  ** clock dial - graphics agnostic
  */
  function dial_node(attr) {
	var r = attr.r;
	var d = attr.d;
	var width = attr.width;
	var height = attr.height;
	var r2 = r-d;
	var rings = attr.rings || 0;
	var g = g_node({'id': 'dial', 'class': 'dial'});
	g.appendChild(circle_node({r: r, fill: 'none', stroke: 'black'}));
	g.appendChild(circle_node({r: r2, fill: 'none', stroke: 'black'}));
	for (var i = 0; i < 60; i += 1) {
	  var phi = i / 60 * 2 * Math.PI;
	  var sinphi = Math.sin(phi);
	  var cosphi = Math.cos(phi);
	  g.appendChild(line_node({x1: r*cosphi, y1: r*sinphi, x2: r2*cosphi, y2: r2*sinphi,
			  stroke: 'black',
			  "stroke-width": (i%15) == 0 ? 10 : (i%5) == 0 ? 5 : 1 }));
	}
	while (rings > 0) {
	  rings -= 1;
	  r2 -= d;
	  g.appendChild(circle_node({r: r2, fill: 'none', stroke: 'black'}));
	}
	return g;
  }

  /*
  ** hours labels
  */
  function hours_labels_node(attr) {
	var r = attr.r;
	var s = attr.s;
	var g = g_node({id: 'hours_labels'});
	for (var i = 1; i <= 12; i +=1) {
	  var phi = (i - 3) / 12 * 2 * Math.PI;
	  g.appendChild(text_node(i, { x: Math.cos(phi)*r, y: (Math.sin(phi)*r+s/3),
			  "class": "hour_label",
			  "font-size": s,
			  "font-weight": 'bold',
			  "font-family": 'arial',
			  "text-anchor": 'middle'
			  }));
	}
	return g;
  }

  /*
  ** positioner function.
  */
  function position_the_hands(clock) {
	var now = new Date();
	var hours = now.getHours();
	var minutes = now.getMinutes();
	var seconds = now.getSeconds();
	var milliseconds = now.getMilliseconds();
	// implement stops/hour, ie clock.sph 
	var stops_per_hour = clock.sph;
	var stops = stops_per_hour * 12;
	var minutes_per_stop = 12 * 60 / stops;
	var degree_per_stop = 360 / stops;
	var minutes_since_12 = (hours % 12) * 60 + minutes;
	var hphi, hj, mphi, mj, sphi, sj;

	if (clock.kind == 'quantum') {
	  // sph*12 hour/sph period in degrees
	  hphi = Math.floor(minutes_since_12 / minutes_per_stop) * degree_per_stop - 90;
	  // fraction of hour/sph in hour_steps
	  hj = Math.floor(clock.hour_steps/stops_per_hour * (minutes_since_12 % minutes_per_stop) / minutes_per_stop);
	  // minutes in degrees
	  mphi = minutes * 6 - 90;
	  // fraction of minute in minute_steps
	  mj = Math.floor(clock.minute_steps * seconds / 60);
	  // seconds in degrees
	  sphi = seconds * 6 - 90;
	  // fraction of second in second_steps
	  sj = Math.floor(clock.second_steps * milliseconds / 1000);
	} else if (clock.kind == 'continuous') {
	  // fraction of sph*12*hour/sph period in degrees
	  hphi = (minutes_since_12 / (12*60)) * 360 - 90;
	  hj = 0;
	  // minutes in degrees
	  mphi = (minutes + seconds / 60) * 6 - 90;
	  mj = 0;
	  // seconds in degrees
	  sphi = (seconds + milliseconds / 1000) * 6 - 90;
	  sj = 0;
	} else if (clock.kind == 'discrete') {
	  // hours/sph in degrees, no fraction
	  hphi = Math.floor(minutes_since_12 / minutes_per_stop) * degree_per_stop - 90;
	  hj = 0;
	  // minutes in degrees, no fraction
	  mphi = (minutes) * 6 - 90;
	  mj = 0;
	  // seconds in degrees, no fraction
	  sphi = (seconds) * 6 - 90;
	  sj = 0;
	} else if (clock.kind == 'qcsr') {
	  // seconds in degrees
	  sphi = seconds * 6 - 90;
	  // fraction of second in second_steps
	  sj = Math.floor(clock.second_steps * milliseconds / 1000);
	}
	
	try {
	  if (clock.kind == 'qcsr') {
		clock.quantum_hand.setAngle(sphi, sj);
		clock.continuous_hand.setAngle(sphi+6*sj/clock.second_steps, 0);
		clock.discrete_hand.setAngle(sphi, 0);
	  } else {
		clock.hour_hand.setAngle(hphi, hj);
		clock.minute_hand.setAngle(mphi, mj);
		clock.second_hand.setAngle(sphi, sj);
	  }
	  if (clock.impl == 'canvas') {
		clock.context.clearRect(0, 0, clock.width, clock.height);
		clock.g.paint(clock.context);
	  }
	  setTimeout("tick_tock()", 1000/clock.steps);
	} catch(e) {
	  error("exception in draw_clock: '"+e+"' attempting: "+attempting);
	}

  }

  /*
  ** establish the parameters, synonyms, default values, and validations
  ** to apply to our window.location.search string
  */
  var clocks = {
	// the prototype defines the canonical names for parameters
	// and the abbreviations that expand into canonical names
	// a canonical name expands into itself
  proto: {
	width: 'width', wd: 'width',				// width of parent frame
	height: 'height', ht: 'height',				// height of parent frame
	dpi: 'dpi',					// dots per inch
	steps: 'steps',				// steps per second
	real_color: 'real_color',
	imag_color: 'imag_color',
	sph: 'sph',					// steps per hour, 1, 2, 3, 4, or 5
	id: 'id',						// id for clock
	view_id: 'view_id',			// id for viewBox
	parent_id: 'parent_id',
	hour_radius: 'hour_radius',
	hour_steps: 'hour_steps',
	minute_radius: 'minute_radius',
	minute_steps: 'minute_steps',
	second_radius: 'second_radius',
	second_steps: 'second_steps',
	hand_shape: 'hand_shape',
	mag_cut: 'mag_cut',
	hand_style: 'hand_style',
	impl: 'impl',
	kind: 'kind',
	rings: 'rings',
	dial: 'dial',
	hours_labels: 'hours_labels',
	hours_labels_radius: 'hours_labels_radius',
	hours_labels_scale: 'hours_labels_scale'
  },
  // default values for parameters
  defaults: {
	width: 200,
	height: 200,
	dpi: 100,
	steps: 8,
	real_color: '#ff0000',
	imag_color: '#0000ff',
	sph: 5,
	id: 'clock',
	view_id: 'clock_view',
	parent_id: null,
	hour_radius: '66%',
	hour_steps: 256,
	minute_radius: '95%',
	minute_steps: 64,
	second_radius: '95%',
	second_steps: 16,
	hand_shape: 'circle',
	mag_cut: 0.07,
	hand_style: 'phase,dwindle',
	impl: 'canvas',
	kind: 'quantum',
	dial: '3ring',
	hours_labels: false,
	hours_labels_radius: "80%",
	hours_labels_scale: 50
  },
  // functions that validate the parameters values
  validations: {
	width: function(x) { return new Number(x); },
	height: function(x) { return new Number(x); },
	dpi: function(x) { return new Number(x); },
	steps: function(x) { return new Number(x); },
	real_color: function(x) { return new String(x); },
	imag_color: function(x) { return new String(x); },
	sph: function(x) { return new Number(x); },
	id: function(x) { return new String(x); },
	view_id: function(x) { return x; },
	parent_id: function(x) { return x; },
	hour_radius: function(x) { return new String(x); },
	hour_steps: function(x) { return new Number(x); },
	minute_radius: function(x) { return new String(x); },
	minute_steps: function(x) { return new Number(x); },
	second_radius: function(x) { return new String(x); },
	second_steps: function(x) { return new Number(x); },
	hand_shape: function(x) { return member(x, ['circle', 'square', 'diamond', 'triangle', 'lozenge', 'bar', 'line']); },
	mag_cut: function(x) { return new Number(x); },
	hand_style: function(x) { return new String(x); },
	impl: function(x) { return member(x, ['canvas', 'svg']); },
	kind: function(x) { return member(x, ['quantum', 'continuous', 'discrete', 'qcsr']); },
	dial: function(x) { return member(x, ['3ring', 'face']); },
	hours_labels: function(x) { return x; },
	hours_labels_radius: function(x) { return new String(x); },
	hours_labels_scale: function(x) { return new Number(x); }
  },
  // the values parsed, defaulted, validated and returned
  // and all global values
  c: {
	search: ""                         // document search contents
  }
  }

  /*
  ** parse the window.location.search string
  */
  this.parse_clock = function(search) {
	// parse the parameters
	var params = parse_search(clocks, search);

	// copy params
	for (var i in params)
	  this[i] = params[i];

	// resize the parent embedded object
	// ie7 forbids this, firefox ends up with scrolling
	// try {
	//     window.resizeTo(c.view_width, c.view_height);
	// } catch(e) { }
	// ie7 forbids this, firefox gets a reasonable frame
	try {
	  if (this.parent_id && window && window.parent && window.parent.document) {
		if (window.parent.document.getElementById(this.parent_id)) {
		  this.parent = window.parent.document.getElementById(this.parent_id);
		  // alert("window.parent.document.getElementById('calendar') returned: "+obj);
		  set_attr(this.parent, {width: this.width, height: this.height});
		}
	  }
	} catch(e) {
	  // ignore it
	  // alert("caught access to parent.document");
	}
	// get the view svg document
	// alert("setting view width="+c.view_width+" and height="+c.view_height);
	if (this.view_id && document.getElementById(this.view_id)) {
	  this.view = document.getElementById(this.view_id);
	  set_attr(this.view, {width: this.width/this.dpi+"in",
			height: this.height/this.dpi+"in",
			viewBox: "0 0 "+this.width+" "+this.height});
	}
	// get the root svg document    
	this.root = document.getElementById(this.id);
	set_attr(this.root, {width: this.width+"px", height: this.height+"px"});

  }

  /*
  ** start the clock running
  */
  this.start_clock = function(search) {
	// parse parameters from window.location.search
	this.parse_clock(search);

	// geometries
	var width = this.width,
	    height = this.height,
		r = Math.min(width, height)*0.95/2,		// the radius that fits our space
		d = 2 * Math.PI * r / 60;				// the size of 1/60th of the circumference

	// get a root group node
	var g = g_node({transform: "translate("+width/2+","+height/2+")"});

	// append the root g node to the root svg node
	if (this.impl == 'svg')
	  this.root.appendChild(g);					// fix.me - svg specific

	// get the drawing context
	if (this.impl == 'canvas')
	  this.context = this.root.getContext("2d"); // fix.me - canvas specific

	// make a dial ring
	if (this.dial == '3ring')
	  g.appendChild(dial_node({r: r, d: d, width: width, height: width, rings: 3}));
	else if (this.dial == 'face')
	  g.appendChild(dial_node({r: r, d: d, width: width, height: width, rings: 0}));

	// make hour labels
	// fix.me - implement text_node for canvas
	if (this.hours_labels && this.impl == 'svg')
	  g.appendChild(hours_labels_node({r: this.hours_labels_radius, s: this.hours_labels_scale}));

	// make hands
	if (this.kind == 'qcsr') {
	  this.discrete_hand = hand_node(this, "d", r, d);
	  g.appendChild(this.discrete_hand);
	  this.continuous_hand = hand_node(this, "c", r, d);
	  g.appendChild(this.continuous_hand);
	  this.quantum_hand = hand_node(this, "q", r, d);
	  g.appendChild(this.quantum_hand);
	  if (this.discrete_hand === undefined) error("this.discrete_hand is undefined");
	  if (this.continuous_hand === undefined) error("this.continuous_hand is undefined");
	  if (this.quantum_hand === undefined) error("this.quantum_hand is undefined");
	} else {
	  this.hour_hand = hand_node(this, "h", r, d);
	  g.appendChild(this.hour_hand);
	  this.minute_hand = hand_node(this, "m", r, d);
	  g.appendChild(this.minute_hand);
	  this.second_hand = hand_node(this, "s", r, d)
		g.appendChild(this.second_hand);
	  if (this.hour_hand === undefined) error("this.hour_hand is undefined");
	  if (this.minute_hand === undefined) error("this.minute_hand is undefined");
	  if (this.second_hand === undefined) error("this.second_hand is undefined");
	}

	// remember display root
	this.g = g;

	// position the hands
	var this_clock = this;
	window.tick_tock = function() { position_the_hands(this_clock); }
	tick_tock();
  }
}

function start_clock(search) {
  new clock().start_clock(search);
}

function set_attr(node, attr) {
  for (var i in attr)
	node.setAttribute(i, ""+attr[i]);
  return node;
}

