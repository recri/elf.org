##
## Mankala - an ancient game played with pits with stones.
## Copyright 1994, 1995, 1996 by Roger E. Critchlow Jr,
## San Francisco, CA, rec@elf.org
## All rights reserved, fair use permitted.
##

##
## Parameters from embedded arguments.
##
set mankala(width) 600;					# board width
set mankala(height) 150;				# board height
set mankala(board) \#A22;				# color to draw the board
set mankala(stones) 3;					# how many stones shall we play
set mankala(turn) s;					# whose turn is it
set mankala(s-strategy) player;				# how does she play
set mankala(n-strategy) {FindGreedy FindLast};		# how shall the other play
set mankala(stone-colors) mono;				# grey rocks (mono) or colored (poly)
set mankala(flash) 1;					# use a visual bell
set mankala(tournement) 0;				# just keep on playing.
set mankala(offset) 0.10;				# offset of pits into their cells as fraction of cell width
set mankala(flash-count) 1;				# how many visual bell flashes?
set mankala(flash-delay) 150;				# how long each bell lingers?

array set mankala [array get embed_args];

##
## Parameters not under menu control
##

# The nth stone in a pit is always drawn at the same coordinates.
set mankala(stone-positions) {
  {0.000000 0.000000} {0.217972 0.218907} {-0.272014 0.162381} {0.179665 0.348788} {-0.094970 -0.240439}
  {-0.204979 -0.084928} {0.152546 -0.307194} {-0.166098 0.134316} {-0.205408 0.280716} {-0.121325 -0.338215}
  {0.222250 -0.006898} {-0.082742 0.218746} {0.357686 0.178017} {0.036993 -0.358030} {-0.374114 0.042145}
  {-0.359701 -0.105253} {0.360943 -0.116144} {-0.252007 -0.216961} {-0.209546 0.028693} {0.174602 -0.113320}
  {0.131592 0.186656} {0.241262 0.201622} {0.010620 0.308656} {-0.009132 -0.241870} {-0.292464 -0.028814}
  {-0.143876 -0.155161} {0.289565 0.104592} {0.172069 -0.347786} {0.343502 -0.016615} {0.209288 0.304312}
  {-0.108582 0.324847} {-0.230293 0.184674} {-0.146060 -0.274423} {-0.304896 0.096659} {-0.035559 0.203095}
  {0.332053 -0.126663} {0.125088 -0.231938} {-0.003253 -0.348385} {0.237030 -0.015084} {-0.310323 -0.150385}
  {0.224924 -0.169364} {0.110059 0.382171} {0.193840 0.199084} {0.300160 0.211688} {0.060412 0.254433}
  {-0.132283 -0.158136} {-0.249805 0.283418} {-0.112328 -0.382632} {0.216677 0.087057} {-0.279635 -0.047968}
  {0.191277 -0.341519} {-0.101444 0.367966} {-0.213488 -0.294784} {-0.240403 0.138719} {-0.387785 0.062819}
  {0.304360 -0.092590} {-0.384809 -0.067083} {0.122039 -0.164067} {0.003883 0.352260} {0.049444 -0.266908}
  {0.283083 -0.198697} {0.378888 0.066668} {0.231558 0.272082} {-0.136343 0.168586} {-0.319331 -0.151880}
  {-0.060859 -0.256558} {-0.272472 0.285160} {0.148164 0.148633} {0.263064 0.089206} {0.148979 -0.281909}
  {-0.072583 0.247975} {0.351677 0.165633}
};

# The nth stone played onto the board at the beginning of the game always has the same color.
set mankala(mono-stone-colors) {
  #888 #FFF #000 #888 #000 #FFF #000 #888 #FFF #FFF
  #444 #BBB #444 #BBB #FFF #FFF #FFF #444 #444 #888
  #BBB #BBB #FFF #888 #FFF #888 #000 #888 #000 #888
  #888 #FFF #444 #FFF #444 #444 #FFF #BBB #BBB #BBB
  #BBB #444 #888 #FFF #000 #444 #000 #444 #FFF #444
  #BBB #000 #888 #000 #888 #444 #FFF #BBB #000 #FFF
  #000 #FFF #000 #BBB #FFF #BBB #444 #000 #888 #444
  #BBB #000
};
set mankala(poly-stone-colors) {
  #F00 #0F0 #FF0 #00F #FA0 #E8E #00F #FF0 #0F0 #F00
  #0FF #0FF #0FF #0F0 #0F0 #0F0 #F00 #0FF #FF0 #F00
  #FF0 #0FF #00F #F00 #00F #0FF #0F0 #FA0 #00F #0F0
  #00F #0FF #E8E #F00 #FF0 #FA0 #F00 #E8E #0F0 #00F
  #F00 #FA0 #FF0 #E8E #0FF #0FF #0F0 #E8E #0F0 #E8E
  #E8E #E8E #00F #00F #F00 #FF0 #0F0 #0F0 #0F0 #F00
  #E8E #FA0 #0FF #E8E #FF0 #F00 #F00 #FF0 #F00 #0F0
  #E8E #FA0
};

