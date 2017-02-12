/*
** 2 arc minute ephemeris of sun, moon, and planets.
** Copyright (C) 1999 by Roger E Critchlow Jr,
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
** The home page for this ephemeris is
**	http://www.elf.org/ephemeris/
** a copy of the GNU GPL may be found at
**	http://www.gnu.org/copyleft/gpl.html,
** Formulae taken from
**	http://hotel04.ausys.se/pausch/comp/ppcomp.html 
** by Paul Schlyter, Stockholm, Sweden
**	pausch@saaf.se or paul.schlyter@ausys.se
**
** Dedicated to the memory of Raphael Benitez.
**
*/
function Ephemerides(y, m, D, UTC, Epoch) {
  this.y = y;
  this.m = m;
  this.D = D;
  this.UTC = UTC;
  this.Epoch = Epoch;
  with (Math) {
    // compute the date in ephemeris time
    this.d = Ephemerides.day(y, m, D, UTC);

    // compute the obliquity of the ecliptic
    this.ecl = Ephemerides.obliquity(this.d);

    // compute the ecliptic of the epoch correction
    this.lon_corr = Epoch ? Ephemerides.longitudeEcliptic(this.d, Epoch) : 0;

    // compute the mean orbital elements
    for (planet in Ephemerides.Planets) {
      this[planet] = new Object();
      if (planet != 'Pluto') {
		for (element in Ephemerides.Elements) {
		  this[planet][element] = Ephemerides[planet][element](this.d);
		  if (element == 'M' || element == 'N' || element == 'w')
			this[planet][element] = posdegrees(this[planet][element]);
		}
      }
    }

    // determine the positions of the planets
    for (planet in Ephemerides.Planets) {
      with (this[planet]) {

		// compute heliocentric ecliptic longitude and latitude, geocentric for moon
		Ephemerides[planet].position(this, planet);

		// perturbation terms in ecliptic longitude and latitude
		if (Ephemerides[planet].perturbation) Ephemerides[planet].perturbation(this);

		if (planet != 'Sun') {
		  // heliocentric cartesian ecliptic coordinates
		  this[planet].xh = r * cos(radians(lonecl)) * cos(radians(latecl));
		  this[planet].yh = r * sin(radians(lonecl)) * cos(radians(latecl));
		  this[planet].zh = r * sin(radians(latecl));
		  // geocentric cartesian ecliptic coordinates
		  // geocentric ecliptic longitude and latitude
		  if (planet == 'Moon') {
			this[planet].xg = xh;
			this[planet].yg = yh;
			this[planet].zg = zh;
			this[planet].glonecl = this[planet].lonecl;
			this[planet].glatecl = this[planet].latecl;
		  } else {
			this[planet].xg = xh + this.Sun.xs;
			this[planet].yg = yh + this.Sun.ys;
			this[planet].zg = zh;
			this[planet].glonecl = posdegrees(degrees(atan2(this[planet].yg, this[planet].xg)));
			this[planet].glatecl = degrees(atan2(this[planet].zg, Math.sqrt(this[planet].xg*this[planet].xg+this[planet].yg*this[planet].yg)));
		  }
		  // geocentric equatorial coordinates
		  this[planet].xe = xg;
		  this[planet].ye = yg * cos(radians(this.ecl)) - zg * sin(radians(this.ecl));
		  this[planet].ze = yg * sin(radians(this.ecl)) + zg * cos(radians(this.ecl));
		  this[planet].RA = posdegrees(degrees(atan2(ye, xe)));
		  this[planet].Dec = degrees(atan2(ze, sqrt(xe*xe + ye*ye)));
		  this[planet].rg = sqrt(xg*xg + yg*yg + zg*zg);

		  // Moon's topocentric coordinates
		  if (planet == 'Moon') {
		  }

		  // Apparent diameter
		  if (Ephemerides[planet].d) 
			this[planet].d = Ephemerides[planet].d(r);

		  // elongation and phase
		  if (planet != 'Moon') {
			var s = this.Sun.r;
			var R = rg;
			this[planet].elong = degrees(acos( ( s*s + R*R - r*r ) / (2*s*R) ));
			if (lonecl > this.Sun.lonecl+180 || (lonecl > this.Sun.lonecl-180 && lonecl < this.Sun.lonecl))
			  this[planet].elong *= -1;
			this[planet].FV = degrees(acos( ( r*r + R*R - s*s ) / (2*r*R) ));
			if (planet == 'Saturn') {
			  var los = lonecl;
			  var las = latecl;
			  var ir = 28.06;
			  var Nr = 169.51 + 3.82e-5 * this.d;
			  var B = asin( sin(radians(las)) * cos(radians(ir)) - cos(radians(las)) * sin(radians(ir)) * sin(radians(los-Nr)) );
			  var ring_magn = -2.6 * sin(abs(B)) + 1.2 * pow(sin(B),2) ;
			  this[planet].mag = Ephemerides[planet].mag(r, R, FV, ring_magn);
			} else if (planet != 'Pluto') {
			  this[planet].mag = Ephemerides[planet].mag(r, R, FV);
			}
		  } else {
			var mlon = lonecl;
			var mlat = latecl;
			var slon = this.Sun.lonecl;
			this[planet].elong = degrees(acos( cos(radians(slon-mlon)) * cos(radians(mlat)) ));
			if (mlon > slon+180 || (mlon > slon-180 && mlon < slon))
			  this[planet].elong *= -1;
			this[planet].FV = 180 - elong;
		  }
		  this[planet].phase = ( 1 + cos(radians(FV)) ) / 2;
		}
      }
    }
  }
  return this;
}

