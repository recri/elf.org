//
// ClipAnim - set up a new clip animation
// this constructor must be called in the header of the html page
// so it can out put a CSS style sheet that Netscape won't barf over.
//
// The remainder of the construction is done by calling place() where
// you want the animation placed.
//
function ClipAnim(left, top, width, height, img, imgwidth, imgheight, dx, dy, dt, n) {
  // width, height - x, y sizes for animation viewport
  // img - image containing frames animation
  // imgwidth, imgheight - sizes of image
  // timg - a transparent image used to fill space
  // dx, dy - distance to scroll per frame of animation
  // dt - time to view each frame
  // n - times to loop through animation
  this.left = left;
  this.top = top;
  this.width = width;
  this.height = height;
  this.img = new Image();
  this.img.src = img;
  this.imgwidth = imgwidth;
  this.imgheight = imgheight;
  this.dx = dx;
  this.dy = dy;
  this.dt = dt;
  this.n = n;
  this.id = 'clipanim'+ClipAnim.counter++;
  // 
  document.write('<style type="text/css">\n',
		 '  #'+this.id+'a {\n',
		 this.left || this.top ? '    position:absolute;\n' : '    position:relative;\n',
		 this.left ? '    left:'+this.left+';\n' : '',
		 this.top ? '    top:'+this.top+';\n' : '',
		 '    width:'+this.width+';\n',
		 '    height:'+this.height+';\n',
		 '    overflow:hidden;\n',
		 '  }\n',
		 '  #'+this.id+'b {\n',
		 '    position:absolute;\n',
		 '  }\n',
		 '</style>\n');
  //
  ClipAnim[this.id] = this;
}

ClipAnim.counter = 0;

ClipAnim.prototype.output = function() {
  document.write('<div id="'+this.id+'a"><div id="'+this.id+'b"\n',
		 '><table border="0" cellspacing="0" cellpadding="0"\n',
		 '><tr><td\n',
		 '><img src="'+this.img.src+'" height="'+this.imgheight+'" width="'+this.imgwidth+'" alt=""\n',
		 '></td><td\n',
		 '><img src="'+this.img.src+'" height="'+this.imgheight+'" width="'+this.imgwidth+'" alt=""\n',
		 '></td></tr><tr><td\n',
		 '><img src="'+this.img.src+'" height="'+this.imgheight+'" width="'+this.imgwidth+'" alt=""\n',
		 '></td><td\n',
		 '><img src="'+this.img.src+'" height="'+this.imgheight+'" width="'+this.imgwidth+'" alt=""\n',
		 '></td></tr></table\n',
		 '></div></div>\n');
  if (document.getElementById) {
    this.type = 1;
    this.elta = document.getElementById(this.id+'a');
    this.eltb = document.getElementById(this.id+'b');
    return true;
  } else if (document[this.id+'a']) {	/* nn specific */
    this.type = 2;
    this.elta = document[this.id+'a'];
    this.eltb = this.elta.document[this.id+'b'];
    // var my = this.elta.clip;
    // my.clip.x = 0;
    // my.clip.y = 0;
    // my.clip.width = this.width;
    // my.clip.height = this.height;
    return true;
  } else if (document.all[this.id+'a']) {
    this.type = 3;
    this.elta = document.all[this.id+'a'];
    this.eltb = this.elta.document.all[this.id+'b'];
    return true;
  } else {
    return false;
  }
}

ClipAnim.prototype.scroll = function() {
  var my = this.eltb;
  switch (this.type) {
  case 1:
    my = my.style;
    my.left = Math.round((my.left+this.dx-this.imgwidth)%this.imgwidth);
    my.top = Math.round((my.top+this.dy-this.imgheight)%this.imgheight);
    break;
  case 2:
    my.left = Math.round((my.left+this.dx-this.imgwidth)%this.imgwidth);
    my.top = Math.round((my.top+this.dy-this.imgheight)%this.imgheight);
    break;
  case 3:
    my = my.style;
    my.pixelLeft = Math.round((my.pixelLeft+this.dx-this.imgwidth)%this.imgwidth);
    my.pixelTop = Math.round((my.pixelTop+this.dy-this.imgheight)%this.imgheight);
  }
}

ClipAnim.prototype.start = function() {
  // if (this.type == 2) {	/* nn specific */
  // var my = this.elta.clip;
  // my.x = 0;
  // my.y = 0;
  // my.width = this.width;
  // my.height = this.height;
  // }
  this.timer = setInterval('ClipAnim.'+this.id+'.scroll()', this.dt);
}

ClipAnim.prototype.stop = function() {
  if (this.timer) clearInterval(this.timer);
  this.timer = false;
}
