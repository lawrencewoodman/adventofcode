# Code for Day 4 of Advent of Code: https://adventofcode.com/2018/day/4
# Python Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

import re
from datetime import datetime, date, time

input = open('day4.input').readlines()

def getDate(e):
    stampRE = re.compile("^.*(\d\d\d\d-\d\d-\d\d \d\d:\d\d).*$")
    stamp = stampRE.findall(e)[0]
    return datetime.strptime(stamp, "%Y-%m-%d %H:%M").timestamp()

def part1(input):
    pattern = {}
    input.sort(key=getDate)

    guardRE = re.compile("^.*\d\d\d\d-\d\d-\d\d \d\d:\d\d.*Guard #(\d+).*$")
    sleepRE = re.compile("^.*\d\d\d\d-\d\d-\d\d \d\d:(\d\d).*falls.*$")
    wakeRE = re.compile("^.*\d\d\d\d-\d\d-\d\d \d\d:(\d\d).*wake.*$")
    for entry in input:
        if guardRE.match(entry):
            guardID = guardRE.findall(entry)[0]
        elif sleepRE.match(entry):
            sleep = int(sleepRE.findall(entry)[0])
        elif wakeRE.match(entry):
            wake = int(wakeRE.findall(entry)[0])
            for m in range(sleep, wake):
                num = 1
                if guardID not in pattern:
                    pattern[guardID] = {}
                if m in pattern[guardID]:
                    num = pattern[guardID][m]
                    num += 1
                pattern[guardID][m] = num

    sleepiestID = -1
    sleepiestMinutes  = -1
    for id, sleep in pattern.items():
        totalSleep = 0
        for m, num in sleep.items():
            totalSleep += num
        if totalSleep > sleepiestMinutes:
            sleepiestMinutes = totalSleep
            sleepiestID = id

    sleepiestMin = -1
    sleepiestNum = -1
    for m, num in pattern[sleepiestID].items():
        if num > sleepiestNum:
            sleepiestNum = num
            sleepiestMin = m

    return(int(sleepiestID) * int(sleepiestMin))

def part2(input):
    pattern = {}
    input.sort(key=getDate)

    guardRE = re.compile("^.*\d\d\d\d-\d\d-\d\d \d\d:\d\d.*Guard #(\d+).*$")
    sleepRE = re.compile("^.*\d\d\d\d-\d\d-\d\d \d\d:(\d\d).*falls.*$")
    wakeRE = re.compile("^.*\d\d\d\d-\d\d-\d\d \d\d:(\d\d).*wake.*$")
    for entry in input:
        if guardRE.match(entry):
            guardID = guardRE.findall(entry)[0]
        elif sleepRE.match(entry):
            sleep = int(sleepRE.findall(entry)[0])
        elif wakeRE.match(entry):
            wake = int(wakeRE.findall(entry)[0])
            for m in range(sleep, wake):
                num = 1
                if guardID not in pattern:
                    pattern[guardID] = {}
                if m in pattern[guardID]:
                    num = pattern[guardID][m]
                    num += 1
                pattern[guardID][m] = num

    sleepiestID = -1
    sleepiestMinutes  = -1
    for id, sleep in pattern.items():
        totalSleep = 0
        for m, num in sleep.items():
            totalSleep += num
        if totalSleep > sleepiestMinutes:
            sleepiestMinutes = totalSleep
            sleepiestID = id

    sleepiestID = -1
    sleepiestMin = -1
    sleepiestNum = -1
    for id, sleep in pattern.items():
        for m, num in sleep.items():
            if num > sleepiestNum:
                sleepiestNum = num
                sleepiestMin = m
                sleepiestID = id

    return(int(sleepiestID) * int(sleepiestMin))


print("Part1: ", part1(input))
print("Part2: ", part2(input))