//
// Some extensions to Math object.
//
// compute integer division, truncating toward zero.
// reduce to a positive angle
// convert degrees into radians and vice versa
// log base 10
//
Math.div = function(a, b) { return ((a > 0) == (b > 0)) ? Math.floor(a/b) : Math.ceil(a/b) }
Math.posdegrees = function(a) { return (a < 0) ? 360 + (a % 360) : (a % 360) }
Math.radians = function(degrees) { return degrees * 0.0174532925199 }
Math.degrees = function(radians) { return radians * 57.2957795131 }
Math.log10 = function(a) { return Math.log(a)/Math.LN10 }

/*
** compute the julian date epoch 2000
*/
Ephemerides.day = function(y, m, D, UT) {
  // Day 0.0 is 2000 Jan 0 0h0 or 1999 December 31 0h00
  // y = year common era
  // m = month, january = 1
  // D = day, 1st = 1
  // UT = time UTC in hours.fraction
  // using integer division where integer constants are shown
  // return (367*y - 7 * ( y + (m+9)/12 ) / 4 + 275*m/9 + D - 730530) + UT / 24.0
  with (Math) {
    return (367*y - div(7 * ( y + div((m+9),12) ), 4) + div(275*m, 9) + D - 730530) + (UT / 24.0);
  }
}

/*
** obliquity of the ecliptic
*/
Ephemerides.obliquity = function(d) { return 23.4393 - 3.563E-7 * d }

/*
** correction to be applied to ecliptic longitude, lonecl, to obtain
** equatorial coordinates for specified epoch.
*/
Ephemerides.longitudeEcliptic = function(d, Epoch) { return 3.82394E-5 * ( 365.2422 * ( Epoch - 2000.0 ) - d ) }

/*
** iteratively refine the eccentric anomaly from a first estimate
*/
Ephemerides.eccentricAnomaly = function(M, e, E0) {
  with (Math) {
    var E1 = E0 - ( E0 - degrees(e) * sin(radians(E0)) - M) / ( 1 - e * cos(radians(E0)));
    return (abs(E1-E0) < 1e-5) ?  E1 : Ephemerides.eccentricAnomaly(M, e, E1);
  }
}

