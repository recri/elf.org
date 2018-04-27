########################################################################
#
# pencil - a screensaver animation that simply moves a line, polygon,
# or spline around on the screen.
#
########################################################################
proc pencil {} {
    global pencil embed_args;
    ##
    ## set default parameters
    ##

    set pencil(width) 200
    set pencil(height) 200
    set pencil(pause) 50;		# milliseconds pause between iterations
    set pencil(keep) 20;		# number of iterations to keep on screen
    set pencil(points) 5;		# number of points to iterate
    set pencil(connect) 1;		# whether the points should be connected
    set pencil(closed) 1;		# whether the points should be a closed loop
    set pencil(smooth) 1;		# whether the points should be smoothed
    set pencil(background) black;	# background color of canvas
    set pencil(palette) {palette iron 1 32};		# foreground color of images
    set pencil(control) 0;		# control panel
    set pencil(maxdx) 5;		# maximum x velocity
    set pencil(maxdy) 5;		# maximum y velocity

    ##
    ## calibrate timer
    ##
    set c1 [clock clicks]
    after 100
    set c2 [clock clicks]
    set pencil(millisec/click) [expr 100.0/($c2-$c1)]

    ##
    ## fetch embedded parameter specifications
    ##
    array set pencil [array get embed_args];

    ##
    ## seed the random number generate
    ##
    if {[info exists pencil(srandom)]} {
	srandom $pencil(srandom);
    } else {
	srandom [clock seconds];
    }

    ##
    ## compute additional parameters if not specified
    ##
    # parameters for each point
    for {set i 0} {$i < $pencil(points)} {incr i} {
	# initial x and y coordinate of point $i
	if { ! [info exists pencil(x$i)]} {
	    set pencil(x$i) [expr [random]%$pencil(width)];
	}
	if { ! [info exists pencil(y$i)]} {
	    set pencil(y$i) [expr [random]%$pencil(height)];
	}
	# x and y velocities of point $i
	if { ! [info exists pencil(dx$i)]} {
	    set pencil(dx$i) [expr ([random]%$pencil(maxdx))+1];
	}
	if { ! [info exists pencil(dy$i)]} {
	    set pencil(dy$i) [expr ([random]%$pencil(maxdy))+1];
	}
	# lower bound of x and y coordinates of point $i
	if { ! [info exists pencil(lx$i)]} {
	    set pencil(lx$i) 0;
	}
	if { ! [info exists pencil(ly$i)]} {
	    set pencil(ly$i) 0;
	}
	# upper bound of x and y coordinates of point $i
	if { ! [info exists pencil(ux$i)]} {
	    set pencil(ux$i) $pencil(width);
	}
	if { ! [info exists pencil(uy$i)]} {
	    set pencil(uy$i) $pencil(height);
	}
    }
    # possibly compute a palette
    if { ! [catch $pencil(palette) temporary]} {
	set pencil(palette) $temporary;
    }
    set pencil(n-palette) [llength $pencil(palette)];
    # build the canvas
    pack [canvas .c -background $pencil(background) -height $pencil(height) -width $pencil(width)] -fill both -expand true
    # start the iteration
    set pencil(nth) 0;
    pencil_update;
}

#
# update the cth coordinate of the ith point 
#
proc pencil_update_ci {c i} {
    global pencil;
    # integrate velocity
    set pencil($c$i) [expr $pencil($c$i) + $pencil(d$c$i)];
    # apply boundary conditions to position and velocity
    if {$pencil($c$i) < $pencil(l$c$i)} {
	set pencil($c$i) [expr $pencil(l$c$i) - $pencil($c$i)];
	set pencil(d$c$i) [expr -$pencil(d$c$i)];
    } elseif {$pencil($c$i) > $pencil(u$c$i)} {
	set pencil($c$i) [expr $pencil(u$c$i) - ($pencil($c$i) - $pencil(u$c$i))];
	set pencil(d$c$i) [expr -$pencil(d$c$i)];
    }
}

#
# pick the color for this round
#
proc pencil_update_palette {} {
    global pencil;
    if {($pencil(nth) / $pencil(n-palette)) & 1} {
	return [lindex $pencil(palette) [expr $pencil(n-palette)-1-$pencil(nth)%$pencil(n-palette)]];
    } else {
	return [lindex $pencil(palette) [expr $pencil(nth)%$pencil(n-palette)]];
    }
}

