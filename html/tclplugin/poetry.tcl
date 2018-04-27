#
# magnetic poetry
#
proc poetry {} {
    global embed_args;
    global poetry;

    # initialize parameters
    array set poetry {
	width 500
	height 400
	background grey
	rectangle white
	foreground black
	words {mary had a little lamb little lamb little lamb
	    mary had a little lamb whose fleece was white as snow
	    it followed her to school one day school one day school one day
	    it followed her to school one day which was against the rules}
    }

    # fetch embed tag parameters
    array set poetry [array get embed_args];

    # initialize canvas
    pack [canvas .c -width $poetry(width) -height $poetry(height) -bg $poetry(background)]
    
    # remove any punctuation from the words
    regsub -all {[?!,.;:`'"]} $poetry(words) {} poetry(words)
    regsub -all -- {--} $poetry(words) {} poetry(words)

    # initialize words
    foreach word $poetry(words) {
	set x 0;
	set y 0;
	foreach i {1 2 3 4 5} {
	    set x [expr $x + ([random]%$poetry(width))/5.0]
	    set y [expr $y + ([random]%$poetry(height))/5.0]
	}
	set w [.c create text $x $y -text $word -tags word]
	set r [eval .c create rectangle [expand-bbox [.c bbox $w] -4 -2 2 2] -fill $poetry(rectangle) -tags rect];
	.c addtag w$w withtag $w
	.c addtag w$w withtag $r
	.c raise $w
    }

    .c bind word <ButtonPress-1> {select %x %y}
    .c bind rect <ButtonPress-1> {select %x %y}
    bind .c <B1-Motion> {move %x %y}
    bind .c <ButtonRelease-1> {unselect %x %y}
}

proc expand-bbox {bbox w n e s} {
    foreach x $bbox dx [list $w $n $e $s] {
	lappend expand [expr $x+$dx];
    }
    return $expand;
}

proc select {x y} {
    global poetry;
    set poetry(x) $x;
    set poetry(y) $y;
    set poetry(w) [lindex [.c gettags [.c find withtag current]] 1];
    .c raise $poetry(w)
}
proc move {x y} {
    global poetry;
    if {[info exists poetry(w)]} {
	.c move $poetry(w) [expr $x-$poetry(x)] [expr $y-$poetry(y)]
	set poetry(x) $x;
	set poetry(y) $y;
    }
}
proc unselect {x y} {
    global poetry;
    catch {unset poetry(x) poetry(y) poetry(w)}
}

########################################################################
#
# random.tcl - very random number generator in tcl.
#
# Copyright 1995 by Roger E. Critchlow Jr., San Francisco, California.
# All rights reserved.  Fair use permitted.  Caveat emptor.
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

proc random..srand16 {seed} {
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

proc srandom {seed} {
    global random..m1 random..m2;
    set random..m1 [random..srand16 $seed];
    set random..m2 [random..srand16 [expr 4321+$seed]];
    return {};
}

proc random {} {
    global random..m1 random..m2 random..a1 random..a2;
    set random..m1 [random..rand16 [set random..a1] [set random..m1]];
    set random..m2 [random..rand16 [set random..a2] [set random..m2]];
    return [expr (([lindex [set random..m1] 1] << 16) + [lindex [set random..m2] 1]) & 0x7FFFFFFF];
}
########################################################################
# end of random number generator
########################################################################

poetry