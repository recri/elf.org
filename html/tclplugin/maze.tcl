###
### maze - a maze drawing and solving game for the TclPlugin
###
### Copyright 1995 by Roger E. Critchlow Jr., San Francisco,  California.
### All rights reserved.  Fair use permitted.  No warranty.
### 
### This game is a straightforward conversion to Tcl from the maze
### mode screensaver in xlockmore-3.0, available in the contrib
### directory of any X11R6 archive site.
###
### The added value is that now you can try to solve the maze yourself
### by steering around with the cursor keys.  The space bar will back
### you up, too.  And when you get tired the program will still solve
### the maze for you.
###
### Here are the original copyrights and credits.
###
### maze.c - A maze for xlock, the X Window System lockscreen.
### Copyright (c) 1988 by Sun Microsystems
### See xlock.c for copying information.
### Revision History:
### 20-Jul-95: minimum size fix (Peter Schmitzberger schmitz@coma.sbg.ac.at)
### 17-Jun-95: removed sleep statements
### 22-Mar-95: multidisplay fix (Caleb Epstein epstein_caleb@jpmorgan.com)
### 9-Mar-95: changed how batchcount is used 
### 27-Feb-95: patch for VMS
### 4-Feb-95: patch to slow down maze (Heath Kehoe hakehoe@icaen.uiowa.edu)
### 17-Jun-94: HP ANSI C compiler needs a type cast for gray_bits
###            Richard Lloyd (R.K.Lloyd@csc.liv.ac.uk) 
### 2-Sep-93: xlock version (David Bagley bagleyd@source.asset.com) 
### 7-Mar-93: Good ideas from xscreensaver (Jamie Zawinski jwz@lucid.com)
### 6-Jun-85: Martin Weiss Sun Microsystems 
###
### ******************************************************************************
### Copyright 1988 by Sun Microsystems, Inc. Mountain View, CA.
###
### All Rights Reserved
###
### Permission to use, copy, modify, and distribute this software and its
### documentation for any purpose and without fee is hereby granted,
### provided that the above copyright notice appear in all copies and that
### both that copyright notice and this permission notice appear in
### supporting documentation, and that the names of Sun or MIT not be
### used in advertising or publicity pertaining to distribution of the
### software without specific prior written permission. Sun and M.I.T.
### make no representations about the suitability of this software for
### any purpose. It is provided "as is" without any express or implied warranty.
###
### SUN DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
### ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
### PURPOSE. IN NO EVENT SHALL SUN BE LIABLE FOR ANY SPECIAL, INDIRECT
### OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
### OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
### OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE
### OR PERFORMANCE OF THIS SOFTWARE.
### *****************************************************************************/
###

########################################################################
#
########################################################################
proc maze {} {
    global maze;
    set maze(MIN-MAZE-SIZE)	3
    set maze(MAX-SIZE)		128
    set maze(MIN-SIZE)		8

    # The following limits are adequate for displays up to 2048x2048
    set maze(MAX-MAZE-SIZE-X)	300
    set maze(MAX-MAZE-SIZE-Y)	300

    set maze(WALL-TOP)		0x8000;
    set maze(WALL-RIGHT)	0x4000;
    set maze(WALL-BOTTOM)	0x2000;
    set maze(WALL-LEFT)		0x1000;

    set maze(DOOR-IN-TOP)	0x800;
    set maze(DOOR-IN-RIGHT)	0x400;
    set maze(DOOR-IN-BOTTOM)	0x200;
    set maze(DOOR-IN-LEFT)	0x100;
    set maze(DOOR-IN-ANY)	0xF00;

    set maze(DOOR-OUT-TOP)	0x80;
    set maze(DOOR-OUT-RIGHT)	0x40;
    set maze(DOOR-OUT-BOTTOM)	0x20;
    set maze(DOOR-OUT-LEFT)	0x10;

    set maze(START-SQUARE)	0x2;
    set maze(END-SQUARE)	0x1;

    # The following need to be initialized
    set maze(square-name) medium;
    set maze(solid) black;
    set maze(fuzzy) grey50;
    set maze(square-menu) {smallest smaller small medium large larger largest};
    set maze(keep) "[array names maze] keep"

    #
    # pick up embedded arguments
    #
    global embed_args;
    array set maze [array get embed_args];

    #
    # seed the random number generate
    #
    if {[info exists maze(srandom)]} {
	srandom $maze(srandom);
    } else {
	srandom [clock seconds];
    }

    #
    # build the board
    #
    pack [canvas .c -relief raised] -side top -expand true -fill both;
    bind . <KeyPress> {move-into-square .c %K};
    bind .c <Motion> {move-toward-pointer .c %x %y}
    pack [frame .b] -side top;
    pack [button .b.new -text {New} -command {new-maze .c}] -side left
    pack [button .b.solve -text {Solve} -command {solve-maze .c}] -side left
    pack [button .b.more -text {More} -command {more-maze .c}] -side left
    pack [button .b.less -text {Less} -command {less-maze .c}] -side left
    update idletasks
    new-maze .c
}

