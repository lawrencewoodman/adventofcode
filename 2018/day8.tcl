# Code for Day 8 of Advent of Code: https://adventofcode.com/2018/day/8
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day8.input" r]
set input [read $fp]
close $fp
set input [string trim $input]
set input [split $input " "]


proc getChildren {header} {
  lassign $header numChildNodes
  set children {}
  set totalNumNums 0
  set p 2
  for {set i 0} {$i < $numChildNodes} {incr i} {
    lassign [parseHeader [lrange $header $p end]] childNode numNums
    lappend children $childNode
    incr totalNumNums $numNums
    incr p $numNums
  }
  return [list $children $totalNumNums]
}

proc parseHeader {header} {
  set metadata {}
  lassign $header numChildNodes numMetadata

  lassign [getChildren $header] children numNums
  if {$numMetadata > 0} {
    set metadata [
      lrange $header [expr {$numNums+2}] [expr {$numNums+1+$numMetadata}]
    ]
  }
  set numNums [expr {2+$numNums+$numMetadata}]
  return [list [dict create children $children meta $metadata] $numNums]
}

proc addMetadata {headerDict} {
  set metadataSum 0
  dict with headerDict {
    if {[llength $meta] > 0} {incr metadataSum [::tcl::mathop::+ {*}$meta]}
    foreach c $children {
      incr metadataSum [addMetadata $c]
    }
  }
  return $metadataSum
}

proc addMetadata2 {headerDict} {
  set metadataSum 0
  dict with headerDict {
    if {[llength $children] == 0} {
      if {[llength $meta] > 0} {incr metadataSum [::tcl::mathop::+ {*}$meta]}
    } else {
      foreach m $meta {
        if {$m <= [llength $children]} {
          incr metadataSum [addMetadata2 [lindex $children [expr {$m-1}]]]
        }
      }
    }
  }
  return $metadataSum
}

proc part1 {input} {
  lassign [parseHeader $input] headerDict
  return [addMetadata $headerDict]
}

proc part2 {input} {
  lassign [parseHeader $input] headerDict
  return [addMetadata2 $headerDict]
}

# Part1: 41849
# Part2: 32487
puts "Part1: [part1 $input]"
puts "Part2: [part2 $input]"
