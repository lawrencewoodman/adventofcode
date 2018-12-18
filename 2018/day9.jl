# Code for Day 9 of Advent of Code: https://adventofcode.com/2018/day/9
# Julia Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

using Printf

mutable struct Game
  numPlayers
  lastMarble
  current
  marbles
  Game(numPlayers, lastMarble) = new(numPlayers, lastMarble, -1, Dict())
  Game() = new(0, 0, -1, Dict())
end

mutable struct Marble
  prev
  next
end

function start(g::Game)
  g.marbles = Dict(0 => Marble(0,0))
  g.current = 0
end

function next(g::Game, value)
  g.marbles[value].next
end

function prev(g::Game, value)
  g.marbles[value].prev
end

function prev7(g::Game)
  v = g.current
  for i in 1:7
    v = prev(g, v)
  end
  v
end

function remove(g::Game, value)
  prev = g.marbles[value].prev
  next = g.marbles[value].next
  g.marbles[prev].next = next
  g.marbles[next].prev = prev
  g.current = next
  delete!(g.marbles, value)
end

function insert(g::Game, beforeValue, value)
  before = g.marbles[beforeValue]
  beforePrev = before.prev
  g.marbles[value] = Marble(before.prev, beforeValue)
  g.marbles[beforeValue].prev = value
  g.marbles[beforePrev].next = value
  g.current = value
end

function add(g::Game, value)
  if value % 23 == 0
    throw(ArgumentError("can't add multiple of 23"))
  end
  next1 = next(g, g.current)
  next2 = next(g, next1)
  insert(g, next2, value)
end

function getInput(filename)
  game = Game()
  open(filename) do file
    for ln in eachline(file)
      gameWords = split(ln)
      game = Game(parse(Int32, gameWords[1]), parse(Int32, gameWords[7]))
      break
    end
  end
  game
end

function play(g::Game)
  playerNum = 1
  start(g)
  scores = Dict()
  for m in 1:g.lastMarble
    if m % 23 == 0
      removeValue = prev7(g)
      remove(g, removeValue)
      playerScore = get(scores, playerNum, 0)
      scores[playerNum] = playerScore+m+removeValue
    else
      add(g, m)
    end
    playerNum = playerNum + 1
    if playerNum >= g.numPlayers
      playerNum = 0
    end
  end
  highestScore = 0
  for (p, s) in scores
    if s > highestScore
      highestScore = s
    end
  end
  highestScore
end


function part1(game)
  play(game)
end

function part2(game)
  game.lastMarble = game.lastMarble*100
  play(game)
end

game = getInput("day9.input")
@printf "part1: %d\n" part1(game)
@printf "part2: %d\n" part2(game)