#
#
#
proc pencil_timeout {who} {
    global pencil
    set pencil(clicks) [clock clicks]
    after idle pencil_timein $who
}

proc pencil_timein {who} {
    global pencil
    set pause [expr int($pencil(pause)-(([clock clicks]-$pencil(clicks))*$pencil(millisec/click)))]
    if {$pause <= 1} {
	set pause $pencil(pause);
    }
    after $pause $who
}

#
#
#
proc pencil_update {} {
    global pencil;
    set color [pencil_update_palette];
    incr pencil(nth);
    if {$pencil(connect) && $pencil(points) > 1} {
	set coords {}
	for {set i 0} {$i < $pencil(points)} {incr i} {
	    foreach c {x y} {
		append coords " $pencil($c$i)";
		pencil_update_ci $c $i;
	    }
	}
	if {$pencil(points) > 2} {
	    if {$pencil(closed)} {
		eval .c create polygon $coords -smooth $pencil(smooth) -fill {{}}\
		    -outline $color\
		    -tags L$pencil(nth);
	    } else {
		eval .c create line $coords -smooth $pencil(smooth) -fill {{}}\
		    -fill $color\
		    -tags L$pencil(nth);
	    }
	} else {
	    eval .c create line $coords -smooth $pencil(smooth) -fill {{}}\
		-fill $color\
		-tags L$pencil(nth);
	}
    } else {
	for {set i 0} {$i < $pencil(points)} {incr i} {
	    foreach c {x y} {
		set $c $pencil($c$i);
		pencil_update_ci $c $i;
	    }
	    .c create oval [expr $x-5] [expr $y-5] [expr $x+5] [expr $y+5] \
		-fill $color \
		-tags L$pencil(nth);
	}
    }
    .c delete withtag L[expr $pencil(nth)-$pencil(keep)];
    pencil_timeout pencil_update
}

########################################################################
#
# random.tcl - very random number generator in tcl.
#
# Copyright 1995 by Roger E. Critchlow Jr., San Francisco, California.
# All rights reserved.  Fair use permitted.  Caveat emptor.
#
########################################################################
#
# This code implements a very long period random number
# generator.  The following symbols are "exported" from
# this module:
#
#	[random] returns 31 bits of random integer.
#	[srandom <integer!=0>] reseeds the generator.
#	$RAND_MAX yields the maximum number in the
#	  range of [random] or maybe one greater.
#
# The generator is one George Marsaglia, geo@stat.fsu.edu,
# calls the Mother of All Random Number Generators.
#
# The coefficients in a2 and a3 are corrections to the original
# posting.  These values keep the linear combination within the
# 31 bit summation limit.
#
# And we are truncating a 32 bit generator to 31 bits on
# output.  This generator could produce the uniform distribution
# on [INT_MIN .. -1] [1 .. INT_MAX]
#
set random..a1 { 1941 1860 1812 1776 1492 1215 1066 12013 };
set random..a2 { 1111 2222 3333 4444 5555 6666 7777   827 };
set random..a3 { 1111 2222 3333 4444 5555 6666 7777   251 };
set random..m1 { 30903 4817 23871 16840 7656 24290 24514 15657 19102 };
set random..m2 { 30903 4817 23871 16840 7656 24290 24514 15657 19102 };

proc random..srand16 {seed args} {
    set n1 [expr $seed & 0xFFFF];
    set n2 [expr $seed & 0x7FFFFFFF];
    set n2 [expr 30903 * $n1 + ($n2 >> 16)];
    set n1 [expr $n2 & 0xFFFF];
    set m  [expr $n1 & 0x7FFF];
    foreach i {1 2 3 4 5 6 7 8} {
	set n2 [expr 30903 * $n1 + ($n2 >> 16)];
	set n1 [expr $n2 & 0xFFFF];
	lappend m $n1;
    }
    return $m;
}

proc random..rand16 {a m} {
    set n [expr \
	       [lindex $m 0] + \
	       [lindex $a 0] * [lindex $m 1] + \
	       [lindex $a 1] * [lindex $m 2] + \
	       [lindex $a 2] * [lindex $m 3] + \
	       [lindex $a 3] * [lindex $m 4] + \
	       [lindex $a 4] * [lindex $m 5] + \
	       [lindex $a 5] * [lindex $m 6] + \
	       [lindex $a 6] * [lindex $m 7] + \
	       [lindex $a 7] * [lindex $m 8]];

    return [concat [expr $n >> 16] [expr $n & 0xFFFF] [lrange $m 1 7]];
}

