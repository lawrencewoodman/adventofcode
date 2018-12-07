# Code for Day 6 of Advent of Code: https://adventofcode.com/2018/day/6
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day6.input" r]
set input [read $fp]
close $fp
set input [split $input "\n"]
set input [lrange $input 0 end-1]


proc mDistance {x1 y1 x2 y2} {
  return [expr {abs($x1-$x2) + abs($y1-$y2)}]
}

# Returns: {coords maxX maxY}
proc makeCoords {input} {
  set maxX 0
  set maxY 0
  set num 0
  foreach c $input {
    lassign [split $c ","] x y
    set y [string trim $y]
    dict set coords "$x,$y" $num
    incr num
    if {$x > $maxX} {set maxX $x}
    if {$y > $maxY} {set maxY $y}
  }
  return [list $coords $maxX $maxY]
}

proc part1 {input} {
  lassign [makeCoords $input] coords maxX maxY
  incr maxX 20
  incr maxY 20

  for {set y 0} {$y <= $maxY} {incr y} {
    for {set x 0} {$x <= $maxX} {incr x} {
      set distances [dict create]
      dict for {xy num} $coords {
        lassign [split $xy ","] cx cy
        dict set distances $num [mDistance $x $y $cx $cy]
      }
      set nearestDist [expr {$maxX * $maxY}]
      set nearestNum [expr {[llength $input]+3}]
      set clash false
      dict for {num dist} $distances {
        if {$dist == $nearestDist} {
          set clash true
        } elseif {$dist < $nearestDist} {
          set nearestNum $num
          set nearestDist $dist
          set clash false
        }
      }
      if {$clash} {
        dict set map "$x,$y" "."
      } else {
        dict set map "$x,$y" $nearestNum
      }
    }
  }

  dict for {xy num} $map {
    lassign [split $xy ","] x y
    if {$x == 0 || $x == $maxX || $y == 0 || $y == $maxY} {
      dict set excludes $num 1
    } else {
      dict incr areas $num
    }
  }

  set biggest 0
  dict for {num size} $areas {
    if {$size > $biggest && ![dict exists $excludes $num]} {
      set biggest $size
    }
  }

  return $biggest
}

proc part2 {input} {
  lassign [makeCoords $input] coords maxX maxY
  set regionSize 0
  for {set y 0} {$y <= $maxY} {incr y} {
    for {set x 0} {$x <= $maxX} {incr x} {
      set totalDistance 0
      dict for {xy num} $coords {
        lassign [split $xy ","] cx cy
        incr totalDistance [mDistance $x $y $cx $cy]
      }
      if {$totalDistance < 10000} {
        incr regionSize
      }
    }
  }
  return $regionSize
}

# Part1: 4186
# Part2: 45509
puts "Part1: [part1 $input]"
puts "Part2: [part2 $input]"
