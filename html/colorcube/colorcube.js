//
// Generate a slice through the browser safe colorcube
//
var rgb1, rgb2, rgb3, use_files = false;

// Build the colorcube table
function colorcube() {

  // dimension of a colorcube cell on the screen
  var cell = 40;

  // make an image for a button
  function buttonImage() {
    var src = use_files ? "images/c119.gif" : Giflet.c119.src();
    return '<img height="38" width="38" border="0" src="'+src+'">';
  }

  // make a button which makes a new colorcube slice.
  function colorcubebutton(op) {
    document.write('<td vspace="0" hspace="0" align="center" valign="center">',
		   '<a href="javascript:'+op+'">',
		   buttonImage(cell),
		   '</a></td>\n');
  }

  // make an image for a cell
  function colorImage(n) {
    var src = use_files ? "images/pixel.gif" : Giflet.transparent.src();
    return '<img width="'+cell+'" height="'+cell+'" border="0" name="'+n+'" src="'+src+'">';
  }

  // make a button which displays its color
  function colorcubecell(name) {
    document.write('<td vspace="0" hspace="0">',
		   '<a href="rgb:0/0/0" onclick="javascript:return false">',
		   colorImage(name),
		   '</a>',
		   '</td>\n');
  }
  
  // write the colorcube web page
  document.write('<table cellspacing="0" cellpadding="0" border="0">\n');

  // top margin
  document.write('<tr>\n');
  colorcubebutton("more('black')");
  colorcubebutton("more('red')");
  colorcubebutton("more('yellow')");
  colorcubebutton("more('green')");
  colorcubebutton("more('cyan')");
  colorcubebutton("more('blue')");
  colorcubebutton("more('magenta')");
  colorcubebutton("more('white')");
  document.write('</tr>\n');

  for (var i = 0; i < 6; i += 1) {
    document.write('<tr>\n');

    // left margin
    if (i==0) colorcubebutton("permute(1,2,3)");
    if (i==1) colorcubebutton("permute(1,3,2)");
    if (i==2) colorcubebutton("permute(2,1,3)");
    if (i==3) colorcubebutton("permute(2,3,1)");
    if (i==4) colorcubebutton("permute(3,1,2)");
    if (i==5) colorcubebutton("permute(3,2,1)");
    
    // main body
    for (var j = 0; j < 6; j += 1) colorcubecell('r'+i+'c'+j);
    
    // right margin
    if (i==0) colorcubebutton("rotate(1,2,3)");
    if (i==1) colorcubebutton("rotate(1,3,2)");
    if (i==2) colorcubebutton("rotate(2,1,3)");
    if (i==3) colorcubebutton("rotate(2,3,1)");
    if (i==4) colorcubebutton("rotate(3,1,2)");
    if (i==5) colorcubebutton("rotate(3,2,1)");

    document.write('</tr>\n');
  }

  // bottom margin
  document.write('<tr>\n');
  colorcubebutton("less('black')");
  colorcubebutton("less('red')");
  colorcubebutton("less('yellow')");
  colorcubebutton("less('green')");
  colorcubebutton("less('cyan')");
  colorcubebutton("less('blue')");
  colorcubebutton("less('magenta')");
  colorcubebutton("less('white')");
  document.write('</tr>\n');

  document.write('</table>\n');

  document.close();
}

function planeToCells(rgb1, rgb2, rgb3) {
  // divide out the browser palette granularity
  rgb1 = rgb1.scale(1/51);
  rgb2 = rgb2.scale(1/51);
  rgb3 = rgb3.scale(1/51);

  // generate a frame for the plane
  var y = rgb2.sub(rgb1).normalize();
  var x = rgb3.sub(rgb1).normalize();
  var z = x.cross(y).normalize();
  x = y.cross(z);
  var d = z.dot(rgb1);
  // the formula for the plane is p.dot(z) - d = 0
  
  // find the closest basis vector to v
  function closest(v, vx, vy, vz, not) {
    if (not) {
      if (not.equals(vx) || not.equals(vx.neg())) vx = vy;
      else if (not.equals(vy) || not.equals(vy.neg())) vy = vz;
      else if (not.equals(vz) || not.equals(vz.neg())) vz = vx;
    }
    var n = (Math.abs(v.dot(vx)) > Math.abs(v.dot(vy))) ? 
    (Math.abs(v.dot(vx)) > Math.abs(v.dot(vz))) ? vx : vz :
    (Math.abs(v.dot(vy)) > Math.abs(v.dot(vz))) ? vy : vz ;
    return (v.dot(n) < 0) ? n.neg() : n;
  }
    
  // project the plane frame to the colorcube frame
  var nx = closest(x,Vector.x,Vector.y,Vector.z);
  var ny = closest(y,Vector.y,Vector.z,Vector.x,nx);
  var nz = nx.cross(ny).normalize();

  if (nx.equals(ny) || ny.equals(nz) || nz.equals(nx)) {
    confirm("equal axes chosen:\n"+
	    "x = "+x[0]+" "+x[1]+" "+x[2]+"\n"+
	    "y = "+y[0]+" "+y[1]+" "+y[2]+"\n"+
	    "z = "+z[0]+" "+z[1]+" "+z[2]+"\n"+
	    "nx = "+nx[0]+" "+nx[1]+" "+nx[2]+"\n"+
	    "ny = "+ny[0]+" "+ny[1]+" "+ny[2]+"\n"+
	    "nz = "+nz[0]+" "+nz[1]+" "+nz[2]);
  }

  // build the cells
  var c = new Array(new Array(6), new Array(6), new Array(6), new Array(6), new Array(6), new Array(6));
  for (var i = 0; i < 6; i += 1) {
    for (var j = 0; j < 6; j += 1) {
      var v = nx.scale(i).add(ny.scale(j));
      var k = (d - z.dot(v)) / z.dot(nz);
      v = v.add(nz.scale(k));
      for (index in v) v[index] = Math.floor((v[index]+36)%6)*51;
      c[i][j] = new Object();
      c[i][j].r = v[0];
      c[i][j].g = v[1];
      c[i][j].b = v[2];
      //document.write("cell[", i, "][", j, "] = ", v[0], " ", v[1], " ", v[2], "<br>\n");
    }
  }
  return c;
}

