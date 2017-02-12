#########################################################################
##
## palette.tcl a palette generator
##
## original author: Eric Grosse
## derivative tcl hacker: Roger Critchlow
##
## Copyright 1995,1998 by Roger E. Critchlow Jr., Santa Fe, New Mexico
## All rights reserved, fair use permitted, caveat emptor.
## rec@elf.org
##
##
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
proc ::palette::rgb2hsv {red green blue} {
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

namespace eval ::palette {
    #
    # The procedure below converts an HSV value to RGB.  It takes hue, saturation,
    # and value components (floating-point, 0-1.0) as arguments, and returns a
    # list containing RGB components (float, 0-1.0) as result.  The code
    # here is a copy of the code on page 616 of "Fundamentals of Interactive
    # Computer Graphics" by Foley and Van Dam.
    #
    proc hsv2rgb {hue sat value} {
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
    variable huettab {
	0.0000 0.0062 0.0130 0.0202 0.0280 0.0365 0.0457 0.0559 0.0671 0.0796
	0.0936 0.1095 0.1275 0.1482 0.1806 0.2113 0.2393 0.2652 0.2892 0.3119
	0.3333 0.3556 0.3815 0.4129 0.4526 0.5060 0.5296 0.5501 0.5679 0.5834
	0.5970 0.6088 0.6191 0.6281 0.6361 0.6430 0.6490 0.6544 0.6590 0.6631
	0.6667 0.6713 0.6763 0.6815 0.6873 0.6937 0.7009 0.7092 0.7190 0.7308
	0.7452 0.7631 0.7856 0.8142 0.8621 0.9029 0.9344 0.9580 0.9755 0.9889
	1.0000
    };

    proc rainbow {h s v} {
	variable huettab
	set h [expr 1-$h];
	set h [expr 60 * fmod($h/1.5, 1.0)];
	set i [expr int(floor($h))];
	set h [expr [lindex $huettab $i] + ([lindex $huettab [expr $i+1]] - [lindex $huettab $i]) * ($h - $i)];
	return [palette::hsv2rgb $h $s $v];
    }

    #
    # terrain - maps hue variations into typical
    # map terrain colors.  No saturation or value
    # sensitivity.
    #
    proc terrain {hue sat val} {
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
    proc iron {hue sat val} {
	return [list [expr 3*($hue+.03)] [expr 3*($hue-.333333)] [expr 3*($hue-.666667)]];
    }

    #
    # astro - maps hue into slightly blued gray scale
    #
    proc astro {hue sat val} {
	return [list $hue $hue [expr ($hue+.2)/1.2]];
    }

    #
    # gray - maps hue into gray scale
    #
    proc gray {hue sat val} {
	return [list $hue $hue $hue];
    }
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
    if {[llength [namespace eval ::palette "info proc $map"]] == 0} {
	error "I don't know how to make a palette of type: $map";
    }
    for {set sat $dsat} {$sat <= 1.0} {set sat [expr $sat+$dsat]} {
	for {set hue $dhue} {$hue <= 1.0} {set hue [expr $hue+$dhue]} {
	    set color "\#";
	    foreach gun [palette::$map $hue $sat 1] {
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
