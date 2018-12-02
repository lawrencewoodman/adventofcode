# Code for Day 2 of Advent of Code: https://adventofcode.com/2018/day/2
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day2.input" r]
set input [read $fp]
close $fp

proc part1 {input} {
  set numDuplicates [dict create]
  foreach id $input {
    set numIncreased [dict create]
    set freqs [dict create]
    foreach c [split $id {}] {
      dict incr freqs $c
    }
    dict for {c num} $freqs {
      if {![dict exists $numIncreased $num]} {
        dict incr numDuplicates $num
        dict set numIncreased $num 1
      }
    }
  }
  dict with numDuplicates {return [expr {$2 * $3}]}
}

proc part2 {input} {
  foreach id1 $input {
    foreach id2 $input {
      set numDiff 0
      set commonLetters ""
      for {set i 0} {$i < [string length $id1]} {incr i} {
        set cid1 [string index $id1 $i]
        set cid2 [string index $id2 $i]
        if {$cid1 != $cid2} {
          incr numDiff
        } else {
          append commonLetters $cid1
        }
      }
      if {$numDiff == 1} {
        return $commonLetters
      }
    }
  }
}

puts "part1: [part1 $input]"
puts "part2: [part2 $input]"