##
## random numbers
##
set randomstate 123456789;
proc random {limit} {
  global randomstate;
  return [expr [set randomstate [expr ($randomstate * 1103515245 + 12345) & 0x7FFFFFFF]] / (0x7FFFFFFF / $limit)];
}

##
## Draw one of the pits.
##
proc DrawPit {w width height} {
    global mankala;
    set ox [expr $mankala(offset)*$width];
    set oy [expr $mankala(offset)*$height];
    $w delete all;
    $w create oval $ox $oy [expr $width-$ox] [expr $height-$oy] -width 2 -fill $mankala(board) -tags pit;
    set pit [string range $w 1 end];
    foreach stone [EmptyPit $pit] {
	AddStone $pit $stone;
    }
}

##
## Flash pits so I can see what happens
##
proc FlashPits {pits {cycles 1}} {
  global mankala;
  if {$mankala(flash)} {
    while {$cycles > 0} {
      for {set i 0} {$i < $mankala(flash-count)} {incr i} {
	foreach pit $pits {
	  .$pit itemconfigure pit -outline white;
	}
	update idletasks;
	after $mankala(flash-delay);
	foreach pit $pits {
	  .$pit itemconfigure pit -outline black;
	}
	update idletasks;
	after $mankala(flash-delay);
      }
      incr cycles -1;
    }
  }
}

##
## Construct the game board.
##
proc BuildBoard {} {
    global mankala;

    set mankala(stone-radius) [expr $mankala(width) / 100]

    option add *Canvas.width [expr $mankala(width) / 8];
    option add *Canvas.height [expr $mankala(height) / 2];
    option add *Canvas.background $mankala(board);
    option add *Canvas.takefocus 0;
    option add *Canvas.relief raised;
    option add *Canvas.highlightThickness 0;

    foreach n {1 2 3 4 5 6} {
	grid [canvas .pit-$n] -column $n -row 1 -sticky nsew
	grid [canvas .pit-[expr 13-$n]] -column $n -row 0 -sticky nsew
    }
    grid [canvas .pit-13 -height $mankala(height)] -column 7 -row 0 -rowspan 2 -sticky nsew
    grid [canvas .pit-14 -height $mankala(height)] -column 0 -row 0 -rowspan 2 -sticky nsew
    bind Canvas <Configure> {DrawPit %W %w %h}
}

##
## Draw a stone
##
proc DrawStone {w x y args} {
    global mankala;
    set r $mankala(stone-radius);
    eval "$w create oval [expr $x-$r] [expr $y-$r] [expr $x+$r] [expr $y+$r] $args";
}

##
## Add a stone to this pit.
##
proc AddStone {pit color} {
    global mankala;
    set w .$pit;
    set width [winfo width $w];
    set height [winfo height $w];
    set xy [lindex $mankala(stone-positions) $mankala($pit)];
    set x [expr $width/2 * (1+[lindex $xy 0])];
    set y [expr $height/2 * (1+[lindex $xy 1])];
    DrawStone $w $x $y -fill $color -outline {} -tags stone;
    lappend mankala($pit-stones) $color;
    incr mankala($pit);
}

##
## Empty this pit of stones and return the stones
##
proc EmptyPit {pit} {
    global mankala;
    if {[info exists mankala($pit-stones)]} {
	.$pit delete stone;
	set stones $mankala($pit-stones);
    } else {
	set stones {};
    }
    set mankala($pit) 0;
    set mankala($pit-stones) {};
    return $stones;
}

##
## What is the next pit in sequence?
## Differs depending on who is playing this move.
##
array set mankala {
    n-next-pit-1 pit-2
    n-next-pit-2 pit-3
    n-next-pit-3 pit-4
    n-next-pit-4 pit-5
    n-next-pit-5 pit-6
    n-next-pit-6 pit-7
    n-next-pit-7 pit-8
    n-next-pit-8 pit-9
    n-next-pit-9 pit-10
    n-next-pit-10 pit-11
    n-next-pit-11 pit-12
    n-next-pit-12 pit-14
    n-next-pit-14 pit-1
    s-next-pit-1 pit-2
    s-next-pit-2 pit-3
    s-next-pit-3 pit-4
    s-next-pit-4 pit-5
    s-next-pit-5 pit-6
    s-next-pit-6 pit-13
    s-next-pit-13 pit-7    
    s-next-pit-7 pit-8
    s-next-pit-8 pit-9
    s-next-pit-9 pit-10
    s-next-pit-10 pit-11
    s-next-pit-11 pit-12
    s-next-pit-12 pit-1
}