// translate the points
function translate(dr1, dg1, db1, dr2, dg2, db2, dr3, dg3, db3) {
  function reduce(v) { return v < 0 ? 255 : v > 256 ? 0 : v; }
  rgb1[0] = reduce(rgb1[0] + dr1*51); rgb1[1] = reduce(rgb1[1] + dg1*51); rgb1[2] = reduce(rgb1[2] + db1*51);
  rgb2[0] = reduce(rgb2[0] + dr2*51); rgb2[1] = reduce(rgb2[1] + dg2*51); rgb2[2] = reduce(rgb2[2] + db2*51);
  rgb3[0] = reduce(rgb3[0] + dr3*51); rgb3[1] = reduce(rgb3[1] + dg3*51); rgb3[2] = reduce(rgb3[2] + db3*51);
  return void redrawcube();
}

// permute the points
function permute(a,b,c) {
  var trgb1 = a == 1 ? rgb1 : a == 2 ? rgb2 : rgb3;
  var trgb2 = b == 1 ? rgb1 : b == 2 ? rgb2 : rgb3;
  var trgb3 = c == 1 ? rgb1 : c == 2 ? rgb2 : rgb3;
  rgb1 = trgb1;
  rgb2 = trgb2;
  rgb3 = trgb3;
  return void redrawcube();
}

// permute the colors
function rotate(r,g,b) {
  var r1 = rgb1[r-1], g1 = rgb1[g-1], b1 = rgb1[b-1];
  var r2 = rgb2[r-1], g2 = rgb2[g-1], b2 = rgb2[b-1];
  var r3 = rgb3[r-1], g3 = rgb3[g-1], b3 = rgb3[b-1];
  rgb1[0] = r1; rgb1[1] = g1; rgb1[2] = b1;
  rgb2[0] = r2; rgb2[1] = g2; rgb2[2] = b2;
  rgb3[0] = r3; rgb3[1] = g3; rgb3[2] = b3;
  return void redrawcube();
}

// choose random points
function randomcube() {
  rgb1 = new Vector(51*Math.floor(Math.random()*6), 51*Math.floor(Math.random()*6), 51*Math.floor(Math.random()*6));
  rgb2 = new Vector(51*Math.floor(Math.random()*6), 51*Math.floor(Math.random()*6), 51*Math.floor(Math.random()*6));
  rgb3 = new Vector(51*Math.floor(Math.random()*6), 51*Math.floor(Math.random()*6), 51*Math.floor(Math.random()*6));
  return void redrawcube();
}

// fill in the cube
function redrawcube() {
  // if it's singular, then try again
  if (rgb1.equals(rgb2) || rgb2.equals(rgb3) || rgb3.equals(rgb1))
    randomcube();

  // find the cells to display
  var c = planeToCells(rgb1, rgb2, rgb3);

  // a function to translate r,g,b into file names
  function giffile(r,g,b) {
    function hexString(i) { return (i < 16 ? '0' : '')+i.toString(16); }
    function hexColor() { return hexString(r)+hexString(g)+hexString(b); }
    return "images/i"+hexColor()+".gif";
  }

  // overwrite the cells
  for (var i = 0; i < 6; i += 1)
    for (var j = 0; j < 6; j += 1)
      with (c[i][j]) {
	document.images['r'+i+'c'+j].src = use_files ? giffile(r,g,b) : Gifblock(r, g, b).src();
	document.links[9+i*8+j].href = 'javascript:rgb('+r+', '+g+', '+b+')';
      } 
}

// transforms with snappy names
function more(color) { altercolor( 1, color); }
function less(color) { altercolor(-1, color); }

// do part of the work
function altercolor(delta,color) {
  if (color == 'red')
    translate(delta,0,0, delta,0,0, delta,0,0);
  else if (color == 'green')
    translate(0,delta,0, 0,delta,0, 0,delta,0);
  else if (color == 'blue')
    translate(0,0,delta, 0,0,delta, 0,0,delta);
  else if (color == 'yellow')
    translate(delta,delta,0, delta,delta,0, delta,delta,0);
  else if (color == 'magenta')
    translate(delta,0,delta, delta,0,delta, delta,0,delta);
  else if (color == 'cyan')
    translate(0,delta,delta, 0,delta,delta, 0,delta,delta);
  else if (color == 'white')
    translate(delta,delta,delta, delta,delta,delta, delta,delta,delta);
  else if (color == 'black')
    translate(-delta,-delta,-delta, -delta,-delta,-delta, -delta,-delta,-delta);
}