proc new-maze {w} {
    initmaze $w;
    clear-window $w;
    set-maze-sizes;
    initialize-maze;
    draw-maze-border $w;
    create-maze $w;
    initialize-path $w;
}

proc more-maze {w} {
    global maze;
    set i [lsearch $maze(square-menu) $maze(square-name)];
    if {[incr i -1] < 0} {
	set i 0;
    }
    set maze(square-name) [lindex $maze(square-menu) $i];
    new-maze $w;
}

proc less-maze {w} {
    global maze;
    set i [lsearch $maze(square-menu) $maze(square-name)];
    if {[incr i] >= [llength $maze(square-menu)]} {
	set i [expr [llength $maze(square-menu)]-1];
    }
    set maze(square-name) [lindex $maze(square-menu) $i];
    new-maze $w;
}

proc get-random {x} {
    return [expr [random] % $x];
}

proc initmaze {w} {
    global maze;

    foreach name [array names maze] {
	if {[lsearch $maze(keep) $name] < 0} {
	    unset maze($name);
	}
    }
    set maze(width) [winfo width $w];
    set maze(height) [winfo height $w];
    set maze(xscale) 1;
    set maze(yscale) 1;
    set maze(time) 0;
    set maze(solved) 0;
    set maze(stage) 0;
}

proc clear-window {w} {
    global maze;

    $w delete all;
}

proc set-maze-sizes {} {
    global maze;
    
    if {$maze(width) > $maze(height)} {
	set edge [expr $maze(height) - 8];
    } else {
	set edge [expr $maze(width) - 8];
    }
    set maze(smallest) 8;
    set maze(largest) [expr $edge / 3];
    set maze(medium) [expr ($maze(smallest) + $maze(largest)) / 2];
    set maze(small) [expr ($maze(smallest) + 2 * $maze(medium)) / 3];
    set maze(smaller) [expr (2 * $maze(smallest) + $maze(medium)) / 3];
    set maze(large) [expr ($maze(largest) + 2 * $maze(medium)) / 3];
    set maze(larger) [expr (2 * $maze(largest) + $maze(medium)) / 3];
    set maze(square) [expr int($maze($maze(square-name)))];
    if {$maze(square) > $maze(largest)} {
	set maze(sq-size-x) [expr [get-random [expr $maze(largest) - $maze(smallest) + 1]] + $maze(smallest)];
    } elseif {$maze(square) < $maze(smallest)} {
	set maze(sq-size-x) $maze(smallest);
    } else {
	set maze(sq-size-x) $maze(square);
    }
    set maze(sq-size-y) $maze(sq-size-x);
	
    set maze(border-x) 4;
    set maze(border-y) 4;
    set maze(maze-size-x) [expr ( $maze(width) - $maze(border-x) ) / $maze(sq-size-x)];
    set maze(maze-size-y) [expr ( $maze(height) - $maze(border-y) ) / $maze(sq-size-y)];

    if { $maze(maze-size-x) < $maze(MIN-MAZE-SIZE) || $maze(maze-size-y) < $maze(MIN-MAZE-SIZE)} {
	set maze(sq-size-y) 10;
	set maze(sq-size-x) 10;
	set maze(maze-size-x) [expr ( $maze(width) - $maze(border-x) ) / $maze(sq-size-x)];
	set maze(maze-size-y) [expr ( $maze(height) - $maze(border-y) ) / $maze(sq-size-y)];
	if { $maze(maze-size-x) < $maze(MIN-MAZE-SIZE) || $maze(maze-size-y) < $maze(MIN-MAZE-SIZE)} {
	    error "maze too small ($maze(maze-size-x) x $maze(maze-size-y)), exitting"
	}
    }
    set maze(border-x) [expr ($maze(width) - $maze(maze-size-x) * $maze(sq-size-x)) / 2];
    set maze(border-y) [expr ($maze(height) - $maze(maze-size-y) * $maze(sq-size-y)) / 2];
}

