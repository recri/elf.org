#######################################################################
##
## astronomical computations taken from xephem 3.1
##

package provide astro 3.1

namespace eval ::astro:: {
    variable MJD0 2415020.0;		# starting point for MJD calculations
    variable J2000 [expr (2451545.0 - $MJD0)]
    variable SIDRATE .9972695677;	# ratio of from synodic (solar) to sidereal (stellar) rate
    variable PI [expr {atan2(0, -1)}]
    variable SPD [expr {24*60*60}]
    variable cal_mjd
    variable mjd_cal
    variable dpm
    array set dpm { 1 31 2 28 3 31 4 30 5 31 6 30 7 31 8 31 9 30 10 31 11 30 12 31}
    variable mjd_year
    variable sin_obliquity
    variable cos_obliquity
    variable obliquity
    namespace export {[a-z]*}
}

##
## circular conversions
##
proc ::astro::degrad {degrees}	"expr {\$degrees*[expr atan2(0,-1)/180.0]}"
proc ::astro::raddeg {radians}	"expr {\$radians/[expr atan2(0,-1)/180.0]}"
proc ::astro::hrdeg {hours} 	"expr {\$hours*15.0}"
proc ::astro::deghr {degrees}	"expr {\$degrees/15.0}"
proc ::astro::hrrad {hours}	"expr {\$hours*[expr 15.0*atan2(0,-1)/180.0]}"
proc ::astro::radhr {radians}	"expr {\$radians/[expr 15.0*atan2(0,-1)/180.0]}"

##
## altitude azimuth to equatorial
##

## given geographical latitude (n+, radians), lat, altitude (up+, radians),
## alt, and azimuth (angle round to the east from north+, radians),
## return hour angle (radians), ha, and declination (radians), dec.
proc ::astro::aa_hadec {lat alt az} {
    variable PI
    foreach {ha dec} [Aaha_aux $lat $az $alt] break
    if {$ha > $PI} {
	set ha [expr {$ha-2*$PI}]
    }
    list $ha $dec
}

## given geographical (n+, radians), lat, hour angle (radians), ha, and
## declination (radians), dec, return altitude (up+, radians), alt, and
## azimuth (angle round to the east from north+, radians),
proc ::astro::hadec_aa {lat ha dec} {
    Aaha_aux $lat $ha $dec
}

## the actual formula is the same for both transformation directions so
## do it here once for each way.
## N.B. all arguments are in radians.
proc ::astro::Aaha_aux {lat x y} {
    variable PI
    foreach {slat clat} [Sincos_latitude $lat] break
    foreach {cap B} [solve_sphere [expr {-$x}] [expr {$PI/2-$y}] $slat $clat] break
    list $B [expr {$PI/2 - acos($cap)}];
}

##
## sexagesimal conversions
##
proc ::astro::sexhr {sex} {
    switch -regexp -- $sex {
	{^-?[0-9]+:[0-9]+:[0-9]+\.[0-9]*$} -
	{^-?[0-9]+:[0-9]+:[0-9]+$} {
	    foreach {h m s} [split $sex :] break
	}
	{^-?[0-9]+:[0-9]+\.[0-9]*$} -
	{^-?[0-9]+:[0-9]+$} {
	    set s 0
	    foreach {h m} [split $sex :] break
	}
	{^-?[0-9]+\.[0-9]*$} -
	{^-?[0-9]+$} {
	    set m 0
	    set s 0
	    set h $sex
	}
	default {
	    error "cannot parse: $sex"
	}
    }
    foreach v {h m s} {
	while {[regexp {^(-?)0([0-9])(.*)$} [set $v] all sign lead rest]} {
	    set $v $sign$lead$rest
	}
    }
    if {[catch {
	set sign 1
	if {$h < 0} {
	    set sign -1
	    set h [expr {-$h}]
	} elseif {"$h" == "-0"} {
	    set sign -1
	    set h 0
	}
	expr {$sign*($h+($m+$s/60.0)/60.0)}
    } error]} {
	global errorInfo
	error "parsing $sex: $error\n$errorInfo"
    }
    set error
}
proc ::astro::sexdeg {sex} {
    sexhr $sex
}

