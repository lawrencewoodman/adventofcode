# Code for Day 1 of Advent of Code: https://adventofcode.com/2018/day/1
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day1.input" r]
set input [read $fp]
close $fp

proc part1 {input} {
  return [::tcl::mathop::+ {*}$input]
}

proc part2 {freqs startFreq input} {
  dict set freqs $startFreq 1
  set sum $startFreq
  foreach line $input {
    if {$line != ""} {
      set sum [expr {$sum + $line}]
      if {[dict exists $freqs $sum]} {
        return $sum
      } else {
        dict set freqs $sum 1
      }
    }
  }
  tailcall part2 $freqs $sum $input
}

puts "part1: [part1 $input]"
puts "part2: [part2 {} 0 $input]"