proc initialize-maze {} {
    global maze;

    # initialize to zero
    for {set i 0} {$i < $maze(maze-size-x)} {incr i} {
	for {set j 0} {$j < $maze(maze-size-y)} {incr j} {
	    set maze(maze-$i-$j) 0;
	}
    }

    # top wall
    for {set i 0} {$i < $maze(maze-size-x)} {incr i} {
	set maze(maze-$i-0) [expr $maze(maze-$i-0) | $maze(WALL-TOP)];
    }

    # right wall
    set i [expr $maze(maze-size-x)-1];
    for {set j 0} {$j < $maze(maze-size-y)} {incr j} {
	set maze(maze-$i-$j) [expr $maze(maze-$i-$j) | $maze(WALL-RIGHT)];
    }

    # bottom wall
    set j [expr $maze(maze-size-y)-1];
    for {set i 0} {$i < $maze(maze-size-x)} {incr i} {
	set maze(maze-$i-$j) [expr $maze(maze-$i-$j) | $maze(WALL-BOTTOM)];
    }

    # left wall
    for {set j 0} {$j < $maze(maze-size-y)} {incr j} {
	set maze(maze-0-$j) [expr $maze(maze-0-$j) | $maze(WALL-LEFT)];
    }

    # set start square
    set wall [get-random 4];
    switch -exact $wall {
	0 {
	    set i [get-random $maze(maze-size-x)];
	    set j  0;
	}
	1 {
	    set i [expr $maze(maze-size-x) - 1];
	    set j [get-random $maze(maze-size-y)];
	}
	2 {
	    set i [get-random $maze(maze-size-x)];
	    set j [expr $maze(maze-size-y) - 1];
	}
	3 {
	    set i 0;
	    set j [get-random $maze(maze-size-y)];
	}
    }
    set maze(maze-$i-$j) [expr ($maze(maze-$i-$j) | $maze(START-SQUARE) | ( $maze(DOOR-IN-TOP) >> $wall )) & ~( $maze(WALL-TOP) >> $wall )];
    set maze(cur-sq-x) $i;
    set maze(cur-sq-y) $j;
    set maze(start-x) $i;
    set maze(start-y) $j;
    set maze(start-dir) $wall;
    set maze(sqnum) 0;

    # set end square */
    set wall [expr ($wall + 2)%4];
    switch -exact $wall {
	0 {
	    set i [get-random $maze(maze-size-x)];
	    set j  0;
	}
	1 {
	    set i [expr $maze(maze-size-x) - 1];
	    set j [get-random $maze(maze-size-y)];
	}
	2 {
	    set i [get-random $maze(maze-size-x)];
	    set j [expr $maze(maze-size-y) - 1];
	}
	3 {
	    set i 0;
	    set j [get-random $maze(maze-size-y)];
	}
    }
    set maze(maze-$i-$j) [expr ($maze(maze-$i-$j) | $maze(END-SQUARE) | ( $maze(DOOR-OUT-TOP) >> $wall )) & ~( $maze(WALL-TOP) >> $wall )];
    set maze(end-x) $i;
    set maze(end-y) $j;
    set maze(end-dir) $wall;
}