##
## functions to manipulate the modified-julian-date used throughout xephem.
##

## given a date in months, mn, days, dy, years, yr,
## return the modified Julian date (number of days elapsed since 1900 jan 0.5),
proc ::astro::cal_mjd {yr mn dy} {
    variable cal_mjd
    # int b, d, m, y;
    # long c;
    # int a;
    if { ! [info exists cal_mjd($yr,$mn,$dy)]} {
	set m $mn
	set y $yr
	if {$yr < 0} {
	    incr y 1
	}
	if {$mn < 3} {
	    incr m 12
	    incr y -1
	}
	
	if {$yr < 1582 || ($yr == 1582 && ($mn < 10 || ($mn == 10 && $dy < 15)))} {
	    set b 0
	} else {
	    set a [expr {int($y/100)}]
	    set b [expr {2 - $a + $a/4}]
	}
	
	if {$y < 0} {
	    set c [expr {int((365.25*$y) - 0.75) - 694025}]
	} else {
	    set c [expr {int(365.25*$y) - 694025}]
	}
	set d [expr {int(30.6001*($m+1))}]
	
	set cal_mjd($yr,$mn,$dy) [expr {$b + $c + $d + $dy - 0.5}]
    }
    return $cal_mjd($yr,$mn,$dy)
}

## given the modified Julian date (number of days elapsed since 1900 jan 0.5,),
## mjd, return the calendar date in months, *mn, days, *dy, and years, *yr.
proc ::astro::mjd_cal {mjd} {
    variable mjd_cal
    if { ! [info exists mjd_cal($mjd)]} {
	set d [expr {$mjd + 0.5}]
	set i [expr {floor($d)}]
	set f [expr {$d-$i}];
	if {$f == 1} {
	    set f 0;
	    incr i;
	}

	if {$i > -115860.0} {
	    set a [expr {floor(($i/36524.25)+.99835726)+14}]
	    set i [expr {$i+ 1 + $a - floor($a/4.0)}]
	}

	set b [expr {floor(($i/365.25)+.802601)}]
	set ce [expr {$i - floor((365.25*$b)+.750001)+416}]
	set g [expr {floor($ce/30.6001)}]
	set mn [expr {$g - 1}]
	set dy [expr {$ce - floor(30.6001*$g)+$f}]
	set yr [expr {$b + 1899}]

	if {$g > 13.5} { set mn [expr {$g - 13}] }
	if {$mn < 2.5} { set yr [expr {$b + 1900}] }
	if {$yr < 1} { incr yr -1 }

	set mjd_cal($mjd) [list $yr $mn $dy]
    }
    return $mjd_cal($mjd)
}

## given an mjd, return 0..6 according to which day of the week it falls on (0=sunday).
proc ::astro::mjd_dow {mjd} {
    ## cal_mjd() uses Gregorian dates on or after Oct 15, 1582.
    ## (Pope Gregory XIII dropped 10 days, Oct 5..14, and improved the leap-
    ## year algorithm). however, Great Britian and the colonies did not
    ## adopt it until Sept 14, 1752 (they dropped 11 days, Sept 3-13,
    ## due to additional accumulated error). leap years before 1752 thus
    ## can not easily be accounted for from the cal_mjd() number...

    if {$mjd < -53798.5} {
	## pre sept 14, 1752 too hard to correct |:-S
	error "cannot compute day of week prior to sept 14, 1752"
    }
    set dow [expr {(floor($mjd-.5) + 1) % 7}]; # 1/1/1900 (mjd 0.5) is a Monday
    if {$dow < 0} {
	incr dow 7
    }
    return $dow
}

## given a mjd, return the the number of days in the month.
proc ::astro::mjd_dpm {mjd} {
    variable dpm
    foreach {y m d} [mjd_cal $mjd] break
    if {$m==2 && (($y%4==0 && $y%100!=0)||$y%400==0)} {
	return 29
    }
    return $dpm($m)
}