/*
** orbital elements of the planets
**
**    N = longitude of the ascending node
**    i = inclination to the ecliptic (plane of the Earth's orbit)
**    w = argument of perihelion
**    a = semi-major axis, or mean distance from Sun
**    e = eccentricity (0=circle, 0-1=ellipse, 1=parabola)
**    M = mean anomaly (0 at perihelion; increases uniformly with time)
**
** other orbital elements
**    w1 = N + w   = longitude of perihelion
**    L  = M + w1  = mean longitude
**    q  = a*(1-e) = perihelion distance
**    Q  = a*(1+e) = aphelion distance
**    P  = a ^ 1.5 = orbital period (years if a is in AU, astronomical units)
**    T  = Epoch_of_M - (M(deg)/360_deg) / P  = time of perihelion
**    v  = true anomaly (angle between position and perihelion)
**    E  = eccentric anomaly
*/
Ephemerides.Elements = new Object();
Ephemerides.Elements.N = "longitude of the ascending node";
Ephemerides.Elements.i = "inclination to the ecliptic (plane of the Earth's orbit)";
Ephemerides.Elements.w = "argument of perihelion";
Ephemerides.Elements.a = "semi-major axis, or mean distance from Sun";
Ephemerides.Elements.e = "eccentricity (0=circle, 0-1=ellipse, 1=parabola)";
Ephemerides.Elements.M = "mean anomaly (0 at perihelion; increases uniformly with time)";

Ephemerides.Planets = new Object();

Ephemerides.Planets.Sun = true;
Ephemerides.Sun = new Object();
Ephemerides.Sun.N = function(d) { return 0.0 }
Ephemerides.Sun.i = function(d) { return 0.0 }
Ephemerides.Sun.w = function(d) { return 282.9404 + 4.70935E-5 * d }
Ephemerides.Sun.a = function(d) { return 1.000000 }
Ephemerides.Sun.a.units = "AU"
Ephemerides.Sun.e = function(d) { return 0.016709 - 1.151E-9 * d }
Ephemerides.Sun.M = function(d) { return 356.0470 + 0.9856002585 * d }

Ephemerides.Planets.Moon = true;
Ephemerides.Moon = new Object();
Ephemerides.Moon.N = function(d) { return 125.1228 - 0.0529538083 * d }
Ephemerides.Moon.i = function(d) { return 5.1454 }
Ephemerides.Moon.w = function(d) { return 318.0634 + 0.1643573223 * d }
Ephemerides.Moon.a = function(d) { return 60.2666 }
Ephemerides.Moon.a.units = "Earth radii";
Ephemerides.Moon.e = function(d) { return 0.054900 }
Ephemerides.Moon.M = function(d) { return 115.3654 + 13.0649929509 * d }

Ephemerides.Planets.Mercury = true;
Ephemerides.Mercury = new Object();
Ephemerides.Mercury.N = function(d) { return 48.3313 + 3.24587E-5 * d }
Ephemerides.Mercury.i = function(d) { return 7.0047 + 5.00E-8 * d }
Ephemerides.Mercury.w = function(d) { return 29.1241 + 1.01444E-5 * d }
Ephemerides.Mercury.a = function(d) { return 0.387098 }
Ephemerides.Mercury.a.units = "AU";
Ephemerides.Mercury.e = function(d) { return 0.205635 + 5.59E-10 * d }
Ephemerides.Mercury.M = function(d) { return 168.6562 + 4.0923344368 * d }

Ephemerides.Planets.Venus = true;
Ephemerides.Venus = new Object();
Ephemerides.Venus.N = function(d) { return 76.6799 + 2.46590E-5 * d }
Ephemerides.Venus.i = function(d) { return 3.3946 + 2.75E-8 * d }
Ephemerides.Venus.w = function(d) { return 54.8910 + 1.38374E-5 * d }
Ephemerides.Venus.a = function(d) { return 0.723330 }
Ephemerides.Venus.a.units = "AU";
Ephemerides.Venus.e = function(d) { return 0.006773 - 1.302E-9 * d }
Ephemerides.Venus.M = function(d) { return 48.0052 + 1.6021302244 * d }