# create a maze layout given the initialized maze
proc create-maze {w} {
    global maze;

    while 1 {
	set maze(move-$maze(sqnum)-x) $maze(cur-sq-x);
	set maze(move-$maze(sqnum)-y) $maze(cur-sq-y);

	# pick a door
	while { [set newdoor [choose-door $w]] == -1 } {
	    # no more doors ... backup
	    if { [backup] == -1 } { 
		# done ... return
		return;
	    }
	}
	# mark the out door
	set maze(maze-$maze(cur-sq-x)-$maze(cur-sq-y)) [expr $maze(maze-$maze(cur-sq-x)-$maze(cur-sq-y)) | ( $maze(DOOR-OUT-TOP) >> $newdoor )];

	switch -exact $newdoor {
	    0 { incr maze(cur-sq-y) -1; }
	    1 { incr maze(cur-sq-x) +1; }
	    2 { incr maze(cur-sq-y) +1; }
	    3 { incr maze(cur-sq-x) -1; }
	}
	incr maze(sqnum) +1;

	# mark the in door
	set maze(maze-$maze(cur-sq-x)-$maze(cur-sq-y)) \
	    [expr $maze(maze-$maze(cur-sq-x)-$maze(cur-sq-y)) | ( $maze(DOOR-IN-TOP) >> (($newdoor+2)%4) )];
    }
}

# pick a new path
proc choose-door {w} {
    global maze;

    set cx $maze(cur-sq-x);
    set cy $maze(cur-sq-y);
    set c $maze(maze-$cx-$cy);
    set candidates {};

    # top wall
    if {(!( $c & $maze(DOOR-IN-TOP) )) &&
	(!( $c & $maze(DOOR-OUT-TOP) )) &&
	(!( $c & $maze(WALL-TOP) ))} {
	set nbr $maze(maze-$cx-[expr $cy-1]);
	if { $nbr & $maze(DOOR-IN-ANY) } {
	    set maze(maze-$cx-$cy) [expr $c | $maze(WALL-TOP)];
	    set c $maze(maze-$cx-$cy);
	    set maze(maze-$cx-[expr $cy-1]) [expr $nbr | $maze(WALL-BOTTOM)];
	    draw-wall $w $maze(cur-sq-x) $maze(cur-sq-y) 0;
	} else {
	    lappend candidates 0;
        }
    }

    # right wall
    if {(!( $c & $maze(DOOR-IN-RIGHT) )) &&
	(!( $c & $maze(DOOR-OUT-RIGHT) )) &&
	(!( $c & $maze(WALL-RIGHT) ))} {
	set nbr $maze(maze-[expr $cx+1]-$cy);
	if { $nbr & $maze(DOOR-IN-ANY) } {
	    set maze(maze-$cx-$cy) [expr $c | $maze(WALL-RIGHT)];
	    set c $maze(maze-$cx-$cy);
	    set maze(maze-[expr $cx+1]-$cy) [expr $nbr | $maze(WALL-LEFT)];
	    draw-wall $w $maze(cur-sq-x) $maze(cur-sq-y) 1;
	} else {
	    lappend candidates 1;
        }
    }

    # bottom wall
    if {(!( $c & $maze(DOOR-IN-BOTTOM) )) &&
	(!( $c & $maze(DOOR-OUT-BOTTOM) )) &&
	(!( $c & $maze(WALL-BOTTOM) ))} {
	set nbr $maze(maze-$cx-[expr $cy+1]);
	if { $nbr & $maze(DOOR-IN-ANY) } {
	    set maze(maze-$cx-$cy) [expr $c | $maze(WALL-BOTTOM)];
	    set c $maze(maze-$cx-$cy);
	    set maze(maze-$cx-[expr $cy+1]) [expr $nbr | $maze(WALL-TOP)];
	    draw-wall $w $maze(cur-sq-x) $maze(cur-sq-y) 2;
	} else {
	    lappend candidates 2;
        }
    }
    
    # left wall
    if {(!( $c & $maze(DOOR-IN-LEFT) )) &&
	(!( $c & $maze(DOOR-OUT-LEFT) )) &&
	(!( $c & $maze(WALL-LEFT) ))} {
	set nbr $maze(maze-[expr $cx-1]-$cy);
	if { $nbr & $maze(DOOR-IN-ANY) } {
	    set maze(maze-$cx-$cy) [expr $c | $maze(WALL-LEFT)];
	    set c $maze(maze-$cx-$cy);
	    set maze(maze-[expr $cx-1]-$cy) [expr $nbr | $maze(WALL-RIGHT)];
	    draw-wall $w $maze(cur-sq-x) $maze(cur-sq-y) 3;
	} else {
	    lappend candidates 3;
        }
    }

    # done wall
    set num [llength $candidates];
    switch -exact $num {
	0 { return -1;	}
	1 { return $candidates; }
	default { return [lindex $candidates [get-random $num]]; }
    }
}

