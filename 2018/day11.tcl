# Code for Day 11 of Advent of Code: https://adventofcode.com/2018/day/11
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day11.input" r]
set input [read $fp]
close $fp
set input [string trim $input]

proc calcPowerLevel {x y serialNumber} {
  set powerLevel [expr {(($x+10)*$y+$serialNumber)*($x+10)}]
  set powerLevel [string index $powerLevel end-2]
  if {$powerLevel eq ""} {set powerLevel 0}
  incr powerLevel -5
  return $powerLevel
}

proc makeGrid {gridName serialNumber} {
  upvar $gridName grid
  for {set y 1} {$y <= 300} {incr y} {
    for {set x 1} {$x <= 300} {incr x} {
      set grid($x,$y) [calcPowerLevel $x $y $serialNumber]
    }
  }
}

proc calcSquarePower {gridName squareSize topLeftX topLeftY} {
  upvar $gridName grid
  for {set y $topLeftY} {$y < $topLeftY+$squareSize} {incr y} {
    for {set x $topLeftX} {$x < $topLeftX+$squareSize} {incr x} {
      incr sum $grid($x,$y)
    }
  }
  return $sum
}

proc calcNextSquarePower {
  gridName previousPower squareSize topLeftX topLeftY
} {
  upvar $gridName grid
  set sum $previousPower
  set y [expr {$topLeftY+$squareSize-1}]
  for {set x $topLeftX} {$x < $topLeftX+$squareSize} {incr x} {
    incr sum $grid($x,$y)
  }

  set x [expr {$topLeftX+$squareSize-1}]
  for {set y $topLeftY} {$y < $topLeftY+$squareSize-1} {incr y} {
    incr sum $grid($x,$y)
  }
  return $sum
}

proc findLargestSquare {gridName squareSize} {
  upvar $gridName grid
  set maxTotalPower -1
  set maxTotalPowerX 0
  set maxTotalPowerY 0
  for {set y 1} {$y <= 300-$squareSize} {incr y} {
    for {set x 1} {$x < 300-$squareSize} {incr x} {
      set squarePower [calcSquarePower $gridName $squareSize $x $y]
      if {$squarePower > $maxTotalPower} {
        set maxTotalPower $squarePower
        set maxTotalPowerX $x
        set maxTotalPowerY $y
      }
    }
  }
  return [list $maxTotalPowerX $maxTotalPowerY $maxTotalPower]
}

proc findAnyLargestSquare {gridName} {
  upvar $gridName grid
  set maxTotalPower -1
  set maxTotalPowerX 0
  set maxTotalPowerY 0
  set maxTotalPowerSize 1
  for {set y 1} {$y <= 300} {incr y} {
    for {set x 1} {$x <= 300} {incr x} {
      set squarePower [calcSquarePower $gridName 1 $x $y]
      for {set size 2} {$size <= 300} {incr size} {
        if {$x+$size <= 300 && $y+$size <= 300} {
          set squarePower [
            calcNextSquarePower $gridName $squarePower $size $x $y
          ]
          if {$squarePower > $maxTotalPower} {
            set maxTotalPower $squarePower
            set maxTotalPowerX $x
            set maxTotalPowerY $y
            set maxTotalPowerSize $size
          }
        }
      }
    }
  }
  return [list $maxTotalPowerX $maxTotalPowerY $maxTotalPowerSize]
}

proc part1 {input} {
  makeGrid grid $input
  lassign [findLargestSquare grid 3] x y
  return "$x,$y"
}

proc part2 {input} {
  makeGrid grid $input
  lassign [findAnyLargestSquare grid] x y size
  return "$x,$y,$size"
}

# Part1: 243,16
# Part2: 231,227,14
puts "part1: [part1 $input]"
puts "part2: [part2 $input]"