Ephemerides.Planets.Mars = true;
Ephemerides.Mars = new Object();
Ephemerides.Mars.N =  function(d) { return 49.5574 + 2.11081E-5 * d }
Ephemerides.Mars.i = function(d) { return 1.8497 - 1.78E-8 * d }
Ephemerides.Mars.w = function(d) { return 286.5016 + 2.92961E-5 * d }
Ephemerides.Mars.a = function(d) { return 1.523688 }
Ephemerides.Mars.a.units = "AU";
Ephemerides.Mars.e = function(d) { return 0.093405 + 2.516E-9 * d }
Ephemerides.Mars.M =  function(d) { return 18.6021 + 0.5240207766 * d }

Ephemerides.Planets.Jupiter = true;
Ephemerides.Jupiter = new Object();
Ephemerides.Jupiter.N = function(d) { return 100.4542 + 2.76854E-5 * d }
Ephemerides.Jupiter.i = function(d) { return 1.3030 - 1.557E-7 * d }
Ephemerides.Jupiter.w = function(d) { return 273.8777 + 1.64505E-5 * d }
Ephemerides.Jupiter.a = function(d) { return 5.20256 }
Ephemerides.Jupiter.a.units = "AU";
Ephemerides.Jupiter.e = function(d) { return 0.048498 + 4.469E-9 * d }
Ephemerides.Jupiter.M = function(d) { return 19.8950 + 0.0830853001 * d }

Ephemerides.Planets.Saturn = true;
Ephemerides.Saturn = new Object();
Ephemerides.Saturn.N = function(d) { return 113.6634 + 2.38980E-5 * d }
Ephemerides.Saturn.i = function(d) { return 2.4886 - 1.081E-7 * d }
Ephemerides.Saturn.w = function(d) { return 339.3939 + 2.97661E-5 * d }
Ephemerides.Saturn.a = function(d) { return 9.55475 }
Ephemerides.Saturn.a.units = "AU";
Ephemerides.Saturn.e = function(d) { return 0.055546 - 9.499E-9 * d }
Ephemerides.Saturn.M = function(d) { return 316.9670 + 0.0334442282 * d }

Ephemerides.Planets.Uranus = true;
Ephemerides.Uranus = new Object();
Ephemerides.Uranus.N = function(d) { return  74.0005 + 1.3978E-5 * d }
Ephemerides.Uranus.i = function(d) { return 0.7733 + 1.9E-8 * d }
Ephemerides.Uranus.w = function(d) { return  96.6612 + 3.0565E-5 * d }
Ephemerides.Uranus.a = function(d) { return 19.18171 - 1.55E-8 * d }
Ephemerides.Uranus.a.units = "AU";
Ephemerides.Uranus.e = function(d) { return 0.047318 + 7.45E-9 * d }
Ephemerides.Uranus.M = function(d) { return 142.5905 + 0.011725806 * d }

Ephemerides.Planets.Neptune = true;
Ephemerides.Neptune = new Object();
Ephemerides.Neptune.N = function(d) { return 131.7806 + 3.0173E-5 * d }
Ephemerides.Neptune.i = function(d) { return 1.7700 - 2.55E-7 * d }
Ephemerides.Neptune.w = function(d) { return 272.8461 - 6.027E-6 * d }
Ephemerides.Neptune.a = function(d) { return 30.05826 + 3.313E-8 * d }
Ephemerides.Neptune.a.units = "AU";
Ephemerides.Neptune.e = function(d) { return 0.008606 + 2.15E-9 * d }
Ephemerides.Neptune.M = function(d) { return 260.2471 + 0.005995147 * d }

Ephemerides.Planets.Pluto = true;
Ephemerides.Pluto = new Object();

