# Code for Day 3 of Advent of Code: https://adventofcode.com/2018/day/3
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day3.input" r]
set input [read $fp]
set input [split $input "\n"]
close $fp

proc part1 {input} {
  foreach claim $input {
    if {$claim == ""} { continue }
    scan $claim {#%d @ %d,%d: %dx%d} id leftMargin topMargin width height
    set maxX [expr {$leftMargin + $width}]
    set maxY [expr {$topMargin + $height}]
    for {set x [expr {$leftMargin + 1}]} {$x <= $maxX} {incr x} {
      for {set y [expr {$topMargin + 1}]} {$y <= $maxY} {incr y} {
        dict incr bitmap "$x,$y"
      }
    }
  }

  set count 0
  dict for {pos num} $bitmap {
    if {$num >= 2} {
      incr count
    }
  }

  return $count
}

proc part2 {input} {
  set clashIDS [dict create]
  set allIDS [list]
  set bitmap [dict create]
  foreach claim $input {
    if {$claim == ""} { continue }
    scan $claim {#%d @ %d,%d: %dx%d} id leftMargin topMargin width height
    lappend allIDS $id
    set maxX [expr {$leftMargin + $width}]
    set maxY [expr {$topMargin + $height}]
    for {set x [expr {$leftMargin + 1}]} {$x <= $maxX} {incr x} {
      for {set y [expr {$topMargin + 1}]} {$y <= $maxY} {incr y} {
        if {[dict exists $bitmap "$x,$y"]} {
          dict set clashIDS $id 1
          dict set clashIDS [dict get $bitmap "$x,$y"] 1
        } else {
          dict set bitmap "$x,$y" $id
        }
      }
    }
  }

  foreach id $allIDS {
    if {![dict exists $clashIDS $id]} {
      return $id
    }
  }
}
puts "part1: [part1 $input]"
puts "part2: [part2 $input]"
