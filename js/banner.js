// $Id: banner.js
var org = org || {};
org.elf = org.elf || {};
org.elf.banner = org.elf.banner || {
  // parameters
 edge: 512,						// edge of square background image
 vscale: 1/128,					// max fraction of edge moved per step
 dt: 100,						// ms per step
 x: 0,							// current x position
 y: 0,							// current y position
 dx: 1,							// x velocity
 dy: 1,							// y velocity
 position: function() {
	var my = org.elf.banner;
	$('#header').css('background-position', Math.floor(my.x)+'px '+Math.floor(my.y)+'px');
  },
 scroll: function() {
	var my = org.elf.banner;
	my.x = (my.x + my.dx + my.edge) % my.edge;
	my.y = (my.y + my.dy + my.edge) % my.edge;
	my.position();
  },
 init: function() {
	var my = org.elf.banner;
	my.x = Math.floor(Math.random()*my.edge);
	my.y = Math.floor(Math.random()*my.edge);
	my.dx = (Math.random()-0.5)*2*my.edge*my.vscale;
	my.dy = (Math.random()-0.5)*2*my.edge*my.vscale;
	my.position();
	setInterval(my.scroll, my.dt);
  }
};
$(document).ready(org.elf.banner.init);