//
// Computation of ecliptic longitude and latitude.
// One for the sun, one for pluto, one for everyone else.
//
Ephemerides.Sun.position = function(eph, planet) {
  // determine the position of the sun
  // these are largely simplifications of the general case
  // knowing that the sun defines the plane of the ecliptic
  // hence many terms are zero by definition.
  // also knowing that we will need some of the sun's data
  // to compute geocentric coordinates for other bodies, we
  // name some things differently
  with (Math) {
    with (eph.Sun) {
      eph.Sun.E = Ephemerides.eccentricAnomaly(M, e, M + degrees(e) * sin(radians(M)) * (1.0 + e * cos(radians(M))));
      eph.Sun.xv = cos(radians(E)) - e;
      eph.Sun.yv = sqrt(1 - e*e) * sin(radians(E));
      eph.Sun.v = degrees(atan2(yv, xv));
      eph.Sun.r = sqrt(xv*xv + yv*yv);
      eph.Sun.lonecl = posdegrees(v + w + eph.lon_corr);
      eph.Sun.latecl = 0;	// by definition
      eph.Sun.xs = r * cos(radians(lonecl));
      eph.Sun.ys = r * sin(radians(lonecl));
      eph.Sun.xe = xs;
      eph.Sun.ye = ys * cos(radians(eph.ecl));
      eph.Sun.ze = ys * sin(radians(eph.ecl));
      eph.Sun.RA = posdegrees(degrees(atan2(ye, xe)));
      eph.Sun.Dec = degrees(atan2(ze, sqrt(xe*xe + ye*ye)));
      eph.Sun.d = Ephemerides.Sun.d(r);
    }
  }
}
Ephemerides.Moon.position = function(eph, planet) {
  // determine unperturbed position of the planet
  // this function serves for the moon and all the planets
  // other than Pluto
  with (Math) {
    with (eph[planet]) {
      eph[planet].E = Ephemerides.eccentricAnomaly(M, e, M + degrees(e) * sin(radians(M)) * (1.0 + e * cos(radians(M))));
      eph[planet].xv = a * ( cos(radians(E)) - e );
      eph[planet].yv = a * ( sqrt(1 - e*e) * sin(radians(E)));
      eph[planet].v = degrees(atan2(yv, xv));
      eph[planet].r = sqrt(xv*xv + yv*yv);
      eph[planet].xh = r * ( cos(radians(N)) * cos(radians(v+w)) - sin(radians(N)) * sin(radians(v+w)) * cos(radians(i)) );
      eph[planet].yh = r * ( sin(radians(N)) * cos(radians(v+w)) + cos(radians(N)) * sin(radians(v+w)) * cos(radians(i)) );
      eph[planet].zh = r * ( sin(radians(v+w)) * sin(radians(i)) );
      eph[planet].lonecl = posdegrees(degrees(atan2(yh, xh)) + eph.lon_corr);
      eph[planet].latecl = degrees(atan2(zh, sqrt(xh*xh + yh*yh)));
    }
  }
}
Ephemerides.Mercury.position = Ephemerides.Moon.position;
Ephemerides.Venus.position = Ephemerides.Moon.position;
Ephemerides.Mars.position = Ephemerides.Moon.position;
Ephemerides.Jupiter.position = Ephemerides.Moon.position;
Ephemerides.Saturn.position = Ephemerides.Moon.position;
Ephemerides.Uranus.position = Ephemerides.Moon.position;
Ephemerides.Neptune.position = Ephemerides.Moon.position;
Ephemerides.Pluto.position = function(eph, planet) {
  // determine pluto's position
  // this is a formula by curve fit to observed positions
  with (Math) {
    with (eph.Pluto) {
      eph.Pluto.S =  50.03  +  0.033459652 * eph.d;
      eph.Pluto.P = 238.95  +  0.003968789 * eph.d;
      eph.Pluto.lonecl = posdegrees(238.9508  +  0.00400703 * eph.d
			  - 19.799 * sin(radians(P))     + 19.848 * cos(radians(P))
			  + 0.897 * sin(radians(2*P))    - 4.956 * cos(radians(2*P))
			  + 0.610 * sin(radians(3*P))    + 1.211 * cos(radians(3*P))
			  - 0.341 * sin(radians(4*P))    - 0.190 * cos(radians(4*P))
			  + 0.128 * sin(radians(5*P))    - 0.034 * cos(radians(5*P))
			  - 0.038 * sin(radians(6*P))    + 0.031 * cos(radians(6*P))
			  + 0.020 * sin(radians(S-P))    - 0.010 * cos(radians(S-P))
			  + eph.lon_corr);
      eph.Pluto.latecl = ( -3.9082
			   - 5.453 * sin(radians(P))     - 14.975 * cos(radians(P))
			   + 3.527 * sin(radians(2*P))    + 1.673 * cos(radians(2*P))
			   - 1.051 * sin(radians(3*P))    + 0.328 * cos(radians(3*P))
			   + 0.179 * sin(radians(4*P))    - 0.292 * cos(radians(4*P))
			   + 0.019 * sin(radians(5*P))    + 0.100 * cos(radians(5*P))
			   - 0.031 * sin(radians(6*P))    - 0.026 * cos(radians(6*P))
			   + 0.011 * cos(radians(S-P))
			   );
      eph.Pluto.r     =  ( 40.72
			   + 6.68 * sin(radians(P))       + 6.90 * cos(radians(P))
			   - 1.18 * sin(radians(2*P))     - 0.03 * cos(radians(2*P))
			   + 0.15 * sin(radians(3*P))     - 0.14 * cos(radians(3*P))
			   );
    }
  }
}