#
# Externals
# 
set RANDOM_MAX 0x7FFFFFFF;

proc randomstate {} {
    global random..m1 random..m2;
    return [list [set random..m1] [set random..m2]];
}

proc setrandomstate {state} {
    global random..m1 random..m2;
    set random..m1 [lindex $state 0];
    set random..m2 [lindex $state 1];
}

proc srandom {seed} {
    global random..m1 random..m2;
    set random..m1 [random..srand16 $seed];
    set random..m2 [random..srand16 $seed];
    return {};
}

proc random {} {
    global random..m1 random..m2 random..a1 random..a2;
    set random..m1 [random..rand16 [set random..a1] [set random..m1]];
    set random..m2 [random..rand16 [set random..a2] [set random..m2]];
    return [expr (([lindex [set random..m1] 1] << 16) + [lindex [set random..m2] 1]) & 0x7FFFFFFF];
}

########################################################################
#
# palette.tcl a palette generator
#
# original author: Eric Grosse
# derivative tcl hacker: Roger Critchlow
#
########################################################################
#
# This routine computes colors suitable for use in color level plots.
# Typically s=v=1 and h varies from 0 (red) to 1 (blue) in
# equally spaced steps.  (h=.5 gives green; 1<h<1.5 gives magenta.)
# To convert for frame buffer, use   R = floor(255.999*pow(*r,1/gamma))  etc.
# To get tables calibrated for other devices or to report complaints,
# contact ehg@research.att.com.
#
# The author of this software is Eric Grosse.  Copyright (c) 1986,1991 by AT&T.
# Permission to use, copy, modify, and distribute this software for any
# purpose without fee is hereby granted, provided that this entire notice
# is included in all copies of any software which is or includes a copy
# or modification of this software and in all copies of the supporting
# documentation for such software.
# THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTY.  IN PARTICULAR, NEITHER THE AUTHORS NOR AT&T MAKE ANY
# REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY
# OF THIS SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
#
# The authors of this software are Eric Grosse and W. M. Coughran, Jr.
# Copyright (c) 1991 by AT&T.
# Permission to use, copy, modify, and distribute this software for any
# purpose without fee is hereby granted, provided that this entire notice
# is included in all copies of any software which is or includes a copy
# or modification of this software and in all copies of the supporting
# documentation for such software.
# THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTY.  IN PARTICULAR, NEITHER THE AUTHORS NOR AT&T MAKE ANY
# REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY
# OF THIS SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
#
# We thank Cleve Moler for describing the "hot iron" scale to us.
#

#
# The procedure below converts an RGB value to HSV.  It takes red, green,
# and blue components (0-1.0) as arguments, and returns a list containing
# HSV components (floating-point, 0-1.0) as result.  The code here is a copy
# of the code on page 615 of "Fundamentals of Interactive Computer Graphics"
# by Foley and Van Dam.
#
proc rgb2hsv {red green blue} {
    if {$red > $green} {
	set max $red
	set min $green
    } else {
	set max $green
	set min $red
    }
    if {$blue > $max} {
	set max $blue
    } else {
	if {$blue < $min} {
	    set min $blue
	}
    }
    set range [expr $max-$min]
    if {$max == 0} {
	set sat 0
    } else {
	set sat [expr {$range/$max}]
    }
    if {$sat == 0} {
	set hue 0
    } else {
	set rc [expr {($max - $red)/$range}]
	set gc [expr {($max - $green)/$range}]
	set bc [expr {($max - $blue)/$range}]
	if {$red == $max} {
	    set hue [expr {.166667*($bc - $gc)}]
	} else {
	    if {$green == $max} {
		set hue [expr {.166667*(2 + $rc - $bc)}]
	    } else {
		set hue [expr {.166667*(4 + $gc - $rc)}]
	    }
	}
    }
    return [list $hue $sat $max]
}

#
# The procedure below converts an HSV value to RGB.  It takes hue, saturation,
# and value components (floating-point, 0-1.0) as arguments, and returns a
# list containing RGB components (float, 0-1.0) as result.  The code
# here is a copy of the code on page 616 of "Fundamentals of Interactive
# Computer Graphics" by Foley and Van Dam.
#
proc palette..hsv2rgb {hue sat value} {
    set v $value;
    if {$sat == 0} {
	return "$v $v $v"
    } else {
	set hue [expr $hue*6.0]
	if {$hue >= 6.0} {
	    set hue 0.0
	}
	scan $hue. %d i
	set f [expr $hue-$i]
	set p [expr $value*(1 - $sat)]
	set q [expr $value*(1 - ($sat*$f))]
	set t [expr $value*(1 - ($sat*(1 - $f)))]
	switch -exact $i {
	    0 {return "$v $t $p"}
	    1 {return "$q $v $p"}
	    2 {return "$p $v $t"}
	    3 {return "$p $q $v"}
	    4 {return "$t $p $v"}
	    5 {return "$v $p $q"}
	    default {
		error "i value $i is out of range"
	    }
	}
    }
}

