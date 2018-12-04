# Code for Day 4 of Advent of Code: https://adventofcode.com/2018/day/4
# Tcl Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

set fp [open "day4.input" r]
set input [read $fp]
set input [split $input "\n"]
if {[lindex $input end] == ""} {
  set input [lrange $input 0 end-1]
}
close $fp

proc dateCompare {a b} {
  regexp {^.*(\d\d\d\d-\d\d-\d\d \d\d:\d\d).*$} $a -> stampA
  regexp {^.*(\d\d\d\d-\d\d-\d\d \d\d:\d\d).*$} $b -> stampB
  set stampA [clock scan $stampA -format {%Y-%m-%d %H:%M}]
  set stampB [clock scan $stampB -format {%Y-%m-%d %H:%M}]
  return [expr {$stampA - $stampB}]
}

proc part1 {input} {
  set pattern [dict create]
  set input [lsort -command dateCompare $input]

  foreach entry $input {
    switch -regexp -matchvar details -- $entry {
      {^.*\d\d\d\d-\d\d-\d\d \d\d:\d\d.*Guard #(\d+).*$} {
        set guardID [lindex $details 1]
      }
      {^.*\d\d\d\d-\d\d-\d\d \d\d:(\d\d).*falls.*$} {
        scan [lindex $details 1] %d sleep
      }
      {^.*\d\d\d\d-\d\d-\d\d \d\d:(\d\d).*wake.*$} {
        scan [lindex $details 1] %d wakes
        for {set m $sleep} {$m < $wakes} {incr m} {
          set num 1
          if {[dict exists $pattern $guardID $m]} {
            set num [dict get $pattern $guardID $m]
            incr num
          }
          dict set pattern $guardID $m $num
        }
      }
    }
  }

  set sleepiestID -1
  set sleepiestMinutes -1
  dict for {id sleep} $pattern {
    set totalSleep 0
    dict for {m num} $sleep {
      incr totalSleep $num
    }
    if {$totalSleep > $sleepiestMinutes} {
      set sleepiestMinutes $totalSleep
      set sleepiestID $id
    }
  }

  set sleepiestMin -1
  set sleepiestNum -1
  dict for {m num} [dict get $pattern $sleepiestID] {
    if {$num > $sleepiestNum} {
      set sleepiestNum $num
      set sleepiestMin $m
    }
  }

  return [expr {$sleepiestID * $sleepiestMin}]
}

proc part2 {input} {
  set pattern [dict create]
  set input [lsort -command dateCompare $input]

  foreach entry $input {
    switch -regexp -matchvar details -- $entry {
      {^.*\d\d\d\d-\d\d-\d\d \d\d:\d\d.*Guard #(\d+).*$} {
        set guardID [lindex $details 1]
      }
      {^.*\d\d\d\d-\d\d-\d\d \d\d:(\d\d).*falls.*$} {
        scan [lindex $details 1] %d sleep
      }
      {^.*\d\d\d\d-\d\d-\d\d \d\d:(\d\d).*wake.*$} {
        scan [lindex $details 1] %d wakes
        for {set m $sleep} {$m < $wakes} {incr m} {
          set num 1
          if {[dict exists $pattern $guardID $m]} {
            set num [dict get $pattern $guardID $m]
            incr num
          }
          dict set pattern $guardID $m $num
        }
      }
    }
  }

  set sleepiestID -1
  set sleepiestMinutes -1
  dict for {id sleep} $pattern {
    set totalSleep 0
    dict for {m num} $sleep {
      incr totalSleep $num
    }
    if {$totalSleep > $sleepiestMinutes} {
      set sleepiestMinutes $totalSleep
      set sleepiestID $id
    }
  }

  set sleepiestID -1
  set sleepiestMin -1
  set sleepiestNum -1
  dict for {id sleep} $pattern {
    dict for {m num} $sleep {
      if {$num > $sleepiestNum} {
        set sleepiestNum $num
        set sleepiestMin $m
        set sleepiestID $id
      }
    }
  }

  return [expr {$sleepiestID * $sleepiestMin}]
}

puts "part1: [part1 $input]"
puts "part2: [part2 $input]"