//
// Perturbation terms in ecliptic longitude and latitude
// for moon, jupiter, saturn, and uranus
//
Ephemerides.Moon.perturbation = function(eph, planet) {
  var Ms = eph.Sun.M;			// Mean Anomaly of the Sun and the Moon
  var Mm = eph.Moon.M;
  var Nm = eph.Moon.N;			// Longitude of the Moon's node
  var ws = eph.Sun.w;			// Argument of perihelion for the Sun and the Moon
  var wm = eph.Moon.w;
  var Ls = Ms + ws;			// Mean Longitude of the Sun  (Ns=0)
  var Lm = Mm + wm + Nm;		// Mean longitude of the Moon
  var D = Lm - Ls;			// Mean elongation of the Moon
  var F = Lm - Nm;			// Argument of latitude for the Moon
  with (Math) {
      eph.Moon.lonecl += (0
			  -1.274 * sin(radians(Mm - 2*D))
			  +0.658 * sin(radians(2*D))
			  -0.186 * sin(radians(Ms))
			  -0.059 * sin(radians(2*Mm - 2*D))
			  -0.057 * sin(radians(Mm - 2*D + Ms))
			  +0.053 * sin(radians(Mm + 2*D))
			  +0.046 * sin(radians(2*D - Ms))
			  +0.041 * sin(radians(Mm - Ms))
			  -0.035 * sin(radians(D))
			  -0.031 * sin(radians(Mm + Ms))
			  -0.015 * sin(radians(2*F - 2*D))
			  +0.011 * sin(radians(Mm - 4*D))
			  );
      eph.Moon.latecl += (0
			  -0.173 * sin(radians(F - 2*D))
			  -0.055 * sin(radians(Mm - F - 2*D))
			  -0.046 * sin(radians(Mm + F - 2*D))
			  +0.033 * sin(radians(F + 2*D))
			  +0.017 * sin(radians(2*Mm + F))
			  );
      eph.Moon.r += (0
		     -0.58 * cos(radians(Mm - 2*D))
		     -0.46 * cos(radians(2*D))
		     );
  }
}
Ephemerides.Jupiter.perturbation = function(eph, planet) {
  var Mj = eph.Jupiter.M;			// Mean anomaly of Jupiter
  var Ms = eph.Saturn.M;			// Mean anomaly of Saturn
  with (Math) {
      eph.Jupiter.lonecl += (0
			     -0.332 * sin(radians(2*Mj - 5*Ms - 67.6))
			     -0.056 * sin(radians(2*Mj - 2*Ms + 21))
			     +0.042 * sin(radians(3*Mj - 5*Ms + 21))
			     -0.036 * sin(radians(Mj - 2*Ms))
			     +0.022 * cos(radians(Mj - Ms))
			     +0.023 * sin(radians(2*Mj - 3*Ms + 52))
			     -0.016 * sin(radians(Mj - 5*Ms - 69))
			     );
  }
}
Ephemerides.Saturn.perturbation = function(eph, planet) {
  var Mj = eph.Jupiter.M;		// Mean anomaly of Jupiter
  var Ms = eph.Saturn.M;		// Mean anomaly of Saturn
  with (Math) {
      eph.Saturn.lonecl += (0
			    +0.812 * sin(radians(2*Mj - 5*Ms - 67.6))
			    -0.229 * cos(radians(2*Mj - 4*Ms - 2))
			    +0.119 * sin(radians(Mj - 2*Ms - 3))
			    +0.046 * sin(radians(2*Mj - 6*Ms - 69))
			    +0.014 * sin(radians(Mj - 3*Ms + 32))
			    );
      eph.Saturn.latecl += (0
			    -0.020 * cos(radians(2*Mj - 4*Ms - 2))
			    +0.018 * sin(radians(2*Mj - 6*Ms - 49))
			    );
  }
}
Ephemerides.Uranus.perturbation = function(eph, planet) {
  var Mj = eph.Jupiter.M;		// Mean anomaly of Jupiter
  var Ms = eph.Saturn.M;		// Mean anomaly of Saturn
  var Mu = eph.Uranus.M;		// Mean anomaly of Uranus
  with (Math) {
      eph.Uranus.lonecl += (0
			    +0.040 * sin(radians(Ms - 2*Mu + 6))
			    +0.035 * sin(radians(Ms - 3*Mu + 33))
			    -0.015 * sin(radians(Mj - Mu + 20))
			    );
  }
}

