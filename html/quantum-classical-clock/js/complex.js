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
** Complex arithmetic and basis functions for quantum shift registers
*/
function cpx(real, imag) { return {r: real, i: imag}; }
function cpxreal(z1) { return z1.r; }
function cpximag(z1) { return z1.i; }
function cpxadd(z1, z2) { return cpx(z1.r+z2.r, z1.i+z2.i); }
function cpxmul(z1, z2) { return cpx(z1.r*z2.r-z1.i*z2.i, z1.r*z2.i+z2.r*z1.i); }
function cpxmulcnj(z1, z2) { return cpx(z1.r*z2.r+z1.i*z2.i, -z1.r*z2.i+z2.r*z1.i); }
function cpxcnj(z1) { return cpx(z1.r, -z1.i); }
function cpxmag(z1) { return Math.sqrt(z1.r*z1.r+z1.i*z1.i); }

/*
** The plain sinc function.
*/
function sinc(x) {
  x *= Math.PI;
  return x == 0 ? 1 : Math.sin(x)/x;
}

function sinc2(x) {
  var s = sinc(x);
  return s*s;
}

/*
** The positional basis function, small phi, for large N numbers of positions.
*/
function phi(x) {
  x *= Math.PI;
  var sinc = (x == 0 ?  1 : Math.sin(x)/x);
  return cpx(Math.cos(x) * sinc,Math.sin(x) * sinc);
}

function phi_mag(x) {
  return cpxmag(phi(x));
}

function real_phi(x) {
  var p = phi(x);
  return p.r;
}

function imag_phi(x) {
  var p = phi(x);
  return p.i;
}

/*
** the value of phi centered at c evaluated at x
*/
function phi_at(x, c) {
  return phi(x-c);
}

/*
** The positional basis funcitions, big Phi, for small N numbers of positions.
** (sin pi (u-m) / (N sin pi ((u-m)/N))) * e ^ ((i pi(u-m)) (1-1/N))
*/

function Phi(x, n) {
  x *= Math.PI;
  var sinc = x == 0 ? 1 : Math.sin(x)/(n*Math.sin(x/n));
  var y = x * (1-1/n);
  return cpx(Math.cos(y) * sinc, Math.sin(y) * sinc);
}
  
function Phi_mag(x, n) {
  return cpxmag(Phi(x, n));
}

function real_Phi(x, n) {
  return cpxreal(Phi(x, n));
}

function imag_Phi(x, n) {
  return cpximag(Phi(x, n));
}

function Phi_at(x, c, n) {
  return Phi(x-c, n);
}
	
/*
** the coefficients of Phi centered at m in 0 .. n, evaluated at t in 0 .. 1 by f
*/
function coef_Phi(nj, nf) {
  var coef = [];
  for (var i = 0; i < nf; i += 1) {
	var coef_i = [];
	for (var j = 0; j < nj; j += 1) {
	  coef_i.push(Phi_at(i/nf, j, nj));
	}
	coef.push(coef_i);
  }
  return coef;
}