# back up a move
proc backup {} {
    global maze;

    if {[incr maze(sqnum) -1] != -1} {
	set maze(cur-sq-x) $maze(move-$maze(sqnum)-x);
	set maze(cur-sq-y) $maze(move-$maze(sqnum)-y);
    }
    return $maze(sqnum);
}

# draw the maze outline
proc draw-maze-border {w} {
    global maze;

    set lines {};
    for {set i 0} {$i < $maze(maze-size-x)} {incr i} {
	if {$maze(maze-$i-0) & $maze(WALL-TOP) } {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x) * $i];
	    set y1 $maze(border-y);
	    set x2 [expr $maze(border-x) + $maze(sq-size-x) * ($i+1)];
	    set y2 $maze(border-y);
	    $w create line $x1 $y1 $x2 $y2 -fill $maze(solid) -tags wall;
	}
	if {$maze(maze-$i-[expr $maze(maze-size-y) - 1]) & $maze(WALL-BOTTOM)} {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y) * $maze(maze-size-y)];
	    set x2 [expr $maze(border-x) + $maze(sq-size-x) * ($i+1)];
	    set y2 [expr $maze(border-y) + $maze(sq-size-y) * $maze(maze-size-y)];
	    $w create line $x1 $y1 $x2 $y2 -fill $maze(solid) -tags wall;
	}
    }
    for {set j 0} {$j < $maze(maze-size-y)} {incr j} {
	if { $maze(maze-[expr $maze(maze-size-x) - 1]-$j) & $maze(WALL-RIGHT) } {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x) * $maze(maze-size-x)];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y) * $j];
	    set x2 [expr $maze(border-x) + $maze(sq-size-x) * $maze(maze-size-x)];
	    set y2 [expr $maze(border-y) + $maze(sq-size-y) * ($j+1)];
	    $w create line $x1 $y1 $x2 $y2 -fill $maze(solid) -tags wall;
	}
	if { $maze(maze-0-$j) & $maze(WALL-LEFT) } {
	    set x1 $maze(border-x);
	    set y1 [expr $maze(border-y) + $maze(sq-size-y) * $j];
	    set x2 $maze(border-x);
	    set y2 [expr $maze(border-y) + $maze(sq-size-y) * ($j+1)];
	    $w create line $x1 $y1 $x2 $y2 -fill $maze(solid) -tags wall;
	}
    }
    draw-solid-square $w $maze(start-x) $maze(start-y) $maze(start-dir) $maze(solid) start;
    draw-solid-square $w $maze(end-x) $maze(end-y) $maze(end-dir) $maze(solid) end;
}

# draw a single wall
proc draw-wall {w i j dir} {
    global maze;

    switch -exact $dir {
	0 {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y) * $j];
	    set x2 [expr $maze(border-x) + $maze(sq-size-x) * ($i+1)];
	    set y2 [expr $maze(border-y) + $maze(sq-size-y) * $j];
	}
	1 {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x) * ($i+1)];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y) * $j];
	    set x2 [expr $maze(border-x) + $maze(sq-size-x) * ($i+1)];
	    set y2 [expr $maze(border-y) + $maze(sq-size-y) * ($j+1)];
	}
	2 {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y) * ($j+1)];
	    set x2 [expr $maze(border-x) + $maze(sq-size-x) * ($i+1)];
	    set y2 [expr $maze(border-y) + $maze(sq-size-y) * ($j+1)];
	}
	3 {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y) * $j];
	    set x2 [expr $maze(border-x) + $maze(sq-size-x) * $i];
	    set y2 [expr $maze(border-y) + $maze(sq-size-y) * ($j+1)];
	}
	default {
	    error "bad direction $dir in draw-wall";
	}
    }
    $w scale [$w create line $x1 $y1 $x2 $y2 -fill $maze(solid) -tags wall] 0 0 $maze(xscale) $maze(yscale);
    update idletasks;
}

