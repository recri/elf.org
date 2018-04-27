#
# compute the coordinates for a moon at phase p of radius r using n points
#
namespace eval ::moon-phase {
    variable cosine
    variable sine
}

proc ::moon-phase::cosine {degrees} {
    variable cosine
    if { ! [info exists cosine($degrees)]} {
	set cosine($degrees) [expr {cos($degrees*atan2(0,-1)/180)}]
    }
    return $cosine($degrees)
}

proc ::moon-phase::sine {degrees} {
    variable sine
    if { ! [info exists sine($degrees)]} {
	set sine($degrees) [expr {sin($degrees*atan2(0,-1)/180)}]
    }
    return $sine($degrees)
}

proc ::moon-phase::moon-phase {p r {n 32}} {
    set q [expr {$n/4}]
    for {set i $q} {$i < $n+$q} {incr i} {
	set t [expr {$i*360.0/$n}]
	lappend c [expr {$r*[cosine $t]}]  [expr {$r*[sine $t]}];
    }
    switch $p {
	new { set p 0/1 }
	full { set p 1/2 }
	1qtr { set p 1/4 }
	3qtr { set p 3/4 }
    }
    if {[regexp {^([0-9]+)/([0-9]+)$} $p all num den]} {
	set p [expr {double($num)/double($den)}]
	if {$p == 0 || $p == 0.5} {
	    set c
	} elseif {$p < 0.5} {
	    moon-rotate right [eval expr (1-2*$p)*180] $c
	} elseif {$p > 0.5} {
	    moon-rotate left [eval expr (2*$p-1)*180] $c
	} else {
	    error "unknown phase of moon: $p"
	}
    } else {
	error "unknown phase of moon: $p"
    }
}

#
# rotate the left or right half of the moon circle out of the plane and project
#
proc ::moon-phase::moon-rotate {half angle moon} {
    set n [llength $moon]
    set h [expr $n/2]
    set lhalf [lrange $moon 0 [expr $h-1]]
    set rhalf [lrange $moon $h end]
    set s [cosine $angle]
    switch $half {
	right {
	    set turn $rhalf
	    set keep $lhalf
	}
	left {
	    set turn $lhalf
	    set keep $rhalf
	}
    }
    foreach {x y} $turn {
	lappend keep [expr $s*$x] $y
    }
    set keep
}

proc moon-phase {p r {n 32}} {
    ::moon-phase::moon-phase $p $r $n
}