//
// Apparent diameter
//
Ephemerides.Sun.d = function(r) { return 1919.26/r }
Ephemerides.Moon.d = function(r) { return 1873.7 * 60 / r }
Ephemerides.Mercury.d = function(r) { return 6.74 / r }
Ephemerides.Venus.d = function(r) { return 16.92 / r }
Ephemerides.Mars.d = function(r) { return 9.36 / r } /*  polar 9.28 */
Ephemerides.Jupiter.d =function(r) { return 196.94 / r } /* polar 185.08 - xephem has 196.74 for equatorial diameter */
Ephemerides.Saturn.d =function(r) { return 165.6 / r } /* polar 150.8 */
Ephemerides.Uranus.d =function(r) { return 65.8 / r } /* polar 62 */
Ephemerides.Neptune.d =function(r) { return 62.2 / r } /* polar 60.9 */
Ephemerides.Pluto.d =function(r) { return 8.2 / r }

//
// Visual magnitude
//
Ephemerides.Mercury.mag = function(r, R, FV) { with (Math) return -0.36 + 5*log10(r*R) + 0.027 * FV + 2.2E-13 * pow(FV,6); }
Ephemerides.Venus.mag = function(r, R, FV) { with (Math) return -4.34 + 5*log10(r*R) + 0.013 * FV + 4.2E-7  * pow(FV,3) }
Ephemerides.Mars.mag = function(r, R, FV) { with (Math) return -1.51 + 5*log10(r*R) + 0.016 * FV }
Ephemerides.Jupiter.mag = function(r, R, FV) { with (Math) return -9.25 + 5*log10(r*R) + 0.014 * FV }
Ephemerides.Saturn.mag = function(r, R, FV, ring_magn) { with (Math) return -9.0  + 5*log10(r*R) + 0.044 * FV + ring_magn }
Ephemerides.Uranus.mag = function(r, R, FV) { with (Math) return -7.15 + 5*log10(r*R) + 0.001 * FV }
Ephemerides.Neptune.mag = function(r, R, FV) { with (Math) return -6.90 + 5*log10(r*R) + 0.001 * FV }