# draw a solid square in a square
proc draw-solid-square {w i j dir fill {tag at}} {
    global maze;

    switch -exact $dir {
	0 {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x)/4.0 + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) - $maze(sq-size-y)/4.0 + $maze(sq-size-y) * $j];
	    set x2 [expr $x1 + $maze(sq-size-x) - $maze(sq-size-x)/2.0];
	    set y2 [expr $y1 + $maze(sq-size-y)];
	}
	1 {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x)/4.0 + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y)/4.0 + $maze(sq-size-y) * $j];
	    set x2 [expr $x1 + $maze(sq-size-x)];
	    set y2 [expr $y1 + $maze(sq-size-y)/2.0];
	}
	2 {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x)/4.0 + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y)/4.0 + $maze(sq-size-y) * $j];
	    set x2 [expr $x1 + $maze(sq-size-x)/2.0];
	    set y2 [expr $y1 + $maze(sq-size-y)];
	}
	3 {
	    set x1 [expr $maze(border-x) - $maze(sq-size-x)/4.0 + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y)/4.0 + $maze(sq-size-y) * $j];
	    set x2 [expr $x1 + $maze(sq-size-x)];
	    set y2 [expr $y1 + $maze(sq-size-y)/2.0];
	}
	default {
	    set x1 [expr $maze(border-x) + $maze(sq-size-x)/4.0 + $maze(sq-size-x) * $i];
	    set y1 [expr $maze(border-y) + $maze(sq-size-y)/4.0 + $maze(sq-size-y) * $j];
	    set x2 [expr $x1 + $maze(sq-size-x)/2.0];
	    set y2 [expr $y1 + $maze(sq-size-y)/2.0];
	}
    }
    $w delete $tag-$i-$j;
    if {"$tag" == {start}} {
	$w scale [$w create oval $x1 $y1 $x2 $y2 -fill $fill -outline {} -tags "$tag-$i-$j oval"] 0 0 $maze(xscale) $maze(yscale);
    } else {
	$w scale [$w create rectangle $x1 $y1 $x2 $y2 -fill $fill -outline {} -tags "$tag-$i-$j square"] 0 0 $maze(xscale) $maze(yscale);
    }
}

# set up the solution
proc initialize-path {w} {
    global maze;
    # plug up the surrounding wall
    set maze(maze-$maze(start-x)-$maze(start-y)) \
	[expr $maze(maze-$maze(start-x)-$maze(start-y)) | ($maze(WALL-TOP) >> $maze(start-dir))];
    set maze(maze-$maze(end-x)-$maze(end-y)) \
	[expr $maze(maze-$maze(end-x)-$maze(end-y)) | ($maze(WALL-TOP) >> $maze(end-dir))];

    # initialize search path
    set maze(current-path) 0;
    set maze(path-$maze(current-path)-x) $maze(end-x);
    set maze(path-$maze(current-path)-y) $maze(end-y);
    set maze(path-$maze(current-path)-dir) -1;
}

# solve it with graphical feedback
proc solve-maze {w} {
    global maze;
    set start $maze(current-path);
    while {($maze(maze-$maze(path-$maze(current-path)-x)-$maze(path-$maze(current-path)-y)) & $maze(START-SQUARE)) == 0} {
	if { [incr maze(path-$maze(current-path)-dir)] >= 4 } {
	    if {$start == $maze(current-path)} {
		set maze(path-$maze(current-path)-dir) -1;
		return;
	    }
	    if {[leave-square $w $maze(current-path)]} {
		incr maze(current-path) -1;
	    }
	} elseif {[may-move $maze(path-$maze(current-path)-x) $maze(path-$maze(current-path)-y) $maze(path-$maze(current-path)-dir)] &&
		  ($maze(current-path) == 0 ||
		   [not-backtrack $maze(path-$maze(current-path)-dir) $maze(path-[expr $maze(current-path)-1]-dir)])} {
	    enter-square $w $maze(current-path);
	    incr maze(current-path);
	}
	update;
    }
}

# allow the user to solve it
proc move-into-square {w dir} {
    global maze;

    switch -exact $dir {
	Up { set dir 0; }
	Right {set dir 1; }
	Down { set dir 2; }
	Left { set dir 3; }
	BackSpace -
	Delete -
	space {
	    if {[leave-square $w $maze(current-path)]} {
		incr maze(current-path) -1;
	    }
	    return;
	}
	default { return; }
    }
	
    if {[may-move $maze(path-$maze(current-path)-x) $maze(path-$maze(current-path)-y) $dir]} {
	if {$maze(current-path) == 0 || [not-backtrack $dir $maze(path-[expr $maze(current-path)-1]-dir)]} {
	    set maze(path-$maze(current-path)-dir) $dir;
	    enter-square $w $maze(current-path);
	    incr maze(current-path) +1;
	} else {
	    if {[leave-square $w $maze(current-path)]} {
		incr maze(current-path) -1;
	    }
	}
    }
    update;
}

