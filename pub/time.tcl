##
## time.tcl - converting julian time into calendar date and vice versa
##
## Copyright 1995 by Roger E. Critchlow Jr., San Francisco, California
## All rights reserved, fair use permitted, caveat emptor.
## rec@elf.org
##
## These formulae are taken from Jean Meeus, Astronomical
## Formulae for Calculators, Willman-Bell, Richmond, VA, 1982.
##

##
## convert seconds since January 1, 1970 0h UT
## into a list of year, month, day, hour, minute, and second UT
## 
proc fmtclock {seconds-since-jan-1-1970} {
    with-global-binding tcl_precision 17 {
	set date [julian-day-to-calendar-day [expr 2440587.5 + ${seconds-since-jan-1-1970} / double(24*60*60)]];
    }
    return $date;
}

##
## convert a packed date, as in 950908, into a julian day
##
proc packed-date-to-julian-day {yymmdd} {
    set year 19[string range $yymmdd 0 1];
    set month [string range $yymmdd 2 3];
    set day [string range $yymmdd 4 5];
    if {[string index $month 0] == 0} {
	set month [string index $month 1];
    }
    if {[string index $day 0] == 0} {
	set day [string index $day 1];
    }
    return [calendar-day-to-julian-day $year $month $day];
}

##
## convert year, month, day, hour, minute, second into julian day.
## also works for nonpositive years, which are 1 - yearBC.
##
proc calendar-day-to-julian-day {year month day {hour 0} {minute 0} {second 0}} {
    with-global-binding tcl_precision 17 {
	# adjust year and month
	if {$month <= 2} {
	    set m [expr 12+$month]
	    set y [expr $year-1];
	} else {
	    set m $month;
	    set y $year;
	}
	# convert to fractional day
	set day [dhms-to-fractional-day $day $hour $minute $second];
	# compute julian day in julian calendar
	if {$y > 0} {
	    set jday [expr int(365.25 * $y) + int(30.6001 * ($m + 1)) + $day + 1720994.5];
	} else {
	    set jday [expr int(365.25 * $y - 0.75) + int(30.6001 * ($m + 1)) + $day + 1720994.5];
	}
	# adjust for leap years in gregorian calendar
	# note: this date for the adoption of the gregorian reform
	# may be several centuries wrong in some jurisdictions,
	# see the encyclopedia brittanica for more details
	if {$jday >= 2299161} {
	    set A [expr int($y / 100)];
	    set B [expr 2 - $A + int($A / 4)];
	    set jday [expr $jday + $B];
	}
    }
    return [format %.4f $jday];
}

##
## convert julian day into year, month, day, hour, minute, second
##
proc julian-day-to-calendar-day {jday} {
    if {$jday < 0} {
	error "cannot convert negative julian days";
    }
    with-global-binding tcl_precision 17 {
	set Z [expr int($jday+0.5)]
	set F [expr $jday+0.5-$Z];
	if {$Z < 2299161} {
	    set A $Z;
	} else {
	    set alpha [expr int(($Z - 1867216.25)/36524.25)];
	    set A [expr $Z + 1 + $alpha - int($alpha/4)];
	}
	set B [expr $A + 1524];
	set C [expr int(($B - 122.1)/365.25)];
	set D [expr int(365.25 * $C)];
	set E [expr int(($B - $D)/30.6001)];
	set day [expr $B - $D - int(30.6001 * $E) + $F];
	if {$E < 13.5} {
	    set m [expr $E - 1];
	} else {
	    set m [expr $E - 13];
	}
	if {$m > 2.5} {
	    set y [expr $C - 4716];
	} else {
	    set y [expr $C - 4715];
	}
    }
    return [concat $y $m [fractional-day-to-dhms $day]];
}

##
## convert julian day into weekday, sunday = 0, monday = 1, ...
##
proc julian-day-to-weekday {jday} {
    return [expr int($jday+1.5) % 7];
}

##
## convert day, hour, minute, second into day with fraction
##
proc dhms-to-fractional-day {day hour minute second} {
    return [format %.4f [expr ((((($second/60.0)+$minute)/60.0)+$hour)/24.0)+$day]];
}

##
## convert day with fraction into day, hour, minute, second
##
proc fractional-day-to-dhms {day} {
    set d [expr int($day)];
    set hour [expr ($day - $d) * 24];
    set h [expr int($hour)];
    set minute [expr ($hour - $h) * 60];
    set m [expr int($minute)];
    set s [format %.4f [expr ($minute - $m) * 60]];
    return [list $d $h $m $s];
}

##
## evaluate expression with temporary global binding
##
proc with-global-binding {variable value expression} {
    global $variable errorInfo;
    if {[info exists $variable]} {
	set restore "set $variable [set $variable]";
    } else {
	set restore "unset $variable";
    }
    if {[catch {set $variable $value} error]} {
	error $result $errorInfo;
    }
    if {[catch {uplevel $expression} result]} {
	catch $restore;
	error $result $errorInfo;
    } else {
	catch $restore;
	return $result;
    }
}

