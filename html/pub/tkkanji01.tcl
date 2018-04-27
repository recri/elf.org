#!/usr/local/bin/wish
# This is a tclshar created Fri Aug 20 09:27:13 MDT 1999.
# Source this file into wish or tclsh to extract the directories
# and files from this archive.
# Files included in this archive:
#  TkKanji TkKanji/example.cfg TkKanji/tkkanji.tcl TkKanji/tkj
#  TkKanji/tkj/misc.tcl TkKanji/tkj/progress.tcl TkKanji/tkj/tkj-dict.tcl
#  TkKanji/tkj/tkj-heisig.tcl TkKanji/tkj/tkj-config.tcl TkKanji/tkj/Makefile
#  TkKanji/tkj/random.tcl TkKanji/tkj/tclIndex TkKanji/tkj/tkj-util.tcl
#  TkKanji/tkj/tkj-default.tcl TkKanji/tkj/tkj-browse.tcl
#  TkKanji/tkj/tkj-copyright.tcl TkKanji/tkj/tkj-tration.tcl
#  TkKanji/tkj/tkj-self-test.tcl TkKanji/tkj/tkj-multi-choice.tcl
#

    if { ! [catch {winfo exists .}]} {
	pack [frame .f] -side top -fill both -expand true
	pack [text .t -yscrollcommand {.y set}] -in .f -side left -fill both -expand true
	pack [scrollbar .y -orient vertical -command {.t yview}] -in .f -side left -fill y
	pack [button .b -text Done -command {destroy .} -state disabled] -side top
	proc msg {str} { .t insert end $str\n; update }
    } else {
	proc msg {str} { puts $str }
    }

