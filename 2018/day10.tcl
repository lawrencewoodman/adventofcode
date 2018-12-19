# Code for Day 10 of Advent of Code: https://adventofcode.com/2018/day/10
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

proc getPoints {filename} {
  set fp [open $filename r]
  set input [read $fp]
  close $fp
  set input [string trim $input]
  set input [split $input "\n"]
  return [lmap p $input {
    regexp {^position=<\s*(.*?),\s*(.*?)> velocity=<\s*(.*?),\s*(.*?)>$} $p \
           -> px py vx vy
    dict create position [list $px $py] velocity [list $vx $vy]
  }]
}

proc findBoundaries {points} {
  set firstPoint [lindex $points 0]
  lassign [dict get $firstPoint position] minX minY
  lassign [dict get $firstPoint position] maxX maxY
  foreach p $points {
    lassign [dict get $p position] px py
    if {$px < $minX} {set minX $px}
    if {$py < $minY} {set minY $py}
    if {$px > $maxX} {set maxX $px}
    if {$py > $maxY} {set maxY $py}
  }
  return [dict create minX $minX minY $minY maxX $maxX maxY $maxY]
}

proc printMap {map} {
  foreach l $map {
    puts $l
  }
}

proc makeMap {boundaries points} {
  set mapMaxX 100
  set mapMaxY 100
  set map {}
  set numVisiblePoints 0
  set minX [dict get $boundaries minX]
  set minY [dict get $boundaries minY]
  set width [expr {[dict get $boundaries maxX] - $minX}]
  set height [expr {[dict get $boundaries maxY] - $minY}]
  if {$width < $mapMaxX} {set mapMaxX $width}
  if {$height < $mapMaxY} {set mapMaxY $height}
  for {set y 0} {$y <= $mapMaxY} {incr y} {
    set row {}
    for {set x 0} {$x <= $mapMaxX} {incr x} {
      set hasPoint false
      foreach p $points {
        lassign [dict get $p position] px py
        if {$x == $px-abs($minX) && $y == $py-abs($minY)} {
          if {!$hasPoint} {
            lappend row "#"
          }
          set hasPoint true
          incr numVisiblePoints
        }
      }
      if {!$hasPoint} {lappend row "."}
    }
    lappend map [join $row ""]
  }
  return [list $numVisiblePoints $map]
}

proc movePoints {points} {
  return [lmap p $points {
    lassign [dict get $p position] px py
    lassign [dict get $p velocity] vx vy
    dict set p position [list [expr {$px+$vx}] [expr {$py+$vy}]]
  }]
}

proc findMessage {points} {
  set smallestMap {}
  set secsMessage 20000
  set numPoints [llength $points]
  for {set sec 0} {$sec < 20000} {incr sec} {
    set boundaries [findBoundaries $points]
    dict with boundaries {
      if {$maxX - $minX < 100 && $maxY - $minY < 100} {
        lassign [makeMap $boundaries $points] numVisiblePoints map
        if {$numVisiblePoints == $numPoints} {
          if {[llength $smallestMap] == 0 ||
              [llength $map] < [llength $smallestMap]} {
            set smallestMap $map
            set secsMessage $sec
          }
        }
      }
    }
    set points [movePoints $points]
  }
  return [list $smallestMap $secsMessage]
}

proc part1 {messageMap} {
  puts "Part1:"
  printMap $messageMap
}

set points [getPoints "day10.input"]
lassign [findMessage $points] messageMap secsMessage

# Part1: XECXBPZB
# Part2: 10124
part1 $messageMap
puts "Part2: $secsMessage"
