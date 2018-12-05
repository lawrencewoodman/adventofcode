# Code for Day 5 of Advent of Code: https://adventofcode.com/2018/day/5
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day5.input" r]
set input [read $fp]
close $fp
set input [split $input ""]
set input [lrange $input 0 end-1]


proc isOppositeCase {a b} {
  return [expr {
    $a != $b && ([string toupper $a] == $b || [string tolower $a] == $b)
  }]
}

proc part1 {input} {
  set finished false
  while {!$finished} {
    set finished true
    for {set i 0; set j 1} {$j < [llength $input]} {incr i; incr j} {
      set a [lindex $input $i]
      set b [lindex $input $j]
      if {[isOppositeCase $a $b]} {
        set finished false
        set input [list {*}[lrange $input 0 [expr {$i-1}]] \
                  {*}[lrange $input [expr {$j+1}] end]]
        if {$i > 0} {
          incr i -1
          incr j -1
        } else {
          break
        }
      }
    }
  }
  return [llength $input]
}

proc part2 {input} {
  set letters {a b c d e f g h i j k l m n o p q r s t u v w x y z}
  set shortest [llength $input]
  foreach l $letters {
    set trial [list]
    foreach e $input {
      if {$l != [string tolower $e]} {
        lappend trial $e
      }
    }
    set reactionLength [part1 $trial]
    if {$reactionLength < $shortest} {
      set shortest $reactionLength
    }
  }
  return $shortest
}

# Part1: 11540
# Part2: 6918
puts "part1: [part1 $input]"
puts "part2: [part2 $input]"
