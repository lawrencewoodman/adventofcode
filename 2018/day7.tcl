# Code for Day 7 of Advent of Code: https://adventofcode.com/2018/day/7
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day7.input.test" r]
set input [read $fp]
close $fp
set input [split $input "\n"]
set input [lrange $input 0 end-1]

# Returns {candoLetters WaitingLetters}
proc candoLetters {steps} {
  set startingLetters [dict create]
  set waitingLetters [dict create]
  foreach s $steps {
    lassign $s a b
    dict set startingLetters $a 1
    dict set waitingLetters $b 1
  }
  set candoLetters [dict create]
  dict for {l x} $startingLetters {
    if {![dict exists $waitingLetters $l]} {
      dict set candoLetters $l 1
    }
  }
  return [list [lsort [dict keys $candoLetters]] [dict keys $waitingLetters]]
}

# Returns: {nextLetter remainingSteps waitingLetters}
proc nextLetter {steps} {
  lassign [candoLetters $steps] candoLetters waitingLetters
  lassign [lsort $candoLetters] nextLetter
  set remainingLetters [removeLetter $steps $nextLetter]
  return [list $nextLetter $remainingLetters $waitingLetters]
}

proc removeLetter {steps l} {
  set newSteps [list]
  foreach s $steps {
    lassign $s a b
    if {$a != $l} {
      lappend newSteps $s
    }
  }
  return $newSteps
}

proc numSeconds {l} {
  return [expr {[scan $l %c] - 65 + 1 + 60}]
}

proc part1 {input} {
  set steps [lmap e $input {list [lindex $e 1] [lindex $e 7]}]
  set order [list]
  while {[llength $steps] > 0} {
    lassign [nextLetter $steps] nextLetter steps waitingLetters
    lappend order $nextLetter
  }
  lappend order {*}[lsort $waitingLetters]
  return [join $order ""]
}

proc isLetterBeingWorkedOn {workers l} {
  dict for {w details} $workers {
    lassign $details wl
    if {$l == $wl} {
      return true
    }
  }
  return false
}

proc initWorkers {numWorkers} {
  for {set i 0} {$i < $numWorkers} {incr i} {
    dict set workers $i {. -1}
  }
  return $workers
}

proc part2 {input} {
  set steps [lmap e $input {list [lindex $e 1] [lindex $e 7]}]
  set workers [initWorkers 5]
  for {set seconds 0} {[llength $steps] > 0} {incr seconds} {
    dict for {worker details} $workers {
      lassign $details l secs
      if {$l != "."} {
        incr secs -1
        if {$secs == 0} {
          dict set workers $worker {. -1}
          set steps [removeLetter $steps $l]
        } else {
          dict set workers $worker [list $l $secs]
        }
      }
    }
    dict for {worker details} $workers {
      lassign $details l secs
      if {$l == "."} {
        lassign [candoLetters $steps] candoLetters waitingLetters
        if {[llength $waitingLetters] == 1} {
          lassign $waitingLetters lastLetter
        }
        foreach candoLetter $candoLetters {
          if {![isLetterBeingWorkedOn $workers $candoLetter]} {
            dict set workers $worker [
              list $candoLetter [numSeconds $candoLetter]
            ]
            break
          }
        }
      }
    }
  }
  return [expr {$seconds + [numSeconds $lastLetter] - 1}]
}

# Part1: OVXCKZBDEHINPFSTJLUYRWGAMQ
# Part2: 955
puts "Part1: [part1 $input]"
puts "Part2: [part2 $input]"