set restore [file join TkKanji]
msg "creating directory $restore"
if {[catch {file mkdir $restore} error]} { msg "failed to create directory $restore" } 
set restore [file join TkKanji example.cfg]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp #
puts $fp {# Don't rewrite this file, the configuration}
puts $fp {# application will allow you to write your own}
puts $fp {# after selecting values appropriate to your}
puts $fp {# system.}
puts $fp #
puts $fp array\ set\ ::config::config\ \{
puts $fp {  {kanjidic-load} {1}}
puts $fp {  {font-24} {mincho}}
puts $fp {  {kanjidic.doc-path} {/home/elf1/packages/archives/edict/kanjidic.doc}}
puts $fp {  {subset} {All}}
puts $fp {  {kanjidic-path} {/home/rec/Projects/Kanji/dict/kanjidic}}
puts $fp {  {font-48} {fixed}}
puts $fp {  {font-32} {fixed}}
puts $fp {  {kanjd212-load} {0}}
puts $fp {  {kanjd212.doc-path} {/home/elf1/packages/archives/edict/kanjd212.doc}}
puts $fp {  {font-16} {helvetica}}
puts $fp {  {startup} {tkj-chooser}}
puts $fp {  {kanjd212-path} {/home/rec/Projects/Kanji/dict/kanjd212}}
puts $fp \}
puts $fp #
puts $fp {# However, this file does get sourced so any}
puts $fp {# additional configuration information could}
puts $fp {# be added in, such as the following which}
puts $fp {# overrides the tk font selection where it works.}
puts $fp {# Being more specific on XWindows saves a bit}
puts $fp {# of time on startup.  Should rewrite the font}
puts $fp {# selector to make this easier.}
puts $fp #
puts $fp switch\ \$tcl_platform(platform)\ \{
puts $fp \ \ \ \ unix\ \{
puts $fp \tarray\ set\ tkj-override-font\ \{
puts $fp {	    48 -watanabe-fixed-medium-r-normal--48-450-75-75-c-480-jisx0208.1983-0}
puts $fp {	    32 -watanabe-fixed-medium-r-normal--32-300-75-75-c-320-jisx0208.1983-0}
puts $fp {	    24 -jis-fixed-medium-r-normal--24-230-75-75-c-240-jisx0208.1983-0}
puts $fp {	    16 -jis-fixed-medium-r-normal--16-150-75-75-c-160-jisx0208.1983-0}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    windows -}
puts $fp \ \ \ \ macintosh\ \{
puts $fp \ \ \ \ \}
puts $fp \}
close $fp
set restore [file join TkKanji tkkanji.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp #!/usr/local/bin/wish
puts $fp {}
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp #
puts $fp {# tkkanji.tcl depends on the existence of three additional packages}
puts $fp #
puts $fp {#	tcl/tk - the Tool Command Language and UI Tool Kit,}
puts $fp {#		freely available from http://www.scriptics.com}
puts $fp {#		for windows, macintosh, and unix.}
puts $fp {#		tkkanji was written for version 8.1.1, but any}
puts $fp {#		more recent should be okay.}
puts $fp #
puts $fp {#	japanese fonts - appropriate to your system,}
puts $fp {#		freely available from}
puts $fp {#		ftp://ftp.cc.monash.edu.au/pub/nihongo/00INDEX.html}
puts $fp #
puts $fp {#	kanjidic - a dictionary of information about Kanji,}
puts $fp {#		freely available from}
puts $fp {#		ftp://ftp.cc.monash.edu.au/pub/nihongo/00INDEX.html}
puts $fp #
puts $fp {# Although everything is freely available, there may be restrictions}
puts $fp {# on use and/or redistribution attached to these packages or to parts}
puts $fp {# of them.  Read the label.}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp ########################################################################
puts $fp #
puts $fp {# find our library first}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp if\ \{\ !\ \[info\ exists\ env(TKJ_LIB)\]\}\ \{
puts $fp {    set env(TKJ_LIB) [file join [file dirname [info script]] tkj]}
puts $fp \}
puts $fp {set auto_path [linsert $auto_path 0 $env(TKJ_LIB)]}
puts $fp {}
puts $fp ########################################################################
puts $fp #
puts $fp {# main program}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp proc\ tkj-splash\ \{w\}\ \{
puts $fp {    tkj-empty $w}
puts $fp {    wm title $w {Tk Kanji}}
puts $fp {    grid [label $w.l0 -text "Tk \u6f22\u5b57" -font {fixed 48} -border 10] -row 0}
puts $fp {    grid [label $w.l1 -text {Tk Kanji Version 0.1}] -row 1}
puts $fp {    grid [label $w.l2 -text {Copyright (c) 1999, Roger E Critchlow Jr}] -row 2}
puts $fp {    grid [label $w.l3 -text {Santa Fe, New Mexico, USA}] -row 3}
puts $fp {    grid [label $w.l4 -text {rec@elf.org -- http://elf.org}] -row 4}
puts $fp {    grid [button $w.l5 -text {Tk Kanji comes with ABSOLUTELY NO WARRANTY} -command tkj-view-warranty] -row 5}
puts $fp \ \ \ \ grid\ \[button\ \$w.l6\ \\
puts $fp \t\ \ \ \ \ \ -text\ \"This\ is\ free\ software,\ and\ you\ are\ welcome\\nto\ redistribute\ it\ under\ certain\ conditions\"\ \\
puts $fp {	      -command tkj-view-terms] -row 6}
puts $fp {    grid [label $w.l7 -textvar tkkanji(status)] -row 7}
puts $fp \}
puts $fp {}
puts $fp {wm withdraw .}
puts $fp {toplevel .w}
puts $fp bind\ .w\ <Destroy>\ \{
puts $fp \ \ \ \ if\ \{\[string\ compare\ %W\ .w\]\ ==\ 0\}\ \{
puts $fp {	destroy .}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp {}
puts $fp {srandom [clock clicks]}
puts $fp {tkj-splash .w}
puts $fp {tkj-configure .w startup}
puts $fp {}
puts $fp {set nfailed 0}
puts $fp while\ \{\[catch\ \{
puts $fp \ \ \ \ if\ \{\[tkj-cget\ kanjidic-load\]\}\ \{
puts $fp {	tkj-load-dictionary [tkj-cget kanjidic-path] J0}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ if\ \{\[tkj-cget\ kanjd212-load\]\}\ \{
puts $fp {	tkj-load-dictionary [tkj-cget kanjd212-path] J1}
puts $fp \ \ \ \ \}
puts $fp {    [tkj-cget startup] .w}
puts $fp \}\ error\]\}\ \{
puts $fp {    incr nfailed}
puts $fp \ \ \ \ while\ \{1\}\ \{
puts $fp \tswitch\ \[tk_dialog\ .dialog\ \{Tk\ Kanji\ Startup\ Error\}\ \\
puts $fp \t\t\ \ \ \ \"Tk\ Kanji\ startup\ failed\ with\ the\ error\ message:\\n\$error\"\ \\
puts $fp \t\t\ \ \ \ \{\}\ 0\ \{Reconfigure\}\ \{Quit\}\ \{Show\ Trace\}\]\ \{
puts $fp \t\t\t0\ \{
puts $fp {			    tkj-configure .w rescue}
puts $fp {			    break}
puts $fp \t\t\t\}
puts $fp \t\t\t1\ \{
puts $fp {			    tkj-quit}
puts $fp \t\t\t\}
puts $fp \t\t\t2\ \{
puts $fp {			    tkj-view-trace {Tk Kanji Startup Error Trace} $error}
puts $fp {			    continue}
puts $fp \t\t\t\}
puts $fp \t\t\ \ \ \ \}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp {    }
close $fp
set restore [file join TkKanji tkj]
msg "creating directory $restore"
if {[catch {file mkdir $restore} error]} { msg "failed to create directory $restore" } 
set restore [file join TkKanji tkj misc.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp #
puts $fp {# toplevel window name creator}
puts $fp #
puts $fp {set topleveln 0}
puts $fp proc\ toplevel-window-name\ \{\}\ \{
puts $fp {    global topleveln}
puts $fp {    return .w[incr topleveln]}
puts $fp \}
puts $fp #
puts $fp {# textview - put a text widget and associated scrollbars}
puts $fp {# into an existing window.  The text widget will be $w.t}
puts $fp #
puts $fp proc\ textview\ \{w\ args\}\ \{
puts $fp {    grid [eval text $w.t $args] -row 0 -col 0 -sticky nsew}
puts $fp {    $w.t configure -xscrollcommand [list $w.x set]}
puts $fp {    $w.t configure -yscrollcommand [list $w.y set]}
puts $fp {    grid [scrollbar $w.y -orient vertical] -row 0 -col 1 -sticky ns}
puts $fp {    $w.y configure -command [list $w.t yview]}
puts $fp {    grid [scrollbar $w.x -orient horizontal] -row 1 -col 0 -sticky ew}
puts $fp {    $w.x configure -command [list $w.t xview]}
puts $fp {    grid columnconfigure $w 0 -weight 1}
puts $fp {    grid columnconfigure $w 1 -weight 0}
puts $fp {    grid rowconfigure $w 0 -weight 1}
puts $fp {    grid rowconfigure $w 1 -weight 0}
puts $fp {    return $w}
puts $fp \}
puts $fp #
puts $fp {# readfile - open a file with specified encoding,}
puts $fp {# read it into a string, close the file, and}
puts $fp {# return the string}
puts $fp #
puts $fp proc\ readfile\ \{file\ \{encoding\ \{\}\}\}\ \{
puts $fp {    set fp [open $file r]}
puts $fp \ \ \ \ if\ \{\[string\ length\ \$encoding\]\}\ \{
puts $fp {	fconfigure $fp -encoding $encoding}
puts $fp \ \ \ \ \}
puts $fp {    set contents [read $fp]}
puts $fp {    close $fp}
puts $fp {    return $contents}
puts $fp \}
puts $fp {#    }
puts $fp {# browse the contents of a file}
puts $fp {# usually a file in edict or kanjidic format}
puts $fp #
puts $fp proc\ browsefile\ \{title\ file\ \{font\ \{\}\}\ \{margin\ \{\}\}\ \{encoding\ euc-jp\}\ \{margin\ 0\}\}\ \{
puts $fp {    browsedata $title [readfile $file $encoding] $font $margin}
puts $fp \}
puts $fp {#    }
puts $fp {# browse some immediate data}
puts $fp #
puts $fp proc\ browsedata\ \{title\ data\ \{font\ \{\}\}\ \{margin\ 0\}\}\ \{
puts $fp {    set w [toplevel-window-name]}
puts $fp {    toplevel $w}
puts $fp {    wm title $w $title}
puts $fp {    textview $w -wrap none}
puts $fp \ \ \ \ if\ \{\[string\ length\ \$font\]\ >\ 0\}\ \{
puts $fp {	$w.t configure -font $font}
puts $fp \ \ \ \ \}
puts $fp {    $w.t insert end $data}
puts $fp \ \ \ \ if\ \{\$margin\}\ \{
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp #
puts $fp {# shuffle a list}
puts $fp #
puts $fp proc\ shuffle\ \{list\}\ \{
puts $fp {    set n 0}
puts $fp \ \ \ \ foreach\ x\ \$list\ \{
puts $fp {	set t($n) $x}
puts $fp {	incr n}
puts $fp \ \ \ \ \}
puts $fp {    set list {}}
puts $fp \ \ \ \ for\ \{set\ i\ 0\}\ \{\$i\ <\ \$n\}\ \{incr\ i\}\ \{
puts $fp {	set j [expr $i+[random]%($n-$i)]}
puts $fp {	lappend list $t($j)}
puts $fp {	set t($j) $t($i)}
puts $fp \ \ \ \ \}
puts $fp {    return $list}
puts $fp \}
puts $fp #
puts $fp {# pick a card, any card}
puts $fp #
puts $fp proc\ choose-one\ \{list\}\ \{
puts $fp {    return [lindex $list [expr {[random]%[llength $list]}]]}
puts $fp \}
close $fp
set restore [file join TkKanji tkj progress.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp #
puts $fp {# progress - maintain a progress bar}
puts $fp #
puts $fp proc\ progress\ \{op\ \{arg\ \{\}\}\}\ \{
puts $fp {    upvar \#0 .progress data}
puts $fp \ \ \ \ if\ \{!\ \[winfo\ exists\ .progress\]\}\ \{
puts $fp {	toplevel .progress}
puts $fp {	pack [label .progress.t -textvar .progress(title)]}
puts $fp {	image create photo pbar -width 200 -height 20}
puts $fp {	pack [label .progress.l -image pbar] -side top -fill x}
puts $fp {	set data(percent) -1}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ switch\ \$op\ \{
puts $fp \ttitle\ \{
puts $fp {	    wm deiconify .progress}
puts $fp {	    set data(title) $arg}
puts $fp {	    update}
puts $fp \t\}
puts $fp \tpercent\ \{
puts $fp {	    set percent [format %6.1f $arg]}
puts $fp \t\ \ \ \ if\ \{\$percent\ !=\ \$data(percent)\}\ \{
puts $fp {		pbar blank}
puts $fp {		pbar put {{blue}} -to 0 0 [expr int(2*$percent)] 20}
puts $fp {		set data(percent) $percent}
puts $fp {		update}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tdone\ \{
puts $fp {	    pbar blank}
puts $fp {	    set data(percent) -1}
puts $fp {	    set data(title) {}}
puts $fp {	    update}
puts $fp \t\}
puts $fp \thide\ \{
puts $fp {	    wm withdraw .progress}
puts $fp {	    update}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp {}
close $fp
set restore [file join TkKanji tkj tkj-dict.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# tk kanji configuration}
puts $fp #
puts $fp {# Copyright 1999 by Roger E. Critchlow Jr, Santa Fe, New Mexico, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp ########################################################################
puts $fp #
puts $fp {# kanjidic parsing -}
puts $fp {#  initially just split at new line}
puts $fp {#  and index by [lindex $line 0]}
puts $fp {#  which will give a unicode index}
puts $fp {#  Then split lines at space and classify}
puts $fp {#  results by the first character.}
puts $fp {#  actually, second word is hexadecimal JIS,}
puts $fp {#  either jisx-0208 (3021 .. 7426)}
puts $fp {#  or jisx-0212 (3021 .. 6d63)}
puts $fp {#  depending on the file read,}
puts $fp #
puts $fp {#  then classify by leading character}
puts $fp {# }
puts $fp {# each record has the identifying character(s), a name,}
puts $fp {# a category and an explanatory name.}
puts $fp {# The categories are}
puts $fp {#	class - maps kanji to equivalence classes}
puts $fp {#	index - maps kanji, or a subset, to unique identifiers}
puts $fp {#	trans - translates kanji to english, pinyin, ...}
puts $fp {#	refer - references another kanji record}
puts $fp #
puts $fp array\ set\ kanjifields\ \{
puts $fp {    B     { class {Radical} {Bushu radical number} }}
puts $fp {    C     { class {Radical(2)} {Historical or classical radical number} }}
puts $fp {    F     { index {Frequency} {Frequency of use ranking} }}
puts $fp {    G     { class {Jouyou} {Jouyou grade-level} }}
puts $fp {    H     { index {Halpern index} {Halpern's New Japanese-English Character Dictionary index number} }}
puts $fp {    N     { index {Nelson index} {Nelson's Modern Reader's Japanese-English Character Dictionary index number} }}
puts $fp {    DR    { index {De Roo code} {Codes developed by De Roo} }}
puts $fp {    E     { index {Henshall index} {Henshall, A Guide To Remembering Japanese Characters index number} }}
puts $fp {    IN    { index {S&H index(2)} {Spahn and Hadamitzky, Kanji and Kana index number} }}
puts $fp {    I     { class {S&H index} {Spahn and Hadamitzky, The Kanji Dictionary index code} }}
puts $fp {    J0    { index {JIS0} {JISX-0208 code point} }}
puts $fp {    J1    { index {JIS1} {JISX-0212 code point} }}
puts $fp {    K     { index {GKD index} {Gakken Kanji Dictionary index number} }}
puts $fp {    L     { index {Heisig index} {Heisig, Remembering The Kanji index number} }}
puts $fp {    MN    { index {Morohashi index} {Morohashi index number} }}
puts $fp {    MP    { index {Morohashi page} {Morohashi volume.page numbers} }}
puts $fp {    O     { index {ONeill index} {O'Neill, Japanese Names index number} }}
puts $fp {    P     { class {SKIP} {SKIP pattern code} }}
puts $fp {    Q     { class {Four Corner} {Four Corner code} }}
puts $fp {    S     { class {Strokes} {Stroke count} }}
puts $fp {    U     { index {Unicode} {Unicode code point} }}
puts $fp {    V     { index {Nelson index(2)} {New Nelson Japanese-English Character Dictionary index number} }}
puts $fp {    W     { trans {Korean} {Romanized Korean reading(s)} }}
puts $fp {    Y     { trans {Pinyin} {Pinyin reading(s)} }}
puts $fp {    X     { refer {Crossref} {Cross reference code} }}
puts $fp {    Z     { refer {Misclass} {Mis-classification code} }}
puts $fp \}
puts $fp #
puts $fp {# these are constructed fields, they are untagged or shift tagged}
puts $fp {# in the input.  When we split the record into property lists, we}
puts $fp {# insert these tags to identify the untagged fields.}
puts $fp #
puts $fp array\ set\ kanjifields\ \{
puts $fp {    ON    { trans {On} {On readings in katakana} }}
puts $fp {    ONT1  { trans {On name} {On name forms in katakana} }}
puts $fp {    ONT2  { trans {On radical} {On radical name if not earlier} }}
puts $fp {    KUN   { trans {Kun} {Kun readings in hiragana} }}
puts $fp {    KUNT1 { trans {Kun name} {Kun name forms in katakana} }}
puts $fp {    KUNT2 { trans {Kun radical} {Kun radical name if not earlier} }}
puts $fp {    ENG   { trans {English} {English translation} }}
puts $fp \}
puts $fp #
puts $fp {# get the field type}
puts $fp #
puts $fp proc\ tkj-get-field-type\ \{f\}\ \{
puts $fp {    global kanjifields}
puts $fp {    return [lindex $kanjifields($f) 0]}
puts $fp \}
puts $fp #
puts $fp {# get the field label}
puts $fp #
puts $fp proc\ tkj-get-field-label\ \{f\}\ \{
puts $fp {    global kanjifields}
puts $fp {    return [lindex $kanjifields($f) 1]}
puts $fp \}
puts $fp #
puts $fp {# get the field description}
puts $fp #
puts $fp proc\ tkj-get-field-description\ \{f\}\ \{
puts $fp {    global kanjifields}
puts $fp {    return [lindex $kanjifields($f) 2]}
puts $fp \}
puts $fp #
puts $fp {# translate some field values into more useful strings}
puts $fp #
puts $fp array\ set\ kanjifieldvalues\ \{
puts $fp {    G  {All Jouyou}}
puts $fp {    G1 Jouyou-1}
puts $fp {    G2 Jouyou-2}
puts $fp {    G3 Jouyou-3}
puts $fp {    G4 Jouyou-4}
puts $fp {    G5 Jouyou-5}
puts $fp {    G6 Jouyou-6}
puts $fp {    G8 Jouyou}
puts $fp {    G9 Jinmeiyou}
puts $fp \}
puts $fp #
puts $fp {# return a useful string for a field value}
puts $fp {#    }
puts $fp proc\ tkj-get-field-value-label\ \{f\ v\}\ \{
puts $fp {    global kanjifieldvalues}
puts $fp \ \ \ \ if\ \{\[info\ exists\ kanjifieldvalues(\$f\$v)\]\}\ \{
puts $fp {	return $kanjifieldvalues($f$v)}
puts $fp \ \ \ \ \}
puts $fp {    return $v}
puts $fp \}
puts $fp #
puts $fp {# load a kanji dictionary}
puts $fp {#   index each record under the unicode for the kanji}
puts $fp {#   scan the records to}
puts $fp {#     1) accumulate the members of each index set}
puts $fp {#     2) accumulate the values and members of each class set}
puts $fp {#     3) rewrite the JISX values to identify encoding}
puts $fp #
puts $fp proc\ tkj-load-dictionary\ \{file\ jiskey\}\ \{
puts $fp {    global kanji}
puts $fp {    global kanjiclass}
puts $fp {}
puts $fp {    set n 1}
puts $fp {    tkj-status "loading [file tail $file]"}
puts $fp {}
puts $fp {    set fp [open $file]}
puts $fp {    fconfigure $fp -encoding euc-jp}
puts $fp {    gets $fp line;			# skip header line}
puts $fp {}
puts $fp \ \ \ \ while\ \{\[gets\ \$fp\ line\]\ >=\ 0\}\ \{
puts $fp {	# post status}
puts $fp \tif\ \{\[incr\ n\]\ %\ 100\ ==\ 0\}\ \{
puts $fp {	    tkj-status "loading [file tail $file] $n lines read"}
puts $fp \t\}
puts $fp {	# use unicode to define key, because Tcl won't decode EUC-3}
puts $fp {	set k [subst \\u[string range [lindex $line 2] 1 end]]}
puts $fp {	# minimal rebuild of input record}
puts $fp {	set kanji($k) [concat [list $jiskey[lindex $line 1]] [lrange $line 2 end]];}
puts $fp {	# remember the input list}
puts $fp {	lappend kanjiclass(all) $k}
puts $fp {	# build up class and index membership lists}
puts $fp \tforeach\ i\ \$kanji(\$k)\ \{
puts $fp \t\ \ \ \ switch\ -glob\ --\ \$i\ \{
puts $fp {		B*  { lappend kanjiclass(B)  $k; lappend kanjiclass($i) $k; continue }}
puts $fp {		C*  { lappend kanjiclass(C)  $k; lappend kanjiclass($i) $k; continue }}
puts $fp {		DR* { lappend kanjiclass(DR) $k; continue }}
puts $fp {		E*  { lappend kanjiclass(E)  $k; continue }}
puts $fp {		F*  { lappend kanjiclass(F)  $k; continue }}
puts $fp {		G*  { lappend kanjiclass(G)  $k; lappend kanjiclass($i) $k; continue }}
puts $fp {		H*  { lappend kanjiclass(H)  $k; continue }}
puts $fp {		IN* { lappend kanjiclass(IN) $k; continue }}
puts $fp {		I*  { lappend kanjiclass(I)  $k; lappend kanjiclass([lindex [split $i .] 0]) $k; continue }}
puts $fp {		J0* { lappend kanjiclass(J0) $k; continue }}
puts $fp {		J1* { lappend kanjiclass(J1) $k; continue }}
puts $fp {		K*  { lappend kanjiclass(K)  $k; continue }}
puts $fp {		L*  { lappend kanjiclass(L)  $k; continue }}
puts $fp {		MN* { lappend kanjiclass(MN) $k; continue }}
puts $fp {		MP* { lappend kanjiclass(MP) $k; continue }}
puts $fp {		N*  { lappend kanjiclass(N)  $k; continue }}
puts $fp {		O*  { lappend kanjiclass(O)  $k; continue }}
puts $fp {		P*  { lappend kanjiclass(P)  $k; lappend kanjiclass($i) $k; continue }}
puts $fp {		Q*  { lappend kanjiclass(Q)  $k; lappend kanjiclass([lindex [split $i .] 0]) $k; continue }}
puts $fp {		S*  { lappend kanjiclass(S)  $k; lappend kanjiclass($i) $k; continue }}
puts $fp {		U*  { lappend kanjiclass(U)  $k; continue }}
puts $fp {		V*  { lappend kanjiclass(V)  $k; continue }}
puts $fp {		W*  { lappend kanjiclass(W)  $k; continue }}
puts $fp {		Y*  { lappend kanjiclass(Y)  $k; continue }}
puts $fp {		X*  { lappend kanjiclass(X)  $k; continue }}
puts $fp {		Z*  { lappend kanjiclass(Z)  $k; continue }}
puts $fp {		*   { break }}
puts $fp \t\ \ \ \ \}
puts $fp {	    break}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    close $fp}
puts $fp {    tkj-status ""}
puts $fp \}
puts $fp #
puts $fp {# get the records of a kanji split into a property list of}
puts $fp {# names and values}
puts $fp #
puts $fp proc\ get-record\ \{k\}\ \{
puts $fp {    global kanji}
puts $fp {    global kanjisplit}
puts $fp \ \ \ \ if\ \{\ !\ \[info\ exists\ kanjisplit(\$k)\]\}\ \{
puts $fp {	set info 1}
puts $fp {	set spec {}}
puts $fp {	set vals {}}
puts $fp \tforeach\ i\ \$kanji(\$k)\ \{
puts $fp \t\ \ \ \ if\ \{\$info\}\ \{\ 
puts $fp \t\tswitch\ -glob\ --\ \$i\ \{
puts $fp {		    DR* -}
puts $fp {		    IN* -}
puts $fp {		    J0* -}
puts $fp {		    J1* -}
puts $fp {		    MN* -}
puts $fp \t\t\ \ \ \ MP*\ \{
puts $fp {			lappend vals [string range $i 0 1] [string range $i 2 end]}
puts $fp {			continue}
puts $fp \t\t\ \ \ \ \}
puts $fp {		    B* -}
puts $fp {		    C* -}
puts $fp {		    E* -}
puts $fp {		    F* -}
puts $fp {		    G* -}
puts $fp {		    H* -}
puts $fp {		    I* -}
puts $fp {		    K* -}
puts $fp {		    L* -}
puts $fp {		    N* -}
puts $fp {		    O* -}
puts $fp {		    P* -}
puts $fp {		    Q* -}
puts $fp {		    S* -}
puts $fp {		    U* -}
puts $fp {		    V* -}
puts $fp {		    W* -}
puts $fp {		    Y* -}
puts $fp {		    X* -}
puts $fp \t\t\ \ \ \ Z*\ \ \{
puts $fp {			lappend vals [string range $i 0 0] [string range $i 1 end]}
puts $fp {			continue}
puts $fp \t\t\ \ \ \ \}
puts $fp \t\t\}
puts $fp {		set info 0}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ switch\ -regexp\ --\ \$i\ \{
puts $fp \t\t\{^-?\[\\u3040-\\u309f\]+(\\.\[\\u3040-\\u309f\]+)?-?\$\}\ \{
puts $fp {		    # Hirigana}
puts $fp {		    lappend vals KUN$spec $i}
puts $fp {		    continue}
puts $fp \t\t\}
puts $fp \t\t\{^-?\[\\u30a0-\\u30ff\]+(\\.\[\\u30a0-\\u30ff\])?-?\$\}\ \{
puts $fp {		    # Katakana}
puts $fp {		    lappend vals ON$spec $i}
puts $fp {		    continue}
puts $fp \t\t\}
puts $fp {		^T1$ -}
puts $fp \t\t^T2\$\ \{
puts $fp {		    set spec $i}
puts $fp {		    continue}
puts $fp \t\t\}
puts $fp \t\tdefault\ \{
puts $fp {		    # English}
puts $fp {		    lappend vals ENG $i}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp {	set kanji($k) $vals}
puts $fp {	set kanjisplit($k) {}}
puts $fp \ \ \ \ \}
puts $fp {    return $kanji($k)}
puts $fp \}
puts $fp #
puts $fp {# get a field(s) of a record matching a field key}
puts $fp {# return a list of results}
puts $fp #
puts $fp proc\ tkj-get-field\ \{k\ f\}\ \{
puts $fp {    set vals {}}
puts $fp \ \ \ \ foreach\ \{name\ value\}\ \[get-record\ \$k\]\ \{
puts $fp \tif\ \{\[string\ compare\ \$name\ \$f\]\ ==\ 0\}\ \{
puts $fp {	    lappend vals $value}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    return $vals}
puts $fp \}
puts $fp #
puts $fp {# get the set indexed by key $f}
puts $fp {# sorted by the index value}
puts $fp #
puts $fp proc\ tkj-get-index\ \{f\}\ \{
puts $fp {    global kanjiclass}
puts $fp {    global kanjiclasssort}
puts $fp \ \ \ \ if\ \{\ !\ \[info\ exists\ kanjiclasssort(\$f)\]\ &&\ \[string\ compare\ \$f\ all\]\ !=\ 0\}\ \{
puts $fp \tforeach\ k\ \$kanjiclass(\$f)\ \{
puts $fp {	    lappend invert([lindex [tkj-get-field $k $f] 0]) $k}
puts $fp \t\}
puts $fp {	set kanjiclass($f) {}}
puts $fp \tforeach\ v\ \[lsort\ -integer\ \[array\ names\ invert\]\]\ \{
puts $fp \t\ \ \ \ foreach\ k\ \$invert(\$v)\ \{
puts $fp {		lappend kanjiclass($f) $k}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp {	set kanjiclasssort($f) {}}
puts $fp \ \ \ \ \}
puts $fp {    return $kanjiclass($f)}
puts $fp \}
puts $fp #
puts $fp {# get the class members of a class}
puts $fp #
puts $fp proc\ tkj-get-class\ \{c\}\ \{
puts $fp {    global kanjiclass}
puts $fp {    set kanjiclass($c)}
puts $fp \}
puts $fp #
puts $fp {# get the number of members of a class}
puts $fp #
puts $fp proc\ tkj-class-size\ \{c\}\ \{
puts $fp {    global kanjiclass}
puts $fp {    llength $kanjiclass($c)}
puts $fp \}
puts $fp #
puts $fp {# get the names of classes matching a pattern}
puts $fp #
puts $fp proc\ tkj-class-names\ \{p\}\ \{
puts $fp {    global kanjiclass}
puts $fp {    array names kanjiclass $p}
puts $fp \}
puts $fp #
puts $fp #
puts $fp #
puts $fp proc\ tkj-class-exists\ \{c\}\ \{
puts $fp {    global kanjiclass}
puts $fp {    info exists kanjiclass($c)}
puts $fp \}
puts $fp {}
close $fp
set restore [file join TkKanji tkj tkj-heisig.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# tk kanji configuration}
puts $fp #
puts $fp {# Copyright 1999 by Roger E. Critchlow Jr, Santa Fe, New Mexico, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp ########################################################################
puts $fp #
puts $fp {# data for studying Heisig's Remembering the Kanji, I}
puts $fp {# made especially convenient because the first english}
puts $fp {# meaning in kanjidic appears to be the Heisig keyword.}
puts $fp #
puts $fp ########################################################################
puts $fp {namespace eval ::heisig:: {}}
puts $fp {}
puts $fp #
puts $fp {# the last character covered in each lesson}
puts $fp {# using Heisig's ordering of the kanji}
puts $fp #
puts $fp set\ ::heisig::lessons\ \{
puts $fp {       0}
puts $fp {      15   34   52   70   94}
puts $fp {     104  126  172  194  234}
puts $fp {     249  276  299  323  352}
puts $fp {     369  395  475  508  514}
puts $fp {     577  636  766  795  891}
puts $fp {     950 1026 1044 1085 1124}
puts $fp {    1183 1219 1247 1293 1332}
puts $fp {    1394 1426 1483 1530 1586}
puts $fp {    1615 1647 1681 1709 1756}
puts $fp {    1775 1805 1827 1852 1879}
puts $fp {    1903 1926 1977 2005 2025}
puts $fp {    2042}
puts $fp \}
puts $fp {}
puts $fp #
puts $fp {# build a menu for selecting a subset of}
puts $fp {# Heisig kanji for study}
puts $fp #
puts $fp proc\ heisig-lesson-menu\ \{m\ ms\ var\ cmd\}\ \{
puts $fp {    $m add cascade -label {Heisig Lessons} -menu $ms}
puts $fp {    menu $ms -tearoff no}
puts $fp {    # in groups of five}
puts $fp \ \ \ \ for\ \{set\ i\ 1\}\ \{\$i\ <\ 55\}\ \{incr\ i\ 5\}\ \{
puts $fp {	set j [expr {$i+4}]}
puts $fp \tif\ \{\$i\ ==\ 51\}\ \{
puts $fp {	    incr j}
puts $fp \t\}
puts $fp {	set l "$i..$j ([heisig-count-range $i $j])"}
puts $fp \t\$ms\ add\ radiobutton\ -label\ \$l\ -variable\ \$var\ \\
puts $fp {	    -value "heisig-expand-range $i $j" -command $cmd}
puts $fp \ \ \ \ \}
puts $fp {    # review from beginning}
puts $fp \ \ \ \ for\ \{set\ i\ 1\}\ \{\$i\ <\ 55\}\ \{incr\ i\ 5\}\ \{
puts $fp {	set j [expr {$i+4}]}
puts $fp \tif\ \{\$i\ ==\ 51\}\ \{
puts $fp {	    incr j}
puts $fp \t\}
puts $fp \tif\ \{\$i\ ==\ 1\}\ \{
puts $fp {	    $ms add command -label {} -state disabled -columnbreak 1}
puts $fp \t\}\ else\ \{
puts $fp {	    set l "1..$j ([heisig-count-range 1 $j])"}
puts $fp \t\ \ \ \ \$ms\ add\ radiobutton\ -label\ \$l\ -variable\ \$var\ \\
puts $fp {		-value "heisig-expand-range 1 $j" -command $cmd}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp {}
puts $fp proc\ heisig-expand-range\ \{i\ j\}\ \{
puts $fp {    global ::heisig::lessons}
puts $fp {    set i [lindex $::heisig::lessons [incr i -1]]}
puts $fp {    set j [lindex $::heisig::lessons $j]}
puts $fp {    lrange [tkj-get-index L] $i $j}
puts $fp \}
puts $fp {}
puts $fp proc\ heisig-count-range\ \{i\ j\}\ \{
puts $fp {    global ::heisig::lessons}
puts $fp {    set i [lindex $::heisig::lessons [incr i -1]]}
puts $fp {    set j [lindex $::heisig::lessons $j]}
puts $fp {    expr {$j-$i}}
puts $fp \}
close $fp
set restore [file join TkKanji tkj tkj-config.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp namespace\ eval\ ::config::\ \{
puts $fp \ \ \ \ array\ set\ default\ \{
puts $fp {	kanjidic-load 1 kanjidic-path {kanjidic}}
puts $fp {	kanjidic.doc-path {kanjidic.doc}}
puts $fp {	kanjd212-load 0 kanjd212-path {kanjd212}}
puts $fp {	kanjd212.doc-path {kanjd212.doc}}
puts $fp {	font-48 {fixed}}
puts $fp {	font-32 {fixed}}
puts $fp {	font-24 {fixed}}
puts $fp {	font-16 {fixed}}
puts $fp {	subset All}
puts $fp {	startup tkj-choose}
puts $fp \ \ \ \ \}
puts $fp {    set default(startup) [tkj-default application]}
puts $fp \ \ \ \ array\ set\ explain\ \{
puts $fp \tsearch\ \{
puts $fp {	    When tkkanji starts it searches three places for a}
puts $fp {	    configuration file:  the current directory, the directory}
puts $fp {	    where the tkkanji script is stored, and the Tcl/Tk library }
puts $fp {	    directory.}
puts $fp {}
puts $fp {	    If tkkanji finds a configuration file, and the file}
puts $fp {	    specifies a valid configuration, then tkkanji will load}
puts $fp {	    the specified dictionary subset and execute the startup}
puts $fp {	    application.  If any of those steps fails, then tkkanji}
puts $fp {	    should return you to this configuration page so you can}
puts $fp {	    amend the problem, and write a valid configuration back to }
puts $fp {	    the disk.}
puts $fp {}
puts $fp {	    This option menu lists the three places that tkkanji will}
puts $fp {	    search for its configuration file.  Choose the one you}
puts $fp {	    want to write before you press the Write button.}
puts $fp \t\}
puts $fp \tkanjidic-path\ \{
puts $fp {	    This combination check button and file name entry}
puts $fp {	    specifies whether tkkanji should load kanjidic and where}
puts $fp {	    tkkanji can find kanjidic on your computer.}
puts $fp {}
puts $fp {	    Click on "Kanjidic" to specify whether or not tkkanji}
puts $fp {	    should look for and load kanjidic.  (The only reason you}
puts $fp {	    might turn kanjidic loading off is if you want to view}
puts $fp {	    kanjd212 and your computer doesn't have enough memory to}
puts $fp {	    load both dictionaries at once.)}
puts $fp {}
puts $fp {	    If you choose to load kanjidic, you can either type the}
puts $fp {	    path name directly into the entry provided, or click on}
puts $fp {	    the "Select" button to navigate through your folders to}
puts $fp {	    find it.}
puts $fp {}
puts $fp {	    Kanjidic is the primary Kanji dictionary file.  If you don't}
puts $fp {	    already have a copy, you'll need to download one from:}
puts $fp {}
puts $fp {		ftp://ftp.cc.monash.edu.au/pub/nihongo/00INDEX.html}
puts $fp {}
puts $fp {	    or one of the mirror sites listed there.  The file is}
puts $fp {	    named "kanjidic.gz", and you'll also need to decompress}
puts $fp {	    the file, as explained on the download page.}
puts $fp {}
puts $fp {	    Be warned that some combinations of web browsers and}
puts $fp {	    servers will decompress the file automatically, or write a }
puts $fp {	    compressed file into a file name without the ".gz"}
puts $fp {	    extension.}
puts $fp \t\}
puts $fp \tkanjidic.doc-path\ \{
puts $fp {	    This specifies where the documentation for kanjidic is}
puts $fp {	    stored on your computer.  This is optional and can be}
puts $fp {	    downloaded from the same place you obtained kanjidic}
puts $fp {	    itself.}
puts $fp \t\}
puts $fp \tkanjd212-path\ \{
puts $fp {	    This specifies where kanjd212 is stored on your computer.}
puts $fp {	    Kanjd212 is the Kanji dictionary defining ~6000 rarer}
puts $fp {	    Kanji specified by JISX-0212.  This is optional and can be }
puts $fp {	    downloaded from the same place you obtained kanjidic}
puts $fp {	    itself.}
puts $fp \t\}
puts $fp \tkanjd212.doc-path\ \{
puts $fp {	    This specifies where the documentation for kanjd212 is}
puts $fp {	    stored on your computer.  This is optional and can be}
puts $fp {	    downloaded from the same place you obtained kanjidic}
puts $fp {	    itself.}
puts $fp \t\}
puts $fp \tfont\ \{
puts $fp {	    Tkkanji chooses fonts according to the font family, the}
puts $fp {	    font size, and the characters which need to be displayed.}
puts $fp {}
puts $fp {	    Pressing on "Select" will allow you to preview the kanji}
puts $fp {	    display for each available font family available on your}
puts $fp {	    computer.}
puts $fp {}
puts $fp {	    Many of the families listed do not define any Kanji}
puts $fp {	    characters and will end up using the same Kanji fonts as}
puts $fp {	    other families.}
puts $fp {}
puts $fp {	    If none of the families look any good to you, then you}
puts $fp {	    should head back to Jim Breen's web site,}
puts $fp {}
puts $fp {		ftp://ftp.cc.monash.edu.au/pub/nihongo/00INDEX.html}
puts $fp {}
puts $fp {	    and look for some fonts to download.}
puts $fp \t\}
puts $fp \tsubset\ \{
puts $fp {	    For many purposes, a subset of kanjidic is more than}
puts $fp {	    enough.  These subsets are based on the Jouyou grade}
puts $fp {	    levels, the standard Kanji sets taught at each grade}
puts $fp {	    level in Japanese schools, the whole Jouyou list of Kanji}
puts $fp {	    used in mass communication, and the Jinmeiyou list of}
puts $fp {	    Kanji frequently used in names.}
puts $fp \t\}
puts $fp \tstartup\ \{
puts $fp {	    The startup option menu specifies the default application}
puts $fp {	    which tkkanji launches after loading its dictionaries.}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp #
puts $fp {# return the list of config variables}
puts $fp #
puts $fp proc\ ::config::vars\ \{\}\ \{
puts $fp {    global ::config::default}
puts $fp {    array names ::config::default}
puts $fp \}
puts $fp #
puts $fp {# initialize an empty configuration}
puts $fp #
puts $fp proc\ ::config::init\ \{\}\ \{
puts $fp {    global ::config::config}
puts $fp {    global ::config::default}
puts $fp {    array set ::config::config [array get ::config::default]}
puts $fp \}
puts $fp #
puts $fp {# check the contents of a configuration}
puts $fp {# to see that each file to be loaded exists}
puts $fp {# and is readable}
puts $fp #
puts $fp proc\ ::config::check\ \{\}\ \{
puts $fp {    global ::config::config}
puts $fp \ \ \ \ foreach\ name\ \[::config::vars\]\ \{
puts $fp \tif\ \{\ !\ \[info\ exists\ ::config::config(\$name)\]\}\ \{
puts $fp {	    set ::config::config(error) "no ::config::config($name)"}
puts $fp {	    return 0}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ foreach\ \{check\ file\}\ \{
puts $fp {	kanjidic-load kanjidic-path}
puts $fp {	kanjd212-load kanjd212-path}
puts $fp \ \ \ \ \}\ \{
puts $fp \tif\ \{\$::config::config(\$check)\}\ \{
puts $fp \t\ \ \ \ if\ \{\[file\ exists\ \$::config::config(\$file)\]
puts $fp \t\t&&\ \[file\ readable\ \$::config::config(\$file)\]\}\ continue
puts $fp {	    set ::config::config(error) "can't read $::config::config($file)"}
puts $fp {	    return 0}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    return 1}
puts $fp \}
puts $fp #
puts $fp {# list the files to check for configuration}
puts $fp #
puts $fp proc\ ::config::search\ \{\}\ \{
puts $fp \ \ \ \ list\ \\
puts $fp \t\[file\ join\ \[pwd\]\ tkkanji.cfg\]\ \\
puts $fp \t\[file\ join\ \[file\ dirname\ \[info\ script\]\]\ tkkanji.cfg\]\ \\
puts $fp {	[file join [info library] tkkanji.cfg]}
puts $fp \}
puts $fp #
puts $fp {# look for a readable config file, load it,}
puts $fp {# and return the results of checking its paths}
puts $fp #
puts $fp proc\ ::config::load\ \{\}\ \{
puts $fp {    global ::config::config}
puts $fp \ \ \ \ foreach\ file\ \[::config::search\]\ \{
puts $fp \tif\ \{\[file\ exists\ \$file\]\ &&\ \[file\ readable\ \$file\]\}\ \{
puts $fp {	    set ::config::config(file) $file}
puts $fp \t\ \ \ \ if\ \{\[catch\ \{source\ \$file\}\]\}\ \{
puts $fp {		break}
puts $fp \t\ \ \ \ \}\ else\ \{
puts $fp {		return [::config::check]}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    ::config::init}
puts $fp {    return 0}
puts $fp \}
puts $fp #
puts $fp {# update a configuration field}
puts $fp #
puts $fp proc\ ::config::change\ \{w\ cmd\ var\}\ \{
puts $fp {    global ::config::config}
puts $fp \ \ \ \ switch\ \$cmd\ \{
puts $fp {	path -}
puts $fp \tdict\ \{
puts $fp {	    set f [tk_getOpenFile -parent $w]}
puts $fp \t\ \ \ \ if\ \{\[string\ length\ \$f\]\ >\ 0\}\ \{
puts $fp {		set ::config::config($var) $f}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tfont\ \{
puts $fp {	    set x [toplevel-window-name]}
puts $fp {	    toplevel $x}
puts $fp {	    wm title $x {Select Font}}
puts $fp {	    upvar \#0 $x data}
puts $fp {	    bind $x <Destroy> "catch {unset $x}"}
puts $fp {	    # fetch font family}
puts $fp {	    set data(family) $::config::config($var)}
puts $fp {	    set data(families) [font families]}
puts $fp \t\ \ \ \ if\ \{\[lsearch\ \[font\ families\]\ \$data(family)\]\ <\ 0\}\ \{
puts $fp {		set data(family) [lindex $data(family) 0]}
puts $fp \t\ \ \ \ \}
puts $fp {	    # fetch font size}
puts $fp {	    set data(size) [lindex [split $var -] 1]}
puts $fp {	    pack [frame $x.t] -side top}
puts $fp {	    pack [label $x.t.l -text Family:] -side left}
puts $fp {	    pack [label $x.t.f -textvar ${x}(family)] -side left}
puts $fp {	    pack [frame $x.o] -side top}
puts $fp {	    pack [listbox $x.o.l -height 5 -yscrollcommand [list $x.o.y set]] -side left -fill x -expand true}
puts $fp {	    pack [scrollbar $x.o.y -orient vertical -command [list $x.o.l yview]] -side left -fill y}
puts $fp {	    #pack [menubutton $x.o -textvar ${x}(family) -relief raised -indicatoron 1 -menu $x.o.m] -side top}
puts $fp {	    #menu $x.o.m -tearoff no}
puts $fp \t\ \ \ \ foreach\ f\ \$data(families)\ \{
puts $fp {		#$x.o.m add radiobutton -label $f -var ${x}(family) -value $f -command [list $x.l configure -font [list $f $data(size)]]}
puts $fp {		$x.o.l insert end $f}
puts $fp \t\ \ \ \ \}
puts $fp {	    bind $x.o.l <Double-ButtonPress-1> [list ::config::change $w font-sel $x]}
puts $fp \t\ \ \ \ pack\ \[label\ \$x.l\ -text\ \"\\u4e00\ \\u4e8c\\n\\u4e09\ \\u56db\\n\\u4e94\ \\u516d\\n\\u4e03\ \\u516b\\n\\u4e5d\ \\u5341\"\\
puts $fp {		      -font [list $data(family) $data(size)]] -side top}
puts $fp {	    pack [frame $x.b] -side top}
puts $fp {	    pack [button $x.b.okay -text Okay -command [list set ${x}(done) 1]] -side left}
puts $fp {	    pack [button $x.b.cancel -text Cancel -command [list set ${x}(done) 0]] -side left}
puts $fp {	    vwait ${x}(done)}
puts $fp \t\ \ \ \ if\ \{\$data(done)\}\ \{
puts $fp {		set ::config::config($var) $data(family)}
puts $fp \t\ \ \ \ \}
puts $fp {	    destroy $x}
puts $fp \t\}
puts $fp \tfont-sel\ \{
puts $fp {	    set x $var}
puts $fp {	    upvar \#0 $x data}
puts $fp {	    set data(family) [lindex $data(families) [$x.o.l curselection]]}
puts $fp {	    $x.l configure -font [list $data(family) $data(size)]}
puts $fp \t\}
puts $fp \tdefault\ \{
puts $fp {	    error "invalid configuration style: $cmd"}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp #
puts $fp {# explain a configuration item}
puts $fp #
puts $fp proc\ ::config::explain\ \{var\ lbl\}\ \{
puts $fp {    global ::config::config}
puts $fp {    global ::config::explain}
puts $fp {    browsedata "Explain: $lbl" $::config::explain($var)}
puts $fp \}
puts $fp #
puts $fp {# write the configuration}
puts $fp #
puts $fp proc\ ::config::write\ \{\}\ \{
puts $fp {    global ::config::config}
puts $fp \ \ \ \ if\ \{\ !\ \[::config::check\]\}\ \{
puts $fp {	error "There is an error in your configuration which needs to be corrected before you can continue:  $::config::config(error)"}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ set\ c\ \"array\ set\ ::config::config\ \{\\n\"
puts $fp \ \ \ \ foreach\ \{name\}\ \[::config::vars\]\ \{
puts $fp {	append c "  {$name} {$::config::config($name)}\n"}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ append\ c\ \"\}\\n\"
puts $fp \ \ \ \ if\ \{\[catch\ \{
puts $fp {	set fp [open $::config::config(file) w]}
puts $fp {	puts -nonewline $fp $c}
puts $fp {	close $fp}
puts $fp \ \ \ \ \}\ error\]\}\ \{
puts $fp {	error "error writing configuration file to $::config::config(file): $error"}
puts $fp \ \ \ \ \}
puts $fp {    set ::config::config(done) 1}
puts $fp \}
puts $fp #
puts $fp {# start up from a configuration dialog}
puts $fp #
puts $fp proc\ ::config::startup\ \{\}\ \{
puts $fp {    global ::config::config}
puts $fp \ \ \ \ if\ \{\ !\ \[::config::check\]\}\ \{
puts $fp {	error "There is an error in your configuration which needs to be corrected before you can continue:  $::config::config(error)"}
puts $fp \ \ \ \ \}
puts $fp {    set ::config::config(done) 1}
puts $fp \}
puts $fp #
puts $fp {# display the configuration}
puts $fp {# and allow it to be modified,}
puts $fp {# checked, executed, and saved}
puts $fp #
puts $fp proc\ ::config::display\ \{w\ state\}\ \{
puts $fp {    global ::config::config}
puts $fp {    wm title $w {Tk Kanji Configuration}}
puts $fp {    set f 0}
puts $fp \ \ \ \ if\ \{\[string\ compare\ \$state\ normal\]\ ==\ 0\}\ \{
puts $fp {	set m $w.f[incr f]}
puts $fp {	pack [frame $m] -side top}
puts $fp {	pack [tkj-file-menu $m.f] -side left}
puts $fp {	pack [tkj-application-menu $m.a $w] -side left}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ foreach\ \{lbl\ var\ cmd\}\ \{
puts $fp {	{Tk Kanji Configuration} {} none}
puts $fp {	{Configuration file} file search}
puts $fp {	{Kanjidic} kanjidic dict}
puts $fp {	{Kanjidic.doc path} kanjidic.doc-path path}
puts $fp {	{Kanjd212} kanjd212 dict}
puts $fp {	{Kanjd212.doc path} kanjd212.doc-path path}
puts $fp {	{48pt font family} font-48 font}
puts $fp {	{32pt font family} font-32 font}
puts $fp {	{24pt font family} font-24 font}
puts $fp {	{16pt font family} font-16 font}
puts $fp {	{Subset to read} subset subset}
puts $fp {	{Startup application} startup startup}
puts $fp \ \ \ \ \}\ \{
puts $fp {	pack [frame $w.f[incr f]] -side top -fill x}
puts $fp \tswitch\ \$cmd\ \{
puts $fp \t\ \ \ \ none\ \{
puts $fp {		pack [label $w.f$f.l -text $lbl] -side left}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ search\ \{
puts $fp {		pack [label $w.f$f.l -text "$lbl: "] -side left -anchor w}
puts $fp {		eval tk_optionMenu $w.f$f.o ::config::config($var) [::config::search]}
puts $fp {		pack $w.f$f.o -side left -anchor w}
puts $fp {		pack [button $w.f$f.help -text { ? } -command [list ::config::explain $var $lbl]] -side right -anchor e}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ dict\ \{
puts $fp {		pack [checkbutton $w.f$f.b -text $lbl -var ::config::config($var-load)] -side left}
puts $fp {		pack [button $w.f$f.help -text { ? } -command [list ::config::explain $var $lbl]] -side right -anchor e}
puts $fp {		pack [button $w.f$f.c -text select -command [list ::config::change $w $cmd $var-path]] -side right -anchor e}
puts $fp {		pack [entry $w.f$f.e -width 40 -textvar ::config::config($var-path)] -side right -anchor e}
puts $fp \t\ \ \ \ \}
puts $fp {	    path -}
puts $fp \t\ \ \ \ font\ \{
puts $fp {		pack [label $w.f$f.l -text "$lbl: "] -side left}
puts $fp {		pack [button $w.f$f.help -text { ? } -command [list ::config::explain $var $lbl]] -side right -anchor e}
puts $fp {		pack [button $w.f$f.c -text select -command [list ::config::change $w $cmd $var]] -side right -anchor e}
puts $fp {		pack [entry $w.f$f.e -width 40 -textvar ::config::config($var)] -side right -anchor e}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ subset\ \{
puts $fp {		pack [label $w.f$f.l -text $lbl:] -side left}
puts $fp \t\ttk_optionMenu\ \$w.f\$f.o\ ::config::config(\$var)\ \\
puts $fp \t\t\ \ \ \ Jouyou-1\ \\
puts $fp \t\t\ \ \ \ Jouyou-1-2\ \\
puts $fp \t\t\ \ \ \ Jouyou-1-3\ \\
puts $fp \t\t\ \ \ \ Jouyou-1-4\ \\
puts $fp \t\t\ \ \ \ Jouyou-1-5\ \\
puts $fp \t\t\ \ \ \ Jouyou-1-6\ \\
puts $fp \t\t\ \ \ \ Jouyou\ \\
puts $fp \t\t\ \ \ \ Jouyou+Jinmeiyou\ \\
puts $fp \t\t\ \ \ \ JISX-0208\ \\
puts $fp {		    All}
puts $fp {		pack $w.f$f.o -side left}
puts $fp {		pack [button $w.f$f.help -text { ? } -command [list ::config::explain $var $lbl]] -side right -anchor e}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ startup\ \{
puts $fp {		pack [label $w.f$f.l -text $lbl:] -side left}
puts $fp {		eval tk_optionMenu $w.f$f.o ::config::config($var) [tkj-applications]}
puts $fp {		pack $w.f$f.o -side left}
puts $fp {		pack [button $w.f$f.help -text { ? } -command [list ::config::explain $var $lbl]] -side right -anchor e}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ default\ \{
puts $fp {		error "unimplemented configuration style: $cmd"}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    pack [button $w.b[incr f] -text Write -command ::config::write] -side top -fill x}
puts $fp \ \ \ \ if\ \{\[string\ compare\ \$state\ normal\]\ !=\ 0\}\ \{
puts $fp {	pack [button $w.b[incr f] -text Done -command ::config::startup] -side top -fill x}
puts $fp \ \ \ \ \}
puts $fp {    pack [label $w.status -textvar tkkanji(status)] -side top -fill x}
puts $fp \ \ \ \ if\ \{\[string\ compare\ \$state\ normal\]\ !=\ 0\}\ \{
puts $fp {	set ::config::config(done) 0}
puts $fp {	vwait ::config::config(done)}
puts $fp {	tkj-splash $w}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp #
puts $fp {# wrap these pieces}
puts $fp #
puts $fp proc\ tkj-configure\ \{w\ \{state\ normal\}\}\ \{
puts $fp \ \ \ \ switch\ \$state\ \{
puts $fp \tstartup\ \{
puts $fp {	    if { ! [::config::load]} { ::config::display [tkj-empty $w] $state }}
puts $fp \t\}
puts $fp {	rescue -}
puts $fp \tnormal\ \{
puts $fp {	    ::config::display [tkj-empty $w] $state}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp #
puts $fp {# access parts of the configuration}
puts $fp #
puts $fp {proc tkj-cget {key} { global ::config::config; set ::config::config($key) }}
puts $fp #
puts $fp {# return a font}
puts $fp #
puts $fp proc\ tkj-font\ \{pts\}\ \{
puts $fp {    # hack}
puts $fp {    global tkj-override-font}
puts $fp \ \ \ \ if\ \{\[info\ exists\ tkj-override-font(\$pts)\]\}\ \{
puts $fp {	set tkj-override-font($pts)}
puts $fp \ \ \ \ \}\ else\ \{
puts $fp {	list [tkj-cget font-$pts] $pts}
puts $fp \ \ \ \ \}
puts $fp \}
close $fp
set restore [file join TkKanji tkj Makefile]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp SRC=\tmisc.tcl\ \\
puts $fp \tprogress.tcl\ \\
puts $fp \trandom.tcl\ \\
puts $fp \ttkj-browse.tcl\ \\
puts $fp \ttkj-config.tcl\ \\
puts $fp \ttkj-copyright.tcl\ \\
puts $fp \ttkj-default.tcl\ \\
puts $fp \ttkj-dict.tcl\ \\
puts $fp \ttkj-heisig.tcl\ \\
puts $fp \ttkj-multi-choice.tcl\ \\
puts $fp \ttkj-self-test.tcl\ \\
puts $fp \ttkj-tration.tcl\ \\
puts $fp {	tkj-util.tcl}
puts $fp {}
puts $fp {tclIndex: $(SRC)}
puts $fp {	echo "auto_mkindex . $(SRC)" | tclsh}
close $fp
set restore [file join TkKanji tkj random.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp #
puts $fp {# random.tcl - very random number generator in tcl.}
puts $fp #
puts $fp {# Copyright 1995 by Roger E. Critchlow Jr., San Francisco, California.}
puts $fp {# All rights reserved.  Fair use permitted.  Caveat emptor.}
puts $fp #
puts $fp {# This code implements a very long period random number}
puts $fp {# generator.  The following symbols are "exported" from}
puts $fp {# this module:}
puts $fp #
puts $fp {#	[random] returns 31 bits of random integer.}
puts $fp {#	[srandom <integer!=0>] reseeds the generator.}
puts $fp {#	$RAND_MAX yields the maximum number in the}
puts $fp {#	  range of [random] or maybe one greater.}
puts $fp #
puts $fp {# The generator is one George Marsaglia, geo@stat.fsu.edu,}
puts $fp {# calls the Mother of All Random Number Generators.}
puts $fp #
puts $fp {# The coefficients in a2 and a3 are corrections to the original}
puts $fp {# posting.  These values keep the linear combination within the}
puts $fp {# 31 bit summation limit.}
puts $fp #
puts $fp {# And we are truncating a 32 bit generator to 31 bits on}
puts $fp {# output.  This generator could produce the uniform distribution}
puts $fp {# on [INT_MIN .. -1] [1 .. INT_MAX]}
puts $fp #
puts $fp namespace\ eval\ random\ \{
puts $fp {    set a1 { 1941 1860 1812 1776 1492 1215 1066 12013 };}
puts $fp {    set a2 { 1111 2222 3333 4444 5555 6666 7777   827 };}
puts $fp {    set a3 { 1111 2222 3333 4444 5555 6666 7777   251 };}
puts $fp {    set m1 { 30903 4817 23871 16840 7656 24290 24514 15657 19102 };}
puts $fp {    set m2 { 30903 4817 23871 16840 7656 24290 24514 15657 19102 };}
puts $fp {}
puts $fp \ \ \ \ proc\ srand16\ \{seed\}\ \{
puts $fp {	set n1 [expr $seed & 0xFFFF];}
puts $fp {	set n2 [expr $seed & 0x7FFFFFFF];}
puts $fp {	set n2 [expr 30903 * $n1 + ($n2 >> 16)];}
puts $fp {	set n1 [expr $n2 & 0xFFFF];}
puts $fp {	set m  [expr $n1 & 0x7FFF];}
puts $fp \tforeach\ i\ \{1\ 2\ 3\ 4\ 5\ 6\ 7\ 8\}\ \{
puts $fp {	    set n2 [expr 30903 * $n1 + ($n2 >> 16)];}
puts $fp {	    set n1 [expr $n2 & 0xFFFF];}
puts $fp {	    lappend m $n1;}
puts $fp \t\}
puts $fp {	return $m;}
puts $fp \ \ \ \ \}
puts $fp {    }
puts $fp \ \ \ \ proc\ rand16\ \{a\ m\}\ \{
puts $fp \tset\ n\ \[expr\ \\
puts $fp \t\t\ \ \ \[lindex\ \$m\ 0\]\ +\ \\
puts $fp \t\t\ \ \ \[lindex\ \$a\ 0\]\ *\ \[lindex\ \$m\ 1\]\ +\ \\
puts $fp \t\t\ \ \ \[lindex\ \$a\ 1\]\ *\ \[lindex\ \$m\ 2\]\ +\ \\
puts $fp \t\t\ \ \ \[lindex\ \$a\ 2\]\ *\ \[lindex\ \$m\ 3\]\ +\ \\
puts $fp \t\t\ \ \ \[lindex\ \$a\ 3\]\ *\ \[lindex\ \$m\ 4\]\ +\ \\
puts $fp \t\t\ \ \ \[lindex\ \$a\ 4\]\ *\ \[lindex\ \$m\ 5\]\ +\ \\
puts $fp \t\t\ \ \ \[lindex\ \$a\ 5\]\ *\ \[lindex\ \$m\ 6\]\ +\ \\
puts $fp \t\t\ \ \ \[lindex\ \$a\ 6\]\ *\ \[lindex\ \$m\ 7\]\ +\ \\
puts $fp {		   [lindex $a 7] * [lindex $m 8]];}
puts $fp {	}
puts $fp {	return [concat [expr $n >> 16] [expr $n & 0xFFFF] [lrange $m 1 7]];}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp {}
puts $fp #
puts $fp {# Externals}
puts $fp {# }
puts $fp {set RANDOM_MAX 0x7FFFFFFF;}
puts $fp {    }
puts $fp proc\ srandom\ \{seed\}\ \{
puts $fp {    global random::m1 random::m2;}
puts $fp {    set random::m1 [random::srand16 $seed];}
puts $fp {    set random::m2 [random::srand16 [expr 4321+$seed]];}
puts $fp {    return {};}
puts $fp \}
puts $fp {}
puts $fp proc\ random\ \{\}\ \{
puts $fp {    global random::m1 random::m2 random::a1 random::a2;}
puts $fp {    set random::m1 [random::rand16 [set random::a1] [set random::m1]];}
puts $fp {    set random::m2 [random::rand16 [set random::a2] [set random::m2]];}
puts $fp {    return [expr (([lindex [set random::m1] 1] << 16) + [lindex [set random::m2] 1]) & 0x7FFFFFFF];}
puts $fp \}
close $fp
set restore [file join TkKanji tkj tclIndex]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp {# Tcl autoload index file, version 2.0}
puts $fp {# This file is generated by the "auto_mkindex" command}
puts $fp {# and sourced to set up indexing information for one or}
puts $fp {# more commands.  Typically each line is a command that}
puts $fp {# sets an element in the auto_index array, where the}
puts $fp {# element name is the name of a command and the value is}
puts $fp {# a script that loads the command.}
puts $fp {}
puts $fp {set auto_index(toplevel-window-name) [list source [file join $dir misc.tcl]]}
puts $fp {set auto_index(textview) [list source [file join $dir misc.tcl]]}
puts $fp {set auto_index(readfile) [list source [file join $dir misc.tcl]]}
puts $fp {set auto_index(browsefile) [list source [file join $dir misc.tcl]]}
puts $fp {set auto_index(browsedata) [list source [file join $dir misc.tcl]]}
puts $fp {set auto_index(shuffle) [list source [file join $dir misc.tcl]]}
puts $fp {set auto_index(choose-one) [list source [file join $dir misc.tcl]]}
puts $fp {set auto_index(progress) [list source [file join $dir progress.tcl]]}
puts $fp {set auto_index(::random::srand16) [list source [file join $dir random.tcl]]}
puts $fp {set auto_index(::random::rand16) [list source [file join $dir random.tcl]]}
puts $fp {set auto_index(srandom) [list source [file join $dir random.tcl]]}
puts $fp {set auto_index(random) [list source [file join $dir random.tcl]]}
puts $fp {set auto_index(tkj-browse-record) [list source [file join $dir tkj-browse.tcl]]}
puts $fp {set auto_index(tkj-browse-select) [list source [file join $dir tkj-browse.tcl]]}
puts $fp {set auto_index(tkj-browse-reload) [list source [file join $dir tkj-browse.tcl]]}
puts $fp {set auto_index(kanji-browse) [list source [file join $dir tkj-browse.tcl]]}
puts $fp {set auto_index(::config::vars) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::init) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::check) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::search) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::load) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::change) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::explain) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::write) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::startup) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(::config::display) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(tkj-configure) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(tkj-cget) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(tkj-font) [list source [file join $dir tkj-config.tcl]]}
puts $fp {set auto_index(tkj-copyright) [list source [file join $dir tkj-copyright.tcl]]}
puts $fp {set auto_index(gpl-preamble) [list source [file join $dir tkj-copyright.tcl]]}
puts $fp {set auto_index(gpl-terms) [list source [file join $dir tkj-copyright.tcl]]}
puts $fp {set auto_index(gpl-warranty) [list source [file join $dir tkj-copyright.tcl]]}
puts $fp {set auto_index(gpl-addendum) [list source [file join $dir tkj-copyright.tcl]]}
puts $fp {set auto_index(gpl-license) [list source [file join $dir tkj-copyright.tcl]]}
puts $fp {set auto_index(tkj-applications) [list source [file join $dir tkj-default.tcl]]}
puts $fp {set auto_index(tkj-default) [list source [file join $dir tkj-default.tcl]]}
puts $fp {set auto_index(tkj-get-field-type) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-get-field-label) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-get-field-description) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-get-field-value-label) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-load-dictionary) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(get-record) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-get-field) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-get-index) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-get-class) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-class-size) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-class-names) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(tkj-class-exists) [list source [file join $dir tkj-dict.tcl]]}
puts $fp {set auto_index(heisig-lesson-menu) [list source [file join $dir tkj-heisig.tcl]]}
puts $fp {set auto_index(heisig-expand-range) [list source [file join $dir tkj-heisig.tcl]]}
puts $fp {set auto_index(heisig-count-range) [list source [file join $dir tkj-heisig.tcl]]}
puts $fp {set auto_index(keyword-choose-kanji) [list source [file join $dir tkj-multi-choice.tcl]]}
puts $fp {set auto_index(kanji-multi-choice) [list source [file join $dir tkj-multi-choice.tcl]]}
puts $fp {set auto_index(keyword-show-kanji) [list source [file join $dir tkj-self-test.tcl]]}
puts $fp {set auto_index(kanji-self-test) [list source [file join $dir tkj-self-test.tcl]]}
puts $fp {set auto_index(concentration) [list source [file join $dir tkj-tration.tcl]]}
puts $fp {set auto_index(kanji-tration) [list source [file join $dir tkj-tration.tcl]]}
puts $fp {set auto_index(tkj-status) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-push-status) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-pop-status) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-quit) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-view-trace) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-view-copyright) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-view-terms) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-view-warranty) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-view-license) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-empty) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-toplevel) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-file-menu) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-application-menu) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-index-menu) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-select-menu) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-select-submenu) [list source [file join $dir tkj-util.tcl]]}
puts $fp {set auto_index(tkj-chooser) [list source [file join $dir tkj-util.tcl]]}
close $fp
set restore [file join TkKanji tkj tkj-util.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, New Mexico, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp #
puts $fp {# every main window has a status line}
puts $fp {# which mirrors this variable}
puts $fp #
puts $fp proc\ tkj-status\ \{msg\}\ \{
puts $fp {    global tkkanji}
puts $fp {    set tmp $tkkanji(status)}
puts $fp {    set tkkanji(status) $msg; update}
puts $fp {    return $tmp}
puts $fp \}
puts $fp proc\ tkj-push-status\ \{msg\}\ \{
puts $fp {    global tkkanji}
puts $fp {    lappend tkkanji(status-stack) [tkj-status $msg]}
puts $fp \}\ \ \ \ 
puts $fp proc\ tkj-pop-status\ \{\}\ \{
puts $fp {    global tkkanji}
puts $fp {    tkj-status [lindex tkkanji(status-stack) end]}
puts $fp {    set tkkanji(status-stack) [lreplace $tkkanji(status-stack) end end]}
puts $fp \}
puts $fp #
puts $fp {# simply quit}
puts $fp #
puts $fp proc\ tkj-quit\ \{\}\ \{
puts $fp {    destroy .}
puts $fp \}
puts $fp #
puts $fp {# display an error and its Tcl stack trace}
puts $fp #
puts $fp proc\ tkj-view-trace\ \{title\ error\}\ \{
puts $fp {    global errorInfo}
puts $fp {     browsedata $title "Error message: {\n$error\n}\nStack trace: {\n$errorInfo\n}"}
puts $fp \}
puts $fp #
puts $fp {# do the right thing}
puts $fp #
puts $fp proc\ tkj-view-copyright\ \{\}\ \{
puts $fp {    browsedata {Tk Kanji Copyright} [tkj-copyright]}
puts $fp \}
puts $fp proc\ tkj-view-terms\ \{\}\ \{
puts $fp {    browsedata {Tk Kanji Terms} [gpl-terms]}
puts $fp \}
puts $fp proc\ tkj-view-warranty\ \{\}\ \{
puts $fp {    browsedata {Tk Kanji Warranty} [gpl-warranty]}
puts $fp \}
puts $fp proc\ tkj-view-license\ \{\}\ \{
puts $fp {    browsedata {Tk Kanji License} [gpl-license]}
puts $fp \}
puts $fp #
puts $fp {# empty a window of its contents}
puts $fp {# NB, toplevel windows are children of .}
puts $fp #
puts $fp proc\ tkj-empty\ \{w\}\ \{
puts $fp \ \ \ \ foreach\ child\ \[winfo\ children\ \$w\]\ \{
puts $fp {	destroy $child}
puts $fp \ \ \ \ \}
puts $fp {    return $w}
puts $fp \}
puts $fp #
puts $fp {# make a new toplevel window with title}
puts $fp #
puts $fp proc\ tkj-toplevel\ \{title\}\ \{
puts $fp {    set w [toplevel-window-name]}
puts $fp {    toplevel $w}
puts $fp {    wm title $w $title}
puts $fp {    return $w}
puts $fp \}
puts $fp #
puts $fp {# make the file menu}
puts $fp #
puts $fp proc\ tkj-file-menu\ \{w\}\ \{
puts $fp {    menubutton $w -text file -menu $w.m}
puts $fp {    menu $w.m -tearoff no}
puts $fp \ \ \ \ \$w.m\ add\ command\ -label\ \{view\ kanjidic\}\ \\
puts $fp {	-command [list browsefile kanjidic [tkj-cget kanjidic-path] [tkj-font 16]]}
puts $fp \ \ \ \ \$w.m\ add\ command\ -label\ \{view\ kanjidic.doc\}\ \\
puts $fp {	-command [list browsefile kanjidic.doc [tkj-cget kanjidic.doc-path] [tkj-font 16]]}
puts $fp \ \ \ \ \$w.m\ add\ command\ -label\ \{view\ kanjd212\}\ \\
puts $fp {	-command [list browsefile kanjd212 [tkj-cget kanjd212-path] [tkj-font 16]]}
puts $fp \ \ \ \ \$w.m\ add\ command\ -label\ \{view\ kanjd212.doc\}\ \\
puts $fp {	-command [list browsefile kanjd212.doc [tkj-cget kanjd212.doc-path] [tkj-font 16]]}
puts $fp {    $w.m add separator}
puts $fp {    $w.m add command -label {view copyright} -command {browsedata {Tk Kanji Copyright} [tkj-copyright]}}
puts $fp {    $w.m add command -label {view terms} -command {browsedata {Tk Kanji Terms} [gpl-terms]}}
puts $fp {    $w.m add command -label {view warranty} -command {browsedata {Tk Kanji Warranty} [gpl-warranty]}}
puts $fp {    $w.m add command -label {view license} -command {browsedata {Tk Kanji License} [gpl-license]}}
puts $fp {    $w.m add separator}
puts $fp {    $w.m add command -label quit -command {tkj-quit}}
puts $fp {    return $w}
puts $fp \}
puts $fp #
puts $fp {# make the application menu}
puts $fp #
puts $fp proc\ tkj-application-menu\ \{w\ win\}\ \{
puts $fp {    menubutton $w -text applications -menu $w.m}
puts $fp {    menu $w.m -tearoff no}
puts $fp \ \ \ \ foreach\ app\ \[tkj-applications\]\ \{
puts $fp {	$w.m add command -label $app -command [list $app $win]}
puts $fp \ \ \ \ \}
puts $fp {    return $w}
puts $fp \}
puts $fp #
puts $fp #
puts $fp #
puts $fp proc\ tkj-index-menu\ \{w\ varname\ cmd\}\ \{
puts $fp {    upvar \#0 $varname index}
puts $fp {    set index [tkj-default index]}
puts $fp {    menubutton $w -text index -menu $w.m}
puts $fp {    menu $w.m -tearoff no}
puts $fp {    $w.m add radiobutton -label All -variable $varname -value "tkj-get-index all" -command $cmd}
puts $fp \ \ \ \ foreach\ \{code\}\ \{F\ DR\ H\ N\ V\ E\ IN\ K\ L\ MN\ MP\ O\ J0\ J1\ U\}\ \{
puts $fp {	$w.m add radiobutton -label [tkj-get-field-label $code] -variable $varname -value "tkj-get-index $code" -command $cmd}
puts $fp \ \ \ \ \}
puts $fp {    return $w}
puts $fp \}
puts $fp #
puts $fp #
puts $fp #
puts $fp proc\ tkj-select-menu\ \{w\ varname\ cmd\}\ \{
puts $fp {    upvar \#0 $varname select}
puts $fp {    set select [tkj-default select]}
puts $fp {    menubutton $w -text select -menu $w.m}
puts $fp {    menu $w.m -tearoff no}
puts $fp {    $w.m add radiobutton -label All -variable $varname -value "tkj-get-class all" -command $cmd}
puts $fp {    # defer on  P I Q}
puts $fp \ \ \ \ foreach\ \{code\}\ \{G\ B\ C\ S\ L\}\ \{
puts $fp {	tkj-select-submenu $w.m $varname $cmd $code}
puts $fp \ \ \ \ \}
puts $fp {    return $w}
puts $fp \}
puts $fp #
puts $fp {# tkj-select-menu - build a select menu}
puts $fp {#   choose, via hierarchical menues, one class to highlight}
puts $fp #
puts $fp proc\ tkj-select-submenu\ \{m\ varname\ cmd\ code\}\ \{
puts $fp {    set ms $m.[string tolower $code]}
puts $fp \ \ \ \ switch\ \$code\ \{
puts $fp \tG\ \{
puts $fp {	    # JouYou grades}
puts $fp {	    $m add cascade -label [tkj-get-field-label $code] -menu $ms}
puts $fp {	    menu $ms -tearoff no}
puts $fp \t\ \ \ \ foreach\ \{code\}\ \{G\ G1\ G2\ G3\ G4\ G5\ G6\ G8\ G9\}\ \{
puts $fp {		foreach {k v} [split $code {}] break}
puts $fp \t\t\$ms\ add\ radiobutton\ -label\ \"\[tkj-get-field-value-label\ \$k\ \$v\]\ (\[tkj-class-size\ \$code\])\"\ \\
puts $fp \t\t\ \ \ \ -variable\ \$varname\ -value\ \"tkj-get-class\ \$code\"\ \\
puts $fp {		    -command $cmd}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tB\ -\ C\ \{
puts $fp {	    # Radicals}
puts $fp {	    $m add cascade -label [tkj-get-field-label $code] -menu $ms}
puts $fp {	    menu $ms -tearoff no}
puts $fp \t\ \ \ \ foreach\ \{i\ j\}\ \{1\ 49\ 50\ 99\ 100\ 149\ 150\ 199\ 200\ 214\}\ \{
puts $fp {		$ms add cascade -label "$i-$j" -menu $ms.s$i}
puts $fp {		menu $ms.s$i -tearoff no}
puts $fp {		if {$i == 1} { set dk 9 } else { set dk 10 }}
puts $fp \t\tfor\ \{set\ k\ \$i\}\ \{\$k\ <=\ \$j\}\ \{incr\ k\ \$dk\;\ set\ dk\ 10\}\ \{
puts $fp {		    $ms.s$i add cascade -label "$k-[expr {$k+$dk-1}]" -menu $ms.s$i.s$k}
puts $fp {		    menu $ms.s$i.s$k -tearoff no}
puts $fp \t\t\ \ \ \ for\ \{set\ l\ \$k\}\ \{\$l\ <\ \$k+\$dk\}\ \{incr\ l\}\ \{
puts $fp \t\t\tif\ \{\[tkj-class-exists\ \$code\$l\]\}\ \{
puts $fp \t\t\t\ \ \ \ \$ms.s\$i.s\$k\ add\ radiobutton\ -label\ \"\$l\ (\[tkj-class-size\ \$code\$l\])\"\ \\
puts $fp \t\t\t\t-variable\ \$varname\ -value\ \"tkj-get-class\ \$code\$l\"\ \\
puts $fp {				-command $cmd}
puts $fp \t\t\t\}
puts $fp \t\t\ \ \ \ \}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tS\ \{
puts $fp {	    # Stroke counts}
puts $fp {	    $m add cascade -label [tkj-get-field-label $code] -menu $ms}
puts $fp {	    menu $ms -tearoff no}
puts $fp \t\ \ \ \ foreach\ i\ \[tkj-class-names\ S?*\]\ \{
puts $fp {		set stroke([string range $i 1 end]) 1}
puts $fp \t\ \ \ \ \}
puts $fp {	    set cb 0}
puts $fp \t\ \ \ \ foreach\ i\ \[lsort\ -integer\ \[array\ names\ stroke\]\]\ \{
puts $fp \t\t\$ms\ add\ radiobutton\ -label\ \"\$i\ (\[tkj-class-size\ S\$i\])\"\ \\
puts $fp \t\t\ \ \ \ -variable\ \$varname\ -value\ \"tkj-get-class\ S\$i\"\ \\
puts $fp {		    -command $cmd -columnbreak $cb}
puts $fp {		set cb [expr {$i % 10 == 0}]}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tL\ \{
puts $fp {	    # Heisig lessons}
puts $fp {	    heisig-lesson-menu $m $ms $varname $cmd}
puts $fp \t\}
puts $fp \tP\ \{
puts $fp {	    # Skip codes}
puts $fp {	    $m add cascade -label [tkj-get-field-label $code] -menu $ms}
puts $fp {	    menu $ms -tearoff no}
puts $fp \t\ \ \ \ foreach\ i\ \[tkj-class-names\ P?*\]\ \{
puts $fp {		foreach {s1 s2 s3} [split [string range $i 1 end] -] break}
puts $fp {		set s1 [format 0%02o $s1]}
puts $fp {		set s2 [format 0%02o $s2]}
puts $fp {		set s3 [format 0%02o $s3]}
puts $fp {		set skipdata($s1) 1}
puts $fp {		set skipdata($s1$s2) 1}
puts $fp {		set skipdata($s1$s2$s3) 1}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ foreach\ s1\ \[lsort\ \[array\ names\ skipdata\ ???\]\]\ \{
puts $fp {		$ms add cascade -label [format %d-*-* $s1] -menu $ms.s$s1}
puts $fp {		menu $ms.s$s1 -tearoff no}
puts $fp \t\tforeach\ s1s2\ \[lsort\ \[array\ names\ skipdata\ \$s1???\]\]\ \{
puts $fp {		    set s2 [string range $s1s2 3 end]}
puts $fp {		    $ms.s$s1 add cascade -label [format %d-%d-* $s1 $s2] -menu $ms.s$s1.s$s2}
puts $fp {		    menu $ms.s$s1.s$s2 -tearoff no}
puts $fp \t\t\ \ \ \ foreach\ s1s2s3\ \[lsort\ \[array\ names\ skipdata\ \$s1s2???\]\]\ \{
puts $fp {			set s3 [string range $s1s2s3 6 end]}
puts $fp {			set p [format %d-%d-%d $s1 $s2 $s3]}
puts $fp \t\t\t\$ms.s\$s1.s\$s2\ add\ radiobutton\ -label\ \"\$p\ (\[tkj-class-size\ P\$p\])\"\ \\
puts $fp \t\t\t\ \ \ \ -variable\ \$varname\ -value\ \"tkj-get-class\ P\$p\"\ \\
puts $fp {			    -command $cmd}
puts $fp \t\t\ \ \ \ \}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tI\ \{
puts $fp {	    # Spahn & Hadamitzky codes}
puts $fp {	    $m add cascade -label [tkj-get-field-label $code] -menu $ms}
puts $fp {	    menu $ms -tearoff no}
puts $fp {	    scan a %c a}
puts $fp \t\ \ \ \ foreach\ i\ \[lsort\ \[tkj-class-names\ \{I\[1-9\]*\}\]\]\ \{
puts $fp \t\tif\ \{\ !\ \[regexp\ \{^.(\[0-9\]+)(\[a-z\])(\[0-9\]+)\$\}\ \$i\ all\ s1\ s2\ s3\]\}\ \{
puts $fp {		    puts "S&H $i didn't scan"}
puts $fp \t\t\}
puts $fp {		set s1 [format %03o $s1]}
puts $fp {		scan $s2 %c s2}
puts $fp {		set s2 [format %03o [expr {$s2-$a}]]}
puts $fp {		set s3 [format %03o $s3]}
puts $fp {		set sethdata($s1) 1}
puts $fp {		set sethdata($s1$s2) 1}
puts $fp {		set sethdata($s1$s2$s3) 1}
puts $fp \t\ \ \ \ \}
puts $fp {	    # }
puts $fp \t\ \ \ \ foreach\ s1\ \[lsort\ \[array\ names\ sethdata\ ???\]\]\ \{
puts $fp {		$ms add cascade -label [format %d** $s1] -menu $ms.s$s1}
puts $fp {		menu $ms.s$s1 -tearoff no}
puts $fp \t\tforeach\ s1s2\ \[lsort\ \[array\ names\ sethdata\ \$s1???\]\]\ \{
puts $fp {		    set s2 [string range $s1s2 3 end]}
puts $fp {		    set a2 [expr {$a+$s2}]}
puts $fp {		    $ms.s$s1 add cascade -label [format %d%c* $s1 $a2] -menu $ms.s$s1.s$s2}
puts $fp {		    menu $ms.s$s1.s$s2 -tearoff no}
puts $fp \t\t\ \ \ \ foreach\ s1s2s3\ \[lsort\ \[array\ names\ sethdata\ \$s1s2???\]\]\ \{
puts $fp {			set s3 [string range $s1s2s3 6 end]}
puts $fp {			set p [format %d%c%d $s1 $a2 $s3]}
puts $fp \t\t\t\$ms.s\$s1.s\$s2\ add\ radiobutton\ -label\ \"\$p\ (\[tkj-class-size\ I\$p\])\"\ \\
puts $fp \t\t\t\ \ \ \ -variable\ \$varname\ -value\ \"tkj-get-class\ I\$p\"\ \\
puts $fp {			    -command $cmd}
puts $fp \t\t\ \ \ \ \}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tQ\ \{
puts $fp {	    # Four Corner codes}
puts $fp {	    $m add cascade -label [tkj-get-field-label $code] -menu $ms}
puts $fp {	    menu $ms -tearoff no}
puts $fp \t\ \ \ \ foreach\ i\ \[lsort\ \[tkj-class-names\ \{Q????\}\]\]\ \{
puts $fp {		foreach {q q1 q2 q3 q4} [split $i {}] break}
puts $fp \t\tif\ \{\[catch\ \{\$ms\ entrycget\ \$q1???\ -label\}\ msg\]\}\ \{
puts $fp {		    $ms add cascade -label $q1??? -menu $ms.q$q1}
puts $fp {		    menu $ms.q$q1 -tearoff no}
puts $fp \t\t\}
puts $fp \t\tif\ \{\[catch\ \{\$ms.q\$q1\ entrycget\ \$q1\$q2??\ -label\}\ msg\]\}\ \{
puts $fp {		    $ms.q$q1 add cascade -label $q1$q2?? -menu $ms.q$q1.q$q2}
puts $fp {		    menu $ms.q$q1.q$q2 -tearoff no}
puts $fp \t\t\}
puts $fp \t\tif\ \{\[catch\ \{\$ms.q\$q1.q\$q2\ entrycget\ \$q1\$q2\$q3?\ -label\}\ msg\]\}\ \{
puts $fp {		    $ms.q$q1.q$q2 add cascade -label $q1$q2$q3? -menu $ms.q$q1.q$q2.q$q3}
puts $fp {		    menu $ms.q$q1.q$q2.q$q3 -tearoff no}
puts $fp \t\t\}
puts $fp {		set p $q1$q2$q3$q4}
puts $fp \t\t\$ms.q\$q1.q\$q2.q\$q3\ add\ radiobutton\ -label\ \"\$p\ (\[tkj-class-size\ Q\$p\])\"\ \\
puts $fp \t\t\ \ \ \ -variable\ \$varname\ -value\ \"tkj-get-class\ Q\$p\"\ \\
puts $fp {		    -command $cmd}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tdefault\ \{
puts $fp {	    error "undefined submenu in tkj-select-submenu: $code"}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp #
puts $fp {# chooser application}
puts $fp #
puts $fp proc\ tkj-chooser\ \{w\}\ \{
puts $fp {    tkj-empty $w}
puts $fp {    wm title $w {Tk Kanji Chooser}}
puts $fp {    set n 0}
puts $fp \ \ \ \ foreach\ a\ \[tkj-applications\]\ \{
puts $fp {	pack [button $w.b[incr n] -text $a -command [list $a $w]] -side top -fill x}
puts $fp \ \ \ \ \}
puts $fp {    pack [button $w.b[incr n] -text tkj-quit -command tkj-quit] -side top -fill x}
puts $fp {    pack [label $w.l -textvar tkkanji(status)]}
puts -nonewline $fp \}
close $fp
set restore [file join TkKanji tkj tkj-default.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp #
puts $fp {# list the available tkj applications}
puts $fp #
puts $fp proc\ tkj-applications\ \{\}\ \{
puts $fp {    list tkj-configure tkj-chooser kanji-browse kanji-tration kanji-multi-choice kanji-self-test}
puts $fp \}
puts $fp #
puts $fp {# default values}
puts $fp #
puts $fp proc\ tkj-default\ \{var\}\ \{
puts $fp \ \ \ \ switch\ \$var\ \{
puts $fp {	index { return {tkj-get-index F} }}
puts $fp {	select { return {tkj-get-class G1} }}
puts $fp {	application { return {tkj-chooser} }}
puts $fp {	default { error "unknown var in tkj-default: $var" }}
puts $fp \ \ \ \ \}
puts $fp \}
close $fp
set restore [file join TkKanji tkj tkj-browse.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp #
puts $fp {# display record in raw form}
puts $fp #
puts $fp proc\ tkj-browse-record\ \{k\ title\}\ \{
puts $fp {    set w [tkj-toplevel $title]}
puts $fp {}
puts $fp {    grid [frame $w.x -border 5 -relief ridge] -row 0 -column 0 -rowspan 2 -sticky ns}
puts $fp {    grid [label $w.k -font [tkj-font 48] -text $k -border 5 -relief ridge] -row 0 -column 1 -sticky nsew}
puts $fp {    grid [frame $w.d] -row 0 -column 2 -rowspan 2 -sticky ns}
puts $fp {    grid [frame $w.r -border 5 -relief ridge] -row 1 -column 1 -sticky ns}
puts $fp {}
puts $fp \ \ \ \ foreach\ \{name\ value\}\ \[get-record\ \$k\]\ \{
puts $fp {	lappend keep($name) $value}
puts $fp \ \ \ \ \}
puts $fp {    # }
puts $fp \ \ \ \ foreach\ \{name\ row\}\ \{
puts $fp {	B 0}
puts $fp {	C 1}
puts $fp {	S 2}
puts $fp {	F 3}
puts $fp {	G 4}
puts $fp {	P 5}
puts $fp {	I 6}
puts $fp {	Q 7}
puts $fp \ \ \ \ \}\ \{
puts $fp \tif\ \{\[info\ exists\ keep(\$name)\]\}\ \{
puts $fp {	    set win $w.r.[string tolower $name]}
puts $fp {	    grid [label $win -text "[tkj-get-field-label $name]: [join $keep($name) ,]"] -row $row -sticky w}
puts $fp \t\ \ \ \ if\ \{\[string\ compare\ \$name\ G\]\ ==\ 0\}\ \{
puts $fp {		$win configure -text "[tkj-get-field-value-label $name $keep($name)]"}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ foreach\ \{name\ row\}\ \{
puts $fp {	MN 0}
puts $fp {	MP 1}
puts $fp {	U 2}
puts $fp {	J0 3}
puts $fp {	J1 3}
puts $fp {	N 4}
puts $fp {	V 5}
puts $fp {	H 6}
puts $fp {	DR 7}
puts $fp {	E 8}
puts $fp {	IN 9}
puts $fp {	K 10}
puts $fp {	L 11}
puts $fp {	O 12}
puts $fp \ \ \ \ \}\ \{
puts $fp \tif\ \{\[info\ exists\ keep(\$name)\]\}\ \{
puts $fp {	    set win $w.x.[string tolower $name]}
puts $fp {	    grid [label $win -text "[tkj-get-field-label $name]: [join $keep($name) ,]"] -row $row -sticky w}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    set nx 12}
puts $fp \ \ \ \ foreach\ \{name\}\ \{X\ Z\}\ \{
puts $fp \tif\ \{\[info\ exists\ keep(\$name)\]\}\ \{
puts $fp \t\ \ \ \ foreach\ value\ \$keep(\$name)\ \{
puts $fp {		incr nx}
puts $fp {		grid [label $w.x.x$nx -text "[tkj-get-field-label $name]: $value"] -row $nx -sticky w}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    set nd 0}
puts $fp \ \ \ \ foreach\ name\ \{ON\ ONT1\ ONT2\ KUN\ KUNT1\ KUNT2\}\ \{
puts $fp \tif\ \{\[info\ exists\ keep(\$name)\]\}\ \{
puts $fp {	    grid [frame $w.d.f$nd -border 5 -relief ridge] -row $nd -sticky ew}
puts $fp {	    set nv 0}
puts $fp {	    #grid [label $w.d.f$nd.l$nv -text [tkj-get-field-label $name]] -row $nv -sticky ew}
puts $fp {	    #incr nv}
puts $fp \t\ \ \ \ foreach\ value\ \$keep(\$name)\ \{
puts $fp {		grid [label $w.d.f$nd.l$nv -font [tkj-font 16] -text $value] -row $nv -sticky w}
puts $fp {		incr nv}
puts $fp \t\ \ \ \ \}
puts $fp {	    incr nd}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ foreach\ name\ \{ENG\ Y\ W\}\ \{
puts $fp \tif\ \{\[info\ exists\ keep(\$name)\]\}\ \{
puts $fp {	    grid [frame $w.d.f$nd -border 5 -relief ridge] -row $nd -sticky ew}
puts $fp {	    set nv 0}
puts $fp {	    #grid [label $w.d.f$nd.l$nv -text [tkj-get-field-label $name]] -row $nv -sticky ew}
puts $fp {	    #incr nv}
puts $fp \t\ \ \ \ foreach\ value\ \$keep(\$name)\ \{
puts $fp {		grid [label $w.d.f$nd.l$nv -text $value] -row $nv -sticky w}
puts $fp {		incr nv}
puts $fp \t\ \ \ \ \}
puts $fp {	    incr nd}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp #
puts $fp {# tkj-browse-select - implement the brower pick}
puts $fp #
puts $fp proc\ tkj-browse-select\ \{w\}\ \{
puts $fp {    upvar \#0 $w data}
puts $fp {    tkj-browse-record [lindex $data(listbox) [$w.l curselection]] {Tk Kanji}}
puts $fp \}
puts $fp #
puts $fp {# tkj-browse-reload - fill the main selector with some index/select set}
puts $fp #
puts $fp proc\ tkj-browse-reload\ \{w\}\ \{
puts $fp {    global kanji}
puts $fp {    upvar \#0 $w data}
puts $fp {    }
puts $fp {    tkj-status "reload select $data(select) index $data(index)"}
puts $fp {    $w.l delete 0 end}
puts $fp {    set data(listbox) {}}
puts $fp \ \ \ \ foreach\ k\ \[eval\ \$data(select)\]\ \{
puts $fp {	set select($k) {}}
puts $fp \ \ \ \ \}
puts $fp \ \ \ \ foreach\ k\ \[eval\ \$data(index)\]\ \{
puts $fp \tif\ \{\[info\ exists\ select(\$k)\]\}\ \{
puts $fp {	    lappend data(listbox) $k}
puts $fp {	    $w.l insert end $k}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp {    bind $w.l <Double-ButtonPress-1> [list tkj-browse-select $w]}
puts $fp {    tkj-status ""}
puts $fp \}
puts $fp #
puts $fp {# browse a subset of the dictionaries loaded}
puts $fp #
puts $fp proc\ kanji-browse\ \{w\}\ \{
puts $fp {    upvar \#0 $w data}
puts $fp {    wm title $w {Tk Kanji}}
puts $fp {    tkj-empty $w}
puts $fp {    # menu frame, listbox, scrollbar, and status}
puts $fp {    grid [frame $w.m] -row 0 -column 0 -columnspan 2 -sticky ew}
puts $fp {    grid [listbox $w.l -font [tkj-font 24] -yscrollcommand [list $w.y set]] -row 1 -column 0 -sticky nsew}
puts $fp {    grid [scrollbar $w.y -command [list $w.l yview]] -row 1 -column 1 -sticky ns}
puts $fp {    grid [label $w.s -textvar tkkanji(status)] -row 2 -columnspan 2 -sticky ew}
puts $fp {    grid columnconfigure $w 0 -weight 1}
puts $fp {    grid columnconfigure $w 1 -weight 0}
puts $fp {    grid rowconfigure $w 0 -weight 0}
puts $fp {    grid rowconfigure $w 1 -weight 1}
puts $fp {    # file menu}
puts $fp {    pack [tkj-file-menu $w.m.f] -side left}
puts $fp {    # application menu}
puts $fp {    pack [tkj-application-menu $w.m.a $w] -side left}
puts $fp {    # index menu}
puts $fp {    pack [tkj-index-menu $w.m.i ${w}(index) [list tkj-browse-reload $w]] -side left}
puts $fp {    # select menu}
puts $fp {    pack [tkj-select-menu $w.m.s ${w}(select) [list tkj-browse-reload $w]] -side left}
puts $fp {    # listbox}
puts $fp {    tkj-browse-reload $w}
puts $fp \}
close $fp
set restore [file join TkKanji tkj tkj-copyright.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp proc\ tkj-copyright\ \{\}\ \{
puts $fp \ \ \ \ return\ \{Copyright\ (c)\ 1999\ by\ Roger\ E.\ Critchlow\ Jr,\ Santa\ Fe,\ NM,\ USA,
puts $fp {rec@elf.org -- http://elf.org}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp proc\ gpl-preamble\ \{\}\ \{
puts $fp \ \ \ \ return\ \{
puts $fp {		    GNU GENERAL PUBLIC LICENSE}
puts $fp {		       Version 2, June 1991}
puts $fp {}
puts $fp { Copyright (C) 1989, 1991 Free Software Foundation, Inc.}
puts $fp {                       59 Temple Place, Suite 330, Boston, MA  02111-1307  USA}
puts $fp { Everyone is permitted to copy and distribute verbatim copies}
puts $fp { of this license document, but changing it is not allowed.}
puts $fp {}
puts $fp {			    Preamble}
puts $fp {}
puts $fp {  The licenses for most software are designed to take away your}
puts $fp {freedom to share and change it.  By contrast, the GNU General Public}
puts $fp {License is intended to guarantee your freedom to share and change free}
puts $fp {software--to make sure the software is free for all its users.  This}
puts $fp {General Public License applies to most of the Free Software}
puts $fp {Foundation's software and to any other program whose authors commit to}
puts $fp {using it.  (Some other Free Software Foundation software is covered by}
puts $fp {the GNU Library General Public License instead.)  You can apply it to}
puts $fp {your programs, too.}
puts $fp {}
puts $fp {  When we speak of free software, we are referring to freedom, not}
puts $fp {price.  Our General Public Licenses are designed to make sure that you}
puts $fp {have the freedom to distribute copies of free software (and charge for}
puts $fp {this service if you wish), that you receive source code or can get it}
puts $fp {if you want it, that you can change the software or use pieces of it}
puts $fp {in new free programs; and that you know you can do these things.}
puts $fp {}
puts $fp {  To protect your rights, we need to make restrictions that forbid}
puts $fp {anyone to deny you these rights or to ask you to surrender the rights.}
puts $fp {These restrictions translate to certain responsibilities for you if you}
puts $fp {distribute copies of the software, or if you modify it.}
puts $fp {}
puts $fp {  For example, if you distribute copies of such a program, whether}
puts $fp {gratis or for a fee, you must give the recipients all the rights that}
puts $fp {you have.  You must make sure that they, too, receive or can get the}
puts $fp {source code.  And you must show them these terms so they know their}
puts $fp rights.
puts $fp {}
puts $fp {  We protect your rights with two steps: (1) copyright the software, and}
puts $fp {(2) offer you this license which gives you legal permission to copy,}
puts $fp {distribute and/or modify the software.}
puts $fp {}
puts $fp {  Also, for each author's protection and ours, we want to make certain}
puts $fp {that everyone understands that there is no warranty for this free}
puts $fp {software.  If the software is modified by someone else and passed on, we}
puts $fp {want its recipients to know that what they have is not the original, so}
puts $fp {that any problems introduced by others will not reflect on the original}
puts $fp {authors' reputations.}
puts $fp {}
puts $fp {  Finally, any free program is threatened constantly by software}
puts $fp {patents.  We wish to avoid the danger that redistributors of a free}
puts $fp {program will individually obtain patent licenses, in effect making the}
puts $fp {program proprietary.  To prevent this, we have made it clear that any}
puts $fp {patent must be licensed for everyone's free use or not licensed at all.}
puts $fp {}
puts $fp {  The precise terms and conditions for copying, distribution and}
puts $fp {modification follow.}
puts $fp \}
puts $fp \}
puts $fp proc\ gpl-terms\ \{\}\ \{
puts $fp \ \ \ \ return\ \{
puts $fp {		    GNU GENERAL PUBLIC LICENSE}
puts $fp {   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION}
puts $fp {}
puts $fp {  0. This License applies to any program or other work which contains}
puts $fp {a notice placed by the copyright holder saying it may be distributed}
puts $fp {under the terms of this General Public License.  The "Program", below,}
puts $fp {refers to any such program or work, and a "work based on the Program"}
puts $fp {means either the Program or any derivative work under copyright law:}
puts $fp {that is to say, a work containing the Program or a portion of it,}
puts $fp {either verbatim or with modifications and/or translated into another}
puts $fp {language.  (Hereinafter, translation is included without limitation in}
puts $fp {the term "modification".)  Each licensee is addressed as "you".}
puts $fp {}
puts $fp {Activities other than copying, distribution and modification are not}
puts $fp {covered by this License; they are outside its scope.  The act of}
puts $fp {running the Program is not restricted, and the output from the Program}
puts $fp {is covered only if its contents constitute a work based on the}
puts $fp {Program (independent of having been made by running the Program).}
puts $fp {Whether that is true depends on what the Program does.}
puts $fp {}
puts $fp {  1. You may copy and distribute verbatim copies of the Program's}
puts $fp {source code as you receive it, in any medium, provided that you}
puts $fp {conspicuously and appropriately publish on each copy an appropriate}
puts $fp {copyright notice and disclaimer of warranty; keep intact all the}
puts $fp {notices that refer to this License and to the absence of any warranty;}
puts $fp {and give any other recipients of the Program a copy of this License}
puts $fp {along with the Program.}
puts $fp {}
puts $fp {You may charge a fee for the physical act of transferring a copy, and}
puts $fp {you may at your option offer warranty protection in exchange for a fee.}
puts $fp {}
puts $fp {  2. You may modify your copy or copies of the Program or any portion}
puts $fp {of it, thus forming a work based on the Program, and copy and}
puts $fp {distribute such modifications or work under the terms of Section 1}
puts $fp {above, provided that you also meet all of these conditions:}
puts $fp {}
puts $fp {    a) You must cause the modified files to carry prominent notices}
puts $fp {    stating that you changed the files and the date of any change.}
puts $fp {}
puts $fp {    b) You must cause any work that you distribute or publish, that in}
puts $fp {    whole or in part contains or is derived from the Program or any}
puts $fp {    part thereof, to be licensed as a whole at no charge to all third}
puts $fp {    parties under the terms of this License.}
puts $fp {}
puts $fp {    c) If the modified program normally reads commands interactively}
puts $fp {    when run, you must cause it, when started running for such}
puts $fp {    interactive use in the most ordinary way, to print or display an}
puts $fp {    announcement including an appropriate copyright notice and a}
puts $fp {    notice that there is no warranty (or else, saying that you provide}
puts $fp {    a warranty) and that users may redistribute the program under}
puts $fp {    these conditions, and telling the user how to view a copy of this}
puts $fp {    License.  (Exception: if the Program itself is interactive but}
puts $fp {    does not normally print such an announcement, your work based on}
puts $fp {    the Program is not required to print an announcement.)}
puts $fp {}
puts $fp {These requirements apply to the modified work as a whole.  If}
puts $fp {identifiable sections of that work are not derived from the Program,}
puts $fp {and can be reasonably considered independent and separate works in}
puts $fp {themselves, then this License, and its terms, do not apply to those}
puts $fp {sections when you distribute them as separate works.  But when you}
puts $fp {distribute the same sections as part of a whole which is a work based}
puts $fp {on the Program, the distribution of the whole must be on the terms of}
puts $fp {this License, whose permissions for other licensees extend to the}
puts $fp {entire whole, and thus to each and every part regardless of who wrote it.}
puts $fp {}
puts $fp {Thus, it is not the intent of this section to claim rights or contest}
puts $fp {your rights to work written entirely by you; rather, the intent is to}
puts $fp {exercise the right to control the distribution of derivative or}
puts $fp {collective works based on the Program.}
puts $fp {}
puts $fp {In addition, mere aggregation of another work not based on the Program}
puts $fp {with the Program (or with a work based on the Program) on a volume of}
puts $fp {a storage or distribution medium does not bring the other work under}
puts $fp {the scope of this License.}
puts $fp {}
puts $fp {  3. You may copy and distribute the Program (or a work based on it,}
puts $fp {under Section 2) in object code or executable form under the terms of}
puts $fp {Sections 1 and 2 above provided that you also do one of the following:}
puts $fp {}
puts $fp {    a) Accompany it with the complete corresponding machine-readable}
puts $fp {    source code, which must be distributed under the terms of Sections}
puts $fp {    1 and 2 above on a medium customarily used for software interchange; or,}
puts $fp {}
puts $fp {    b) Accompany it with a written offer, valid for at least three}
puts $fp {    years, to give any third party, for a charge no more than your}
puts $fp {    cost of physically performing source distribution, a complete}
puts $fp {    machine-readable copy of the corresponding source code, to be}
puts $fp {    distributed under the terms of Sections 1 and 2 above on a medium}
puts $fp {    customarily used for software interchange; or,}
puts $fp {}
puts $fp {    c) Accompany it with the information you received as to the offer}
puts $fp {    to distribute corresponding source code.  (This alternative is}
puts $fp {    allowed only for noncommercial distribution and only if you}
puts $fp {    received the program in object code or executable form with such}
puts $fp {    an offer, in accord with Subsection b above.)}
puts $fp {}
puts $fp {The source code for a work means the preferred form of the work for}
puts $fp {making modifications to it.  For an executable work, complete source}
puts $fp {code means all the source code for all modules it contains, plus any}
puts $fp {associated interface definition files, plus the scripts used to}
puts $fp {control compilation and installation of the executable.  However, as a}
puts $fp {special exception, the source code distributed need not include}
puts $fp {anything that is normally distributed (in either source or binary}
puts $fp {form) with the major components (compiler, kernel, and so on) of the}
puts $fp {operating system on which the executable runs, unless that component}
puts $fp {itself accompanies the executable.}
puts $fp {}
puts $fp {If distribution of executable or object code is made by offering}
puts $fp {access to copy from a designated place, then offering equivalent}
puts $fp {access to copy the source code from the same place counts as}
puts $fp {distribution of the source code, even though third parties are not}
puts $fp {compelled to copy the source along with the object code.}
puts $fp {}
puts $fp {  4. You may not copy, modify, sublicense, or distribute the Program}
puts $fp {except as expressly provided under this License.  Any attempt}
puts $fp {otherwise to copy, modify, sublicense or distribute the Program is}
puts $fp {void, and will automatically terminate your rights under this License.}
puts $fp {However, parties who have received copies, or rights, from you under}
puts $fp {this License will not have their licenses terminated so long as such}
puts $fp {parties remain in full compliance.}
puts $fp {}
puts $fp {  5. You are not required to accept this License, since you have not}
puts $fp {signed it.  However, nothing else grants you permission to modify or}
puts $fp {distribute the Program or its derivative works.  These actions are}
puts $fp {prohibited by law if you do not accept this License.  Therefore, by}
puts $fp {modifying or distributing the Program (or any work based on the}
puts $fp {Program), you indicate your acceptance of this License to do so, and}
puts $fp {all its terms and conditions for copying, distributing or modifying}
puts $fp {the Program or works based on it.}
puts $fp {}
puts $fp {  6. Each time you redistribute the Program (or any work based on the}
puts $fp {Program), the recipient automatically receives a license from the}
puts $fp {original licensor to copy, distribute or modify the Program subject to}
puts $fp {these terms and conditions.  You may not impose any further}
puts $fp {restrictions on the recipients' exercise of the rights granted herein.}
puts $fp {You are not responsible for enforcing compliance by third parties to}
puts $fp {this License.}
puts $fp {}
puts $fp {  7. If, as a consequence of a court judgment or allegation of patent}
puts $fp {infringement or for any other reason (not limited to patent issues),}
puts $fp {conditions are imposed on you (whether by court order, agreement or}
puts $fp {otherwise) that contradict the conditions of this License, they do not}
puts $fp {excuse you from the conditions of this License.  If you cannot}
puts $fp {distribute so as to satisfy simultaneously your obligations under this}
puts $fp {License and any other pertinent obligations, then as a consequence you}
puts $fp {may not distribute the Program at all.  For example, if a patent}
puts $fp {license would not permit royalty-free redistribution of the Program by}
puts $fp {all those who receive copies directly or indirectly through you, then}
puts $fp {the only way you could satisfy both it and this License would be to}
puts $fp {refrain entirely from distribution of the Program.}
puts $fp {}
puts $fp {If any portion of this section is held invalid or unenforceable under}
puts $fp {any particular circumstance, the balance of the section is intended to}
puts $fp {apply and the section as a whole is intended to apply in other}
puts $fp circumstances.
puts $fp {}
puts $fp {It is not the purpose of this section to induce you to infringe any}
puts $fp {patents or other property right claims or to contest validity of any}
puts $fp {such claims; this section has the sole purpose of protecting the}
puts $fp {integrity of the free software distribution system, which is}
puts $fp {implemented by public license practices.  Many people have made}
puts $fp {generous contributions to the wide range of software distributed}
puts $fp {through that system in reliance on consistent application of that}
puts $fp {system; it is up to the author/donor to decide if he or she is willing}
puts $fp {to distribute software through any other system and a licensee cannot}
puts $fp {impose that choice.}
puts $fp {}
puts $fp {This section is intended to make thoroughly clear what is believed to}
puts $fp {be a consequence of the rest of this License.}
puts $fp {}
puts $fp {  8. If the distribution and/or use of the Program is restricted in}
puts $fp {certain countries either by patents or by copyrighted interfaces, the}
puts $fp {original copyright holder who places the Program under this License}
puts $fp {may add an explicit geographical distribution limitation excluding}
puts $fp {those countries, so that distribution is permitted only in or among}
puts $fp {countries not thus excluded.  In such case, this License incorporates}
puts $fp {the limitation as if written in the body of this License.}
puts $fp {}
puts $fp {  9. The Free Software Foundation may publish revised and/or new versions}
puts $fp {of the General Public License from time to time.  Such new versions will}
puts $fp {be similar in spirit to the present version, but may differ in detail to}
puts $fp {address new problems or concerns.}
puts $fp {}
puts $fp {Each version is given a distinguishing version number.  If the Program}
puts $fp {specifies a version number of this License which applies to it and "any}
puts $fp {later version", you have the option of following the terms and conditions}
puts $fp {either of that version or of any later version published by the Free}
puts $fp {Software Foundation.  If the Program does not specify a version number of}
puts $fp {this License, you may choose any version ever published by the Free Software}
puts $fp Foundation.
puts $fp {}
puts $fp {  10. If you wish to incorporate parts of the Program into other free}
puts $fp {programs whose distribution conditions are different, write to the author}
puts $fp {to ask for permission.  For software which is copyrighted by the Free}
puts $fp {Software Foundation, write to the Free Software Foundation; we sometimes}
puts $fp {make exceptions for this.  Our decision will be guided by the two goals}
puts $fp {of preserving the free status of all derivatives of our free software and}
puts $fp {of promoting the sharing and reuse of software generally.}
puts $fp \}
puts $fp \}
puts $fp proc\ gpl-warranty\ \{\}\ \{
puts $fp \ \ \ \ return\ \{
puts $fp {			    NO WARRANTY}
puts $fp {}
puts $fp {  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY}
puts $fp {FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN}
puts $fp {OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES}
puts $fp {PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED}
puts $fp {OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF}
puts $fp {MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS}
puts $fp {TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE}
puts $fp {PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,}
puts $fp {REPAIR OR CORRECTION.}
puts $fp {}
puts $fp {  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING}
puts $fp {WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR}
puts $fp {REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,}
puts $fp {INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING}
puts $fp {OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED}
puts $fp {TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY}
puts $fp {YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER}
puts $fp {PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE}
puts $fp {POSSIBILITY OF SUCH DAMAGES.}
puts $fp \}
puts $fp \}
puts $fp proc\ gpl-addendum\ \{\}\ \{
puts $fp \ \ \ \ return\ \{
puts $fp {		     END OF TERMS AND CONDITIONS}
puts $fp {}
puts $fp {	    How to Apply These Terms to Your New Programs}
puts $fp {}
puts $fp {  If you develop a new program, and you want it to be of the greatest}
puts $fp {possible use to the public, the best way to achieve this is to make it}
puts $fp {free software which everyone can redistribute and change under these terms.}
puts $fp {}
puts $fp {  To do so, attach the following notices to the program.  It is safest}
puts $fp {to attach them to the start of each source file to most effectively}
puts $fp {convey the exclusion of warranty; and each file should have at least}
puts $fp {the "copyright" line and a pointer to where the full notice is found.}
puts $fp {}
puts $fp {    <one line to give the program's name and a brief idea of what it does.>}
puts $fp {    Copyright (C) 19yy  <name of author>}
puts $fp {}
puts $fp {    This program is free software; you can redistribute it and/or modify}
puts $fp {    it under the terms of the GNU General Public License as published by}
puts $fp {    the Free Software Foundation; either version 2 of the License, or}
puts $fp {    (at your option) any later version.}
puts $fp {}
puts $fp {    This program is distributed in the hope that it will be useful,}
puts $fp {    but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {    GNU General Public License for more details.}
puts $fp {}
puts $fp {    You should have received a copy of the GNU General Public License}
puts $fp {    along with this program; if not, write to the Free Software}
puts $fp {    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA}
puts $fp {}
puts $fp {}
puts $fp {Also add information on how to contact you by electronic and paper mail.}
puts $fp {}
puts $fp {If the program is interactive, make it output a short notice like this}
puts $fp {when it starts in an interactive mode:}
puts $fp {}
puts $fp {    Gnomovision version 69, Copyright (C) 19yy name of author}
puts $fp {    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.}
puts $fp {    This is free software, and you are welcome to redistribute it}
puts $fp {    under certain conditions; type `show c' for details.}
puts $fp {}
puts $fp {The hypothetical commands `show w' and `show c' should show the appropriate}
puts $fp {parts of the General Public License.  Of course, the commands you use may}
puts $fp {be called something other than `show w' and `show c'; they could even be}
puts $fp {mouse-clicks or menu items--whatever suits your program.}
puts $fp {}
puts $fp {You should also get your employer (if you work as a programmer) or your}
puts $fp {school, if any, to sign a "copyright disclaimer" for the program, if}
puts $fp {necessary.  Here is a sample; alter the names:}
puts $fp {}
puts $fp {  Yoyodyne, Inc., hereby disclaims all copyright interest in the program}
puts $fp {  `Gnomovision' (which makes passes at compilers) written by James Hacker.}
puts $fp {}
puts $fp {  <signature of Ty Coon>, 1 April 1989}
puts $fp {  Ty Coon, President of Vice}
puts $fp {}
puts $fp {This General Public License does not permit incorporating your program into}
puts $fp {proprietary programs.  If your program is a subroutine library, you may}
puts $fp {consider it more useful to permit linking proprietary applications with the}
puts $fp {library.  If this is what you want to do, use the GNU Library General}
puts $fp {Public License instead of this License.}
puts $fp \}
puts $fp \}
puts $fp proc\ gpl-license\ \{\}\ \{
puts $fp {    return [gpl-preamble]\n[gpl-terms]\n[gpl-warranty]\n[gpl-addendum]}
puts $fp \}
close $fp
set restore [file join TkKanji tkj tkj-tration.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp {}
puts $fp #
puts $fp {# play concentration}
puts $fp #
puts $fp proc\ concentration\ \{w\ op\}\ \{
puts $fp {    upvar \#0 $w data}
puts $fp {    set f concentration}
puts $fp \ \ \ \ switch\ -glob\ \$op\ \{
puts $fp \tsetup\ \{
puts $fp {	    wm title $w {Tk Kanji-tration}}
puts $fp {	    catch {unset data}}
puts $fp {	    set data(delay) 2000}
puts $fp {	    set data(size) 4}
puts $fp {	    set data(select) [tkj-default select]}
puts $fp {}
puts $fp {	    pack [frame $w.m] -side top -fill x}
puts $fp {	    pack [menubutton $w.m.o -text {options} -menu $w.m.o.m] -side left}
puts $fp {	    menu $w.m.o.m -tearoff no}
puts $fp {	    $w.m.o.m add radiobutton -label {4x4 Game} -var ${w}(size) -value 4 -command [list $f $w resize]}
puts $fp {	    $w.m.o.m add radiobutton -label {6x6 Game} -var ${w}(size) -value 6 -command [list $f $w resize]}
puts $fp {	    $w.m.o.m add separator}
puts $fp \t\ \ \ \ foreach\ sec\ \{1\ 2\ 5\}\ \{
puts $fp {		$w.m.o.m add radiobutton -label "Delay $sec sec" -variable ${w}(delay) -value ${sec}000}
puts $fp \t\ \ \ \ \}
puts $fp {	    $w.m.o.m add separator}
puts $fp {	    $w.m.o.m add command -label {Done} -command [list tkj-chooser $w]}
puts $fp {	    pack [tkj-select-menu $w.m.s ${w}(select) [list $f $w start]] -side left}
puts $fp {	    pack [button $w.m.n -text {new game} -command [list $f $w start]] -side left}
puts $fp {	    pack [frame $w.g] -side top}
puts $fp {	    pack [label $w.status -textvar tkkanji(status)] -side top -fill x}
puts $fp {	    $f $w resize}
puts $fp \t\}
puts $fp \tresize\ \{
puts $fp {	    tkj-empty $w.g}
puts $fp {	    set data(rows) {}}
puts $fp {	    set data(cols) {}}
puts $fp \t\ \ \ \ for\ \{set\ i\ 0\}\ \{\$i\ <\ \$data(size)\}\ \{incr\ i\}\ \{
puts $fp {		lappend data(rows) $i}
puts $fp {		lappend data(cols) $i}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ foreach\ i\ \$data(rows)\ \{
puts $fp \t\tforeach\ j\ \$data(cols)\ \{
puts $fp \t\t\ \ \ \ grid\ \[button\ \$w.g.b\$i\$j\ -text\ \{\}\ -font\ \[tkj-font\ 48\]\ -width\ 2\ \\
puts $fp \t\t\t\ \ \ \ \ \ -command\ \[list\ \$f\ \$w\ \[list\ show\ \$i\ \$j\]\]\]\ \\
puts $fp {			-in $w.g -row $i -column $j -sticky nsew}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp {	    set data(normal-bg) [$w.g.b$i$j cget -bg]}
puts $fp {	    $f $w start}
puts $fp \t\}
puts $fp \tstart\ \{
puts $fp {	    set data(picked) {}}
puts $fp \t\ \ \ \ foreach\ i\ \$data(rows)\ \{
puts $fp \t\tforeach\ j\ \$data(cols)\ \{
puts $fp {		    $w.g.b$i$j configure -text {} -state normal -bg $data(normal-bg)}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp {	    set r [expr {-1+$data(size)*$data(size)/2}]}
puts $fp {	    set data(kanji) [lrange [shuffle [eval $data(select)]] 0 $r]}
puts $fp {	    set data(kanji) [shuffle [concat $data(kanji) $data(kanji)]]}
puts $fp \t\}
puts $fp \tshow*\ \{
puts $fp {	    foreach {show i j} $op break}
puts $fp \t\ \ \ \ switch\ \ \[llength\ \$data(picked)\]\ \{
puts $fp \t\t0\ \{
puts $fp {		    lappend data(picked) $i $j}
puts $fp {		    $w.g.b$i$j configure -text [lindex $data(kanji) [expr {$i*$data(size)+$j}]]}
puts $fp {		    $w.g.b$i$j configure -state disabled}
puts $fp \t\t\}
puts $fp \t\t2\ \{
puts $fp {		    lappend data(picked) $i $j}
puts $fp {		    $w.g.b$i$j configure -text [lindex $data(kanji) [expr {$i*$data(size)+$j}]]}
puts $fp {		    $w.g.b$i$j configure -state disabled}
puts $fp {		    foreach {pi pj} $data(picked) break}
puts $fp \t\t\ \ \ \ if\ \{\[string\ compare\ \[\$w.g.b\$pi\$pj\ cget\ -text\]\ \[\$w.g.b\$i\$j\ cget\ -text\]\]\ ==\ 0\}\ \{
puts $fp {			$w.g.b$pi$pj configure -bg white}
puts $fp {			$w.g.b$i$j configure -bg white}
puts $fp {			set data(picked) {}}
puts $fp \t\t\ \ \ \ \}\ else\ \{
puts $fp {			set data(timer) [after $data(delay) [list $f $w clear]]}
puts $fp \t\t\ \ \ \ \}
puts $fp \t\t\}
puts $fp \t\tdefault\ \{
puts $fp {		    catch {after cancel $data(timer)}}
puts $fp {		    $f $w clear}
puts $fp {		    $f $w $op}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \tclear\ \{
puts $fp \t\ \ \ \ foreach\ \{i\ j\}\ \$data(picked)\ \{
puts $fp {		$w.g.b$i$j configure -text {}}
puts $fp {		$w.g.b$i$j configure -state normal}
puts $fp \t\ \ \ \ \}
puts $fp {	    set data(picked) {}}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp {}
puts $fp proc\ kanji-tration\ \{w\}\ \{
puts $fp {    tkj-empty $w}
puts $fp {    concentration $w setup}
puts -nonewline $fp \}
close $fp
set restore [file join TkKanji tkj tkj-self-test.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp #
puts $fp {# given a keyword, test yourself by writing the kanji}
puts $fp #
puts $fp proc\ keyword-show-kanji\ \{w\ op\}\ \{
puts $fp {    upvar \#0 $w data}
puts $fp {    set f keyword-show-kanji}
puts $fp \ \ \ \ switch\ \$op\ \{
puts $fp \tsetup\ \{
puts $fp {	    wm title $w {Tk Kanji Self Test}}
puts $fp {	    catch {unset data}}
puts $fp {	    set data(select) [tkj-default select]}
puts $fp {	    set data(choose) {lindex [tkj-get-field [lindex $data(kanji) $data(i)] ENG] 0}}
puts $fp {}
puts $fp {	    pack [frame $w.m] -side top -fill x}
puts $fp {	    pack [menubutton $w.m.o -text {options} -menu $w.m.o.m] -side left}
puts $fp {	    menu $w.m.o.m -tearoff no}
puts $fp {	    $w.m.o.m add command -label {Clear score} -command [list $f $w clear]}
puts $fp {	    $w.m.o.m add command -label {Reshuffle list} -command [list $f $w shuffle]}
puts $fp {	    $w.m.o.m add separator}
puts $fp \t\ \ \ \ \$w.m.o.m\ add\ radiobutton\ -label\ \{Use\ first\ meaning\}\ -var\ \$\{w\}(choose)\ \\
puts $fp {		-value {lindex [tkj-get-field [lindex $data(kanji) $data(i)] ENG] 0}}
puts $fp \t\ \ \ \ \$w.m.o.m\ add\ radiobutton\ -label\ \{Use\ any\ meaning\}\ -var\ \$\{w\}(choose)\ \\
puts $fp {		-value {choose-one [tkj-get-field [lindex $data(kanji) $data(i)] ENG]}}
puts $fp {	    $w.m.o.m add separator}
puts $fp {	    $w.m.o.m add command -label {Done} -command [list tkj-chooser $w]}
puts $fp {	    pack [frame $w.g] -side top}
puts $fp {	    grid [label $w.keyword -border 10] -in $w.g -row 0 -column 0 -columnspan 12}
puts $fp {	    grid [canvas $w.draw -height 70 -width 70 -border 5 -relief ridge] -in $w.g -row 1 -column 0 -columnspan 6}
puts $fp {	    grid [label $w.kanji -font [tkj-font 48] -border 5] -in $w.g -row 1 -column 6 -columnspan 6}
puts $fp {	    grid [button $w.correct -text Right! -command  [list $f $w correct]] -in $w.g -row 2 -column 0 -columnspan 4}
puts $fp {	    grid [button $w.show -text Show -command [list $f $w show]] -in $w.g -row 2 -column 4 -columnspan 4}
puts $fp {	    grid [button $w.wrong -text Wrong! -command [list $f $w wrong]] -in $w.g -row 2 -column 8 -columnspan 4}
puts $fp {	    grid [label $w.score -textvar ${w}(score)] -in $w.g -row 3 -column 0 -columnspan 12}
puts $fp {}
puts $fp {	    pack [tkj-select-menu $w.m.s ${w}(select) [list $f $w start]] -side left}
puts $fp {}
puts $fp \t\ \ \ \ bind\ \$w.draw\ <ButtonPress-1>\ \{
puts $fp {		set %W(line) [list %W coords [eval %W create line %x %y %x %y -width 2] %x %y]}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ bind\ \$w.draw\ <B1-Motion>\ \{
puts $fp {		eval [lappend %W(line) %x %y]}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ bind\ \$w.draw\ <ButtonRelease-1>\ \{
puts $fp {		unset %W(line)}
puts $fp \t\ \ \ \ \}
puts $fp {	    $f $w start}
puts $fp \t\}
puts $fp \tstart\ \{
puts $fp {	    set data(kanji) [shuffle [eval $data(select)]]}
puts $fp {	    set data(n) [llength $data(kanji)]}
puts $fp {	    set data(i) -1}
puts $fp {	    set data(hits) 0}
puts $fp {	    set data(tries) 0}
puts $fp {	    $f $w next}
puts $fp \t\}
puts $fp \tcorrect\ \{
puts $fp {	    incr data(hits)}
puts $fp {	    incr data(tries)}
puts $fp {	    $f $w next}
puts $fp \t\}
puts $fp \twrong\ \{
puts $fp {	    incr data(tries)}
puts $fp {	    $f $w next}
puts $fp \t\}
puts $fp \tnext\ \{
puts $fp {	    incr data(i)}
puts $fp \t\ \ \ \ while\ \{\$data(i)\ >=\ \$data(n)\}\ \{
puts $fp {		set data(kanji) [shuffle $data(kanji)]}
puts $fp {		incr data(i) [expr {-$data(n)}]}
puts $fp \t\ \ \ \ \}
puts $fp {	    $f $w set}
puts $fp \t\}
puts $fp \tshuffle\ \{
puts $fp {	    set data(kanji) [shuffle $data(kanji)]}
puts $fp {	    $f $w set}
puts $fp \t\}
puts $fp \tset\ \{
puts $fp {	    $w.keyword configure -text [eval $data(choose)]}
puts $fp {	    $w.kanji configure -text {}}
puts $fp {	    $w.draw delete all}
puts $fp {	    set data(score) $data(hits)/$data(tries)}
puts $fp \t\}
puts $fp \tshow\ \{
puts $fp {	    $w.kanji configure -text [lindex $data(kanji) $data(i)]}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp {}
puts $fp proc\ kanji-self-test\ \{w\}\ \{
puts $fp {    tkj-empty $w}
puts $fp {    keyword-show-kanji $w setup   }
puts -nonewline $fp \}
close $fp
set restore [file join TkKanji tkj tkj-multi-choice.tcl]
msg "restoring file $restore"
if {[catch {open $restore w} fp]} { msg "failed to create file $restore" } 
puts $fp ########################################################################
puts $fp #
puts $fp {# Copyright (c) 1999 by Roger E. Critchlow Jr, Santa Fe, NM, USA,}
puts $fp {# rec@elf.org -- http://www.elf.org}
puts $fp {# }
puts $fp {# This program is free software; you can redistribute it and/or modify}
puts $fp {# it under the terms of the GNU General Public License as published by}
puts $fp {# the Free Software Foundation; either version 2 of the License, or}
puts $fp {# (at your option) any later version.}
puts $fp #
puts $fp {#  This program is distributed in the hope that it will be useful,}
puts $fp {# but WITHOUT ANY WARRANTY; without even the implied warranty of}
puts $fp {# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the}
puts $fp {# GNU General Public License for more details.}
puts $fp #
puts $fp {# You should have received a copy of the GNU General Public License}
puts $fp {# along with this program; if not, write to the Free Software}
puts $fp {# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307}
puts $fp {# USA}
puts $fp #
puts $fp ########################################################################
puts $fp #
puts $fp {# give a keyword, choose the correct kanji from menu of 12}
puts $fp #
puts $fp proc\ keyword-choose-kanji\ \{w\ op\}\ \{
puts $fp {    upvar \#0 $w data}
puts $fp {    set f keyword-choose-kanji}
puts $fp \ \ \ \ switch\ \$op\ \{
puts $fp \tsetup\ \{
puts $fp {	    catch {unset data}}
puts $fp {	    wm title $w {Tk Kanji Multiple Choice}}
puts $fp {}
puts $fp {	    set data(select) [tkj-default select]}
puts $fp {	    set data(choose) {lindex [tkj-get-field [lindex $data(kanji) $data(i)] ENG] 0}}
puts $fp {	    set data(2nd-chance) 1}
puts $fp {	    set data(hits) 0}
puts $fp {	    set data(tries) 0}
puts $fp {	    set data(delay) 2000}
puts $fp {}
puts $fp {	    pack [frame $w.m] -side top -fill x}
puts $fp {	    pack [menubutton $w.m.o -text {options} -menu $w.m.o.m] -side left}
puts $fp {	    menu $w.m.o.m -tearoff no}
puts $fp {	    $w.m.o.m add command -label {Reshuffle list} -command [list $f $w shuffle]}
puts $fp {	    $w.m.o.m add command -label {Clear score} -command [list $f $w clear]}
puts $fp {	    $w.m.o.m add separator}
puts $fp \t\ \ \ \ \$w.m.o.m\ add\ radiobutton\ -label\ \{Use\ first\ meaning\}\ -var\ \$\{w\}(choose)\ \\
puts $fp {		-value {lindex [tkj-get-field [lindex $data(kanji) $data(i)] ENG] 0}}
puts $fp \t\ \ \ \ \$w.m.o.m\ add\ radiobutton\ -label\ \{Use\ any\ meaning\}\ -var\ \$\{w\}(choose)\ \\
puts $fp {		-value {choose-one [tkj-get-field [lindex $data(kanji) $data(i)] ENG]}}
puts $fp {	    $w.m.o.m add separator}
puts $fp {	    $w.m.o.m add checkbutton -label {Guess again} -var ${w}(2nd-chance)}
puts $fp {	    $w.m.o.m add separator}
puts $fp \t\ \ \ \ foreach\ sec\ \{1\ 2\ 5\}\ \{
puts $fp {		$w.m.o.m add radiobutton -label "Delay $sec sec" -variable ${w}(delay) -value ${sec}000}
puts $fp \t\ \ \ \ \}
puts $fp {	    $w.m.o.m add separator}
puts $fp {	    $w.m.o.m add command -label {Done} -command [list tkj-chooser $w]}
puts $fp {}
puts $fp {	    pack [label $w.keyword -border 10] -side top -fill x}
puts $fp {	    pack [frame $w.k] -side top -fill x}
puts $fp \t\ \ \ \ foreach\ \\
puts $fp \t\tx\ \{0\ 1\ 2\ 3\ 4\ 5\ 6\ 7\ 8\ 9\ 10\ 11\}\ \\
puts $fp \t\ti\ \{0\ 0\ 0\ 0\ 1\ 1\ 2\ 2\ 3\ 3\ \ 3\ \ 3\}\ \\
puts $fp \t\tj\ \{0\ 1\ 2\ 3\ 0\ 3\ 0\ 3\ 0\ 1\ \ 2\ \ 3\}\ \{
puts $fp {		    grid [button $w.b$x -font [tkj-font 24] -command [list $f $w $x]] -in $w.k -row $i -column $j}
puts $fp \t\t\}
puts $fp {	    grid [label $w.select -border 10 -font [tkj-font 48]] -in $w.k -row 1 -column 1 -rowspan 2 -columnspan 2}
puts $fp {	    pack [label $w.answer -border 10] -side top -fill x}
puts $fp {	    pack [label $w.score -textvar ${w}(score)] -side top -fill x}
puts $fp {}
puts $fp {	    pack [tkj-select-menu $w.m.s ${w}(select) [list $f $w start]] -side left}
puts $fp {}
puts $fp {	    $f $w start}
puts $fp \t\}
puts $fp \tstart\ \{
puts $fp {	    set data(kanji) [shuffle [eval $data(select)]]}
puts $fp {	    set data(n) [llength $data(kanji)]}
puts $fp {	    set data(i) -1}
puts $fp {	    $f $w next}
puts $fp \t\}
puts $fp \tclear\ \{
puts $fp {	    set data(hits) 0}
puts $fp {	    set data(tries) 0}
puts $fp {	    set data(score) $data(hits)/$data(tries)}
puts $fp \t\}
puts $fp \tnext\ \{
puts $fp {	    incr data(i)}
puts $fp \t\ \ \ \ while\ \{\$data(i)\ >=\ \$data(n)\}\ \{
puts $fp {		set data(kanji) [shuffle $data(kanji)]}
puts $fp {		set data(i) [expr {$data(i)-$data(n)}]}
puts $fp \t\ \ \ \ \}
puts $fp {	    $f $w set}
puts $fp \t\}
puts $fp \tshuffle\ \{
puts $fp {	    set data(kanji) [shuffle $data(kanji)]}
puts $fp {	    $f $w set}
puts $fp \t\}
puts $fp \tset\ \{
puts $fp {	    set data(right) [lindex $data(kanji) $data(i)]}
puts $fp {	    $w.keyword configure -text [eval $data(choose)]}
puts $fp {	    set data(list) $data(right)}
puts $fp \t\ \ \ \ while\ \{\[llength\ \$data(list)\]\ <\ 12\}\ \{
puts $fp {		set k [lindex $data(kanji) [expr {[random]%$data(n)}]]}
puts $fp \t\tif\ \{\[lsearch\ \$data(list)\ \$k\]\ <\ 0\}\ \{
puts $fp {		    lappend data(list) $k}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp \t\ \ \ \ foreach\ x\ \{0\ 1\ 2\ 3\ 4\ 5\ 6\ 7\ 8\ 9\ 10\ 11\}\ k\ \[shuffle\ \$data(list)\]\ \{
puts $fp {		$w.b$x configure -text $k}
puts $fp \t\ \ \ \ \}
puts $fp {	    $f $w ready}
puts $fp \t\}
puts $fp \tready\ \{
puts $fp {	    $w.select configure -text {}}
puts $fp {	    $w.answer configure -text {}}
puts $fp {	    set data(score) $data(hits)/$data(tries)}
puts $fp \t\}
puts $fp \t0\ -\ 1\ -\ 2\ -\ 3\ -\ 4\ -\ 5\ -\ 6\ -\ 7\ -\ 8\ -\ 9\ -\ 10\ -\ 11\ \{
puts $fp {	    incr data(tries)}
puts $fp \t\ \ \ \ if\ \{\[string\ compare\ \[\$w.b\$op\ cget\ -text\]\ \$data(right)\]\ ==\ 0\}\ \{
puts $fp {		$w.select configure -text [$w.b$op cget -text] -fg black}
puts $fp {		$w.answer configure -text Correct! -fg black}
puts $fp {		incr data(hits)}
puts $fp {		after $data(delay) [list $f $w next]}
puts $fp \t\ \ \ \ \}\ else\ \{
puts $fp {		$w.select configure -text [$w.b$op cget -text] -fg red}
puts $fp {		$w.answer configure -text Wrong! -fg red}
puts $fp \t\tif\ \{\$data(2nd-chance)\}\ \{
puts $fp {		    after $data(delay) [list $f $w ready]}
puts $fp \t\t\}\ else\ \{
puts $fp {		    after $data(delay) [list $f $w next]}
puts $fp \t\t\}
puts $fp \t\ \ \ \ \}
puts $fp \t\}
puts $fp \ \ \ \ \}
puts $fp \}
puts $fp {}
puts $fp proc\ kanji-multi-choice\ \{w\}\ \{
puts $fp {    tkj-empty $w}
puts $fp {    keyword-choose-kanji $w setup}
puts $fp \}
close $fp

    if { ! [catch {winfo exists .}]} {
	.b configure -state normal
    }