#
# rainbow - maps hue variations into the colors of the rainbow
# as h varies from 0 to 1.
#
set palette..huettab {
    0.0000 0.0062 0.0130 0.0202 0.0280 0.0365 0.0457 0.0559 0.0671 0.0796
    0.0936 0.1095 0.1275 0.1482 0.1806 0.2113 0.2393 0.2652 0.2892 0.3119
    0.3333 0.3556 0.3815 0.4129 0.4526 0.5060 0.5296 0.5501 0.5679 0.5834
    0.5970 0.6088 0.6191 0.6281 0.6361 0.6430 0.6490 0.6544 0.6590 0.6631
    0.6667 0.6713 0.6763 0.6815 0.6873 0.6937 0.7009 0.7092 0.7190 0.7308
    0.7452 0.7631 0.7856 0.8142 0.8621 0.9029 0.9344 0.9580 0.9755 0.9889
    1.0000
};

proc palette..rainbow {h s v} {
    upvar \#0 palette..huettab huettab;
    set h [expr 1-$h];
    set h [expr 60 * fmod($h/1.5, 1.0)];
    set i [expr int(floor($h))];
    set h [expr [lindex $huettab $i] + ([lindex $huettab [expr $i+1]] - [lindex $huettab $i]) * ($h - $i)];
    return [palette..hsv2rgb $h $s $v];
}

#
# terrain - maps hue variations into typical
# map terrain colors.  No saturation or value
# sensitivity.
#
proc palette..terrain {hue sat val} {
    set hue [expr $hue * 3];
    if {$hue < .25} {
	return [list 0 0 [expr 0.25+2*$hue]];
    } elseif {$hue < 2} {
	return [list 0 [expr 0.25+(2-$hue)] 0];
    } elseif {$hue < 2.7} {
	return [list .75 .15 .0];
    } else {
	return [list .9 .9 .9];
    }
}

#
# iron - maps hue into the colors of iron as it is heated
#
proc palette..iron {hue sat val} {
    return [list [expr 3*($hue+.03)] [expr 3*($hue-.333333)] [expr 3*($hue-.666667)]];
}

#
# astro - maps hue into slightly blued gray scale
#
proc palette..astro {hue sat val} {
    return [list $hue $hue [expr ($hue+.2)/1.2]];
}

#
# gray - maps hue into gray scale
#
proc palette..gray {hue sat val} {
    return [list $hue $hue $hue];
}

#
#  Creates texture array with saturation levels in the y (t) direction
#  and hue and lightness changes in x (s) direction.
#  Flattens it into a single list.
#
proc palette {map nsaturations ncolors {gamma 1}} {
    set array {};
    set dsat [expr 1.0/$nsaturations];
    set dhue [expr 1.0/$ncolors];
    if {"[info proc palette..$map]" == {}} {
	error "I don't know how to make a palette of type: $map";
    }
    for {set sat $dsat} {$sat <= 1.0} {set sat [expr $sat+$dsat]} {
	for {set hue $dhue} {$hue <= 1.0} {set hue [expr $hue+$dhue]} {
	    set color "\#";
	    foreach gun [palette..$map $hue $sat 1] {
		if {$gun > 1} {
		    set gun 1;
		} elseif {$gun < 0} {
		    set gun 0;
		}
		if {$gun != 0} {
		    set gun [expr pow($gun, 1.0/$gamma)];
		}
		append color [format %04x [expr int($gun*65535.9999)]];
	    }
	    lappend texture $color;
	}
    }
    return $texture;
}

#
# Interpolate between two colors, return a color
# ramp from rgb1 (expressed as three floats, 0-1) to
# rgb2 including both colors.
#
proc interpalette {rgb1 rgb2 steps} {
    set hsv1 [eval rgb2hsv $rgb1];
    set hsv2 [eval rgb2hsv $rgb2];
}

##
## start
##
pencil