## given a mjd, return the year as a double.
proc ::astro::mjd_year {mjd} {
    variable mjd_year
    if { ! [info exists mjd_year($mjd)]} {
	foreach {y m d} [mjd_cal $mjd] break
	if {$y == -1} { set y -2 }
	set e0 [cal_mjd $y 1 1.0]
	set e1 [cal_mjd [expr {$y+1}] 1 1.0]
	set mjd_year($mjd) [expr {$y + ($mjd - $e0)/($e1 - $e0)}]
    }
    return $mjd_year($mjd)
}

## given a decimal year, return mjd
proc ::astro::year_mjd {y} {
    set yf [expr {floor($y)}]
    if {$yf == -1} { set yf -2 }
    set e0 [cal_mjd $yf 1 1.0]
    set e1 [cal_mjd [expr {$yf+1}] 1 1.0]
    expr {$e0 + ($y - $yf)*($e1-$e0)}
}

## round a time in days, *t, to the nearest second
proc ::astro::rnd_second {t} {
    variable SPD
    expr {floor($t*$SPD+0.5)/$SPD}
}
	
## given an mjd, truncate it to the beginning of the whole day
proc ::astro::mjd_day {jd} {
    expr {floor($jd-0.5)+0.5}
}

## given an mjd, return the number of hours past midnight of the whole day
proc ::astro::mjd_hr {jd} {
    expr {($jd-[mjd_day $jd])*24.0};
}

## insure 0 <= v < r.
proc ::astro::Range {v r} {
    expr {$v - $r*floor($v/$r)}
}

##
## given the modified Julian date, mjd, and an equitorial ra and dec, each in
## radians, find the corresponding geocentric ecliptic latitude, *lat, and
## longititude, *lng, also each in radians.
## correction for the effect on the angle of the obliquity due to nutation is
## not included.
##
proc ::astro::eq_ecl {mjd ra dec} { ecleq_aux 1 $mjd $ra $dec }

##
## given the modified Julian date, mjd, and a geocentric ecliptic latitude,
## *lat, and longititude, *lng, each in radians, find the corresponding
## equitorial ra and dec, also each in radians.
## correction for the effect on the angle of the obliquity due to nutation is
## not included.
##
proc ::astro::ecl_eq {mjd lat lng} { ecleq_aux -1 $mjd $lng $lat }

proc ::astro::ecleq_aux {sw mjd x y} {
    variable PI
    foreach {seps ceps} [Sincos_obliquity $mjd] break
    set sy [expr {sin($y)}];
    set cy [expr {cos($y)}];		# always non-negative
    if {abs($cy) < 1e-20} {
	set cy 1e-20;			# insure > 0		
    }
    set ty [expr {$sy/$cy}]
    set cx [expr {cos($x)}]
    set sx [expr {sin($x)}]
    set q [expr {asin(($sy*$ceps)-($cy*$seps*$sx*$sw))}]
    set p [expr {atan((($sx*$ceps)+($ty*$seps*$sw))/$cx)}]
    if {$cx < 0} {
	set p [expr {$p+$PI}];		# account for atan quad ambiguity
    }
    set p [Range $p [expr {2*$PI}]]
    list $p $q
}

##
## given the modified Julian date, mjd, find the mean obliquity of the
## ecliptic, *eps, in radians.
##
## IAU expression (see e.g. Astron. Almanac 1984); stern
##
proc ::astro::obliquity {mjd} {
    variable obliquity
    variable J2000
    if { ! [info exists obliquity($mjd)]} {
	# centuries from J2000
	set t [expr {($mjd - $J2000)/36525.}]
	set obliquity($mjd) [degrad [expr {(23.4392911 +
					     $t * (-46.8150 +
						   $t * ( -0.00059 +
							  $t * (  0.001813 )))/3600.0)}]]
    }
    return $obliquity($mjd)
}

proc ::astro::Sincos_obliquity {mjd} {
    variable sincos_obliquity
    if { ! [info exists sincos_obliquity($mjd)]} {
	set eps [obliquity $mjd];		# mean obliquity for date
	set sincos_obliquity($mjd) [list [expr {sin($eps)}]  [expr {cos($eps)}]]
    }
    return $sincos_obliquity($mjd)
}