proc min {a b} { if {$a < $b} { return $a } else { return $b } }
proc max {a b} { if {$a > $b} { return $a } else { return $b } }

# move toward the mouse
proc move-toward-pointer {w x y} {
    global maze;
    while {1} {
	set i $maze(path-$maze(current-path)-x)
	set j $maze(path-$maze(current-path)-y)
	if {[lsearch [$w gettags [$w find withtag current]] at-$i-$j] >= 0} {
	    return;
	}
	set x1 [expr $maze(border-x) + $maze(sq-size-x)/2.0 + $maze(sq-size-x) * $i];
	set y1 [expr $maze(border-y) + $maze(sq-size-y)/2.0 + $maze(sq-size-y) * $j];
	set dx [expr $x-$x1]
	set dy [expr $y-$y1]
	if {abs($dx) <= $maze(sq-size-x)/2.0} {
	    set x $x1;
	    set dx 0;
	}
	if {abs($dy) <= $maze(sq-size-y)/2.0} {
	    set y $y1;
	    set dy 0;
	}
	if {$dx != 0 && $dy != 0} {
	    return;
	}
	if {$dx == 0 && $dy == 0} {
	    return;
	}
	foreach item [$w find overlapping [min $x $x1] [min $y $y1] [max $x $x1] [max $y $y1]] {
	    if {[lsearch [$w gettags $item] wall] >= 0} {
		return;
	    }
	}
	if {$dx > 0} {
	    set dir Right
	} elseif {$dy > 0} {
	    set dir Down
	} elseif {$dx < 0} {
	    set dir Left
	} else {
	    set dir Up
	}
	move-into-square $w $dir;
    }
}

# may I move from here in this direction
proc may-move {x y d} {
    global maze;
    if {($maze(maze-$x-$y) & ($maze(WALL-TOP) >> $d)) == 0} {
	return 1;
    } else {
	return 0;
    }
}

# would I be backtracking in this direction
proc not-backtrack {d pd} {
    if {$d != (($pd+2)%4)} {
	return 1;
    } else {
	return 0;
    }
}

# move into a neighboring square
proc enter-square {w n} {
    global maze;

    set nn [expr $n+1];

    draw-solid-square $w $maze(path-$n-x) $maze(path-$n-y) $maze(path-$n-dir) $maze(solid);
    set maze(path-$nn-dir) -1;
    switch -exact $maze(path-$n-dir) {
	0 {
	    set maze(path-$nn-x) $maze(path-$n-x);
	    set maze(path-$nn-y) [expr $maze(path-$n-y) - 1];
	}
	1 {
	    set maze(path-$nn-x) [expr $maze(path-$n-x) + 1];
	    set maze(path-$nn-y) $maze(path-$n-y);
	}
	2 {
	    set maze(path-$nn-x) $maze(path-$n-x);
	    set maze(path-$nn-y) [expr $maze(path-$n-y) + 1];
	}
	3 {
	    set maze(path-$nn-x) [expr $maze(path-$n-x) - 1];
	    set maze(path-$nn-y) $maze(path-$n-y);
	}
	default {
	    error "bad direction $maze(path-$n-dir) in enter-square";
	}
    }
    draw-solid-square $w $maze(path-$nn-x) $maze(path-$nn-y) * $maze(solid);
}

# move out of a square back to a neighbor
proc leave-square {w n} {
    global maze;
    set nn [expr $n-1];
    if {$nn >= 0} {
	draw-solid-square $w $maze(path-$n-x) $maze(path-$n-y) [expr ($maze(path-$nn-dir)+2)%4] $maze(fuzzy);
	draw-solid-square $w $maze(path-$nn-x) $maze(path-$nn-y) * $maze(solid);
	return 1;
    } else {
	return 0;
    }
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

maze;