proc NextPit {pit {step 1}} {
    global mankala;
    if {$step == 1} {
	return $mankala($mankala(turn)-next-$pit);
    } else {
	while {$step > 0} {
	    set pit $mankala($mankala(turn)-next-$pit);
	    incr step -1;
	}
	return $pit;
    }
}
##
## Is this my home pit?
##
set mankala(s-home) pit-13;
set mankala(n-home) pit-14;
for {set i 1} {$i <= 14} {incr i} {
    set mankala(s-home-pit-$i) [expr {"pit-$i" == "$mankala(s-home)"}];
    set mankala(n-home-pit-$i) [expr {"pit-$i" == "$mankala(n-home)"}];
}
proc HomePitP {pit} {
    global mankala;
    return $mankala($mankala(turn)-home-$pit);
}
##
## Which pit is opposite this pit?
##
for {set i 1} {$i <= 12} {incr i} {
    set mankala(opp-pit-$i) pit-[expr 13 - $i];
}
proc OpposePit {pit} {
    global mankala;
    return $mankala(opp-$pit);
}
##
## Is this pit one of my playing pits?
##
set mankala(s-pits) {pit-1 pit-2 pit-3 pit-4 pit-5 pit-6};
set mankala(n-pits) {pit-7 pit-8 pit-9 pit-10 pit-11 pit-12};     
foreach pit $mankala(s-pits) {
    set mankala(s-$pit) 1;
    set mankala(n-$pit) 0;
}
foreach pit $mankala(n-pits) {
    set mankala(s-$pit) 0;
    set mankala(n-$pit) 1;
}
foreach pit "$mankala(n-home) $mankala(s-home)" {
    set mankala(s-$pit) 0;
    set mankala(n-$pit) 0;
}
proc OwnPitP {pit} {
    global mankala;
    return $mankala($mankala(turn)-$pit);
}
##
## Sum the stones in a set of pits
##
proc SumPits {pits} {
    global mankala;
    set sum 0;
    foreach pit $pits {
	incr sum $mankala($pit);
    }
    return $sum;
}
##
## Can this pit be played?
##
proc PlayPitP {pit} {
    global mankala;
    if {$mankala($pit) <= 0} {
	# cannot move no stones
	return 0;
    }
    if {! [OwnPitP $pit]} {
	# cannot move opponents stones
	return 0;
    }
    return 1;
}
##
## Play this pit.
##
proc PlayPit {pit} {
    global mankala;
    # test for legality
    if {! [PlayPitP $pit]} {
	error "pit $pit cannot be played by $mankala(turn) side";
    }
    # flash the pit selected
    FlashPits $pit;
    # move the stones
    foreach stone [EmptyPit $pit] {
	set pit [NextPit $pit];
	AddStone $pit $stone;
	# flash the pit
	FlashPits $pit;
    }
    # test for capture
    if {$mankala($pit) == 1 && [OwnPitP $pit] && $mankala([OpposePit $pit])} {
	# capture opponent s stones
	foreach stone [EmptyPit [OpposePit $pit]] {
	    AddStone $pit $stone;
	}
    }
    # sync the display
    update idletasks
    # test for free turn
    if {[HomePitP $pit]} {
	# take another turn
	return 1;
    } else {
	return 0;
    }
}
##
## Collect all the stones from a list of pits
##
proc CollectStones {pits} {
    global mankala;
    set stones {};
    foreach pit $pits {
	foreach stone [EmptyPit $pit] {
	    lappend stones $stone;
	}
    }
    return $stones;
}
##
## Visual end of game display.
##
proc DistributeStones {stones pits home} {
    global mankala;
    foreach pit $pits {
	for {set i 0} {$i < $mankala(stones)} {incr i} {
	    if {$stones != {}} {
		AddStone $pit [lindex $stones 0];
		set stones [lrange $stones 1 end];
	    }
	}
    }
    foreach stone $stones {
	AddStone $home $stone;
    }
}

##
## End of game, count stones.
##
proc GameOver {} {
    global mankala;
    set n [CollectStones "$mankala(n-pits) $mankala(n-home)"];
    set s [CollectStones "$mankala(s-pits) $mankala(s-home)"];
    DistributeStones $n $mankala(n-pits) $mankala(n-home);
    DistributeStones $s $mankala(s-pits) $mankala(s-home);
    if {$mankala(tournement)} {
	after 5000 NewGame;
    }
}

##
## Exchange of play
##
proc NextTurn {freeturn} {
    global mankala;
    if {[SumPits $mankala(n-pits)] == 0 || [SumPits $mankala(s-pits)] == 0} {
	GameOver;
    } elseif {$freeturn} {
	after 1 "TakeTurn $mankala(turn)";
    } elseif {$mankala(turn) == {n}} {
	after 1 "TakeTurn s";
    } else {
	after 1 "TakeTurn n";
    }
}

