# Code for Day 2 of Advent of Code: https://adventofcode.com/2018/day/2
# Ruby Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

input = File.read("day2.input")

def part1(input)
  numDuplicates = Hash.new(0)
  input.each_line do |id|
    numIncreased = Hash.new(0)
    freqs = Hash.new(0)
    id.each_char { |c| freqs[c] += 1 }
    freqs.each do |c, num|
      if !numIncreased.key?(num)
        numDuplicates[num] += 1
        numIncreased[num] = 1
      end
    end
  end
  numDuplicates[2] * numDuplicates[3]
end

def part2(input)
  input.each_line do |id1|
    input.each_line do |id2|
      numDiff = 0
      commonLetters = ""
      id1.each_char.with_index do |cid1, index|
        cid2 = id2[index]
        if cid1 == cid2
          commonLetters << cid1
        else
          numDiff += 1
        end
      end
      if numDiff == 1
        return commonLetters
      end
    end
  end
end

puts "Part1: #{part1(input)}"
puts "Part2: #{part2(input)}"