##
## Play pit event, maybe
##
proc PlayPitEvent {pit} {
    if {[PlayPitP $pit]} {
	NextTurn [PlayPit $pit];
    } else {
	NextTurn 1;
    }
}

##
## Various non-strategies
##
proc FindRandom {} {
    global mankala;
    set trials $mankala($mankala(turn)-pits);
    for {set pit {}} {$pit == {}} {} {
	set i [random [llength $trials]];
	set try [lindex $trials $i];
	set trials [lreplace $trials $i $i];
	if {$mankala($try)} {
	    return $try;
	}
    }
}
proc FindFirst {} {
    global mankala;
    foreach try $mankala($mankala(turn)-pits) {
	if {[PlayPitP $try]} {
	    return $try;
	}
    }
}
proc FindLast {} {
    global mankala;
    foreach try $mankala($mankala(turn)-pits) {
	if {[PlayPitP $try]} {
	    set pit $try;
	}
    }
    return $pit;
}
proc FindFirstLargest {} {
    global mankala;
    set pit [lindex $mankala($mankala(turn)-pits) 0];
    foreach try [lrange $mankala($mankala(turn)-pits) 1 end] {
	if {$mankala($try) > $mankala($pit)} {
	    set pit $try;
	}
    }
    return $pit;
}
proc FindLastLargest {} {
    global mankala;
    set pit [lindex $mankala($mankala(turn)-pits) 0];
    foreach try [lrange $mankala($mankala(turn)-pits) 1 end] {
	if {$mankala($try) >= $mankala($pit)} {
	    set pit $try;
	}
    }
    return $pit;
}
proc FindFirstSmallest {} {
    global mankala;
    set pit [lindex $mankala($mankala(turn)-pits) 0];
    foreach try [lrange $mankala($mankala(turn)-pits) 1 end] {
	if {$mankala($pit) == 0} {
	    set pit $try;
	} elseif {$mankala($try) > 0 && $mankala($try) < $mankala($pit)} {
	    set pit $try;
	}
    }
    return $pit;
}
proc FindLastSmallest {} {
    global mankala;
    set pit [lindex $mankala($mankala(turn)-pits) 0];
    foreach try [lrange $mankala($mankala(turn)-pits) 1 end] {
	if {$mankala($pit) == 0} {
	    set pit $try;
	} elseif {$mankala($try) > 0 && $mankala($try) <= $mankala($pit)} {
	    set pit $try;
	}
    }
    return $pit;
}
proc FindGreedy {AndThen} {
    global mankala;
    # look for a free turn
    set n 6;
    set pit {};
    foreach try $mankala($mankala(turn)-pits) {
	if {$mankala($try) == $n} {
	    set pit $try;
	}
	incr n -1;
    }
    if {$pit != {}} {
	return $pit;
    }
    # look for a capture
    set catch 0;
    foreach try $mankala($mankala(turn)-pits) {
	if {$mankala($try)} {
	    set dst [NextPit $try $mankala($try)];
	    if {[OwnPitP $dst] && $mankala($dst) == 0 && $mankala([OpposePit $dst]) > $catch} {
		set pit $try;
		set catch $mankala([OpposePit $dst]);
	    }
	}
    }
    if {$pit != {}} {
	return $pit;
    }
    # do something
    return [$AndThen];
}

##
## Make a move one way or another.
##
proc TakeTurn {who} {
    global mankala;
    set mankala(turn) $who;
    after 250;
    FlashPits "$mankala($who-home) $mankala($who-pits)" 1;
    if {"$mankala($who-strategy)" == {player}} {
	foreach pit $mankala($mankala(turn)-pits) {
	    .$pit bind stone <Button-1> "PlayPitEvent $pit";
	}
    } else {
	set pit [eval $mankala($who-strategy)];
	NextTurn [PlayPit $pit];
    }
}

##
##
##
proc NewGame {} {
    global mankala;
    foreach w [info commands .pit-*] {
	$w delete stone;
    }
    for {set i 1} {$i <= 14} {incr i} {
	set mankala(pit-$i) 0;
	set mankala(pit-$i-stones) {};
    }
    set colors $mankala($mankala(stone-colors)-stone-colors)
    for {set i 1} {$i <= 12} {incr i} {
	for {set j 0} {$j < $mankala(stones)} {incr j} {
	    AddStone pit-$i [lindex $colors [expr (($i - 1) * $mankala(stones) + $j)]];
	}
    }
    TakeTurn $mankala(turn);
}

##
## Construct the user interface
##
BuildBoard

##
## Start a new game
##
NewGame;
