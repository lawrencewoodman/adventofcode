# Code for Day 11 of Advent of Code: https://adventofcode.com/2018/day/11
# Pyret Solution
#
# Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
# Licensed under an MIT licence.  Please see LICENCE.md for details.

fun calc-power-level(x, y, serial-number):
  rack-id = x + 10
  power-level = ((rack-id * y) + serial-number) * rack-id
  power-level-str = num-to-string(power-level)
  if string-length(power-level-str) >= 3:
    end-pos = string-length(power-level-str) - 3
    hundred = string-char-at(num-to-string(power-level), end-pos)
    string-to-number(hundred).or-else(0) - 5
  else:
    -5
  end
where:
  calc-power-level(122,79,57) is -5
  calc-power-level(217,196,39) is 0
  calc-power-level(101,153,71) is 4
end

fun make-grid(serial-number, size):
  fun build-row(y :: Number) -> Array<Number>:
    fun build-cell(x :: Number) -> Number:
      calc-power-level(x, y, serial-number)
    end
    build-array(build-cell, size + 1)
  end
  build-array(build-row, size + 1)
where:
  make-grid(57, 300).get-now(79).get-now(122) is -5
  make-grid(39, 300).get-now(196).get-now(217) is 0
  make-grid(71, 300).get-now(153).get-now(101) is 4
  make-grid(8, 5).get-now(5).get-now(3) is 4
  make-grid(8, 5).length() is 6
end

fun calc-square-power(grid, square-size, top-left-x, top-left-y):
  row-positions = range(top-left-y, top-left-y + square-size)
  col-positions = range(top-left-x, top-left-x + square-size)
  fun sum-row(y):
    fold(lam(sum, x): sum + grid.get-now(y).get-now(x) end, 0, col-positions)
  end
  fold(lam(sum, y): sum + sum-row(y) end, 0, row-positions)
where:
  calc-square-power(make-grid(18,300), 3, 33, 45) is 29
  calc-square-power(make-grid(42,300), 3, 21, 61) is 30
end

fun calc-next-square-power(
  grid, square-size, top-left-x, top-left-y, previous-power
):
  col-positions = range(top-left-x, top-left-x + square-size)
  row-positions = range(top-left-y, (top-left-y + square-size) - 1)
  col-sum = fold(
    lam(sum, x):
      y = (top-left-y + square-size) - 1
      sum + grid.get-now(y).get-now(x)
    end,
    0,
    col-positions)
  row-sum = fold(
    lam(sum, y):
      x = (top-left-x + square-size) - 1
      sum + grid.get-now(y).get-now(x)
    end,
    0,
    row-positions)
  (previous-power + col-sum) + row-sum
where:
  calc-next-square-power(make-grid(18,300), 3, 33, 45, 14) is 29
end

fun find-largest-square(grid, square-size):
  row-positions = range(1, 301 - square-size)
  col-positions = range(1, 301 - square-size)
  fun square-powers(acc, y):
    fold(
      lam(acc-inner, x):
        square-power = calc-square-power(grid, square-size, x, y)
        max-total-power = acc-inner.get(0)
        if square-power > max-total-power:
          [list: square-power, x, y]
        else:
          acc-inner
        end
      end,
      acc,
      col-positions)
  end
  best = fold(
    lam(acc, y): square-powers(acc, y) end,
    [list: -1,0,0],
    row-positions)
  [list: best.get(1), best.get(2)]
where:
  find-largest-square(make-grid(18,300), 3) is [list: 33,45]
  find-largest-square(make-grid(42,300), 3) is [list: 21,61]
end

fun find-cell-highest-power-square(grid, x, y):
  square-sizes = range(2, grid.length())
  square-power = calc-square-power(grid, 1, x, y)
  best = fold(
    lam(acc, size):
      previous-square-power = acc.get(0)
      if (x + size) <= grid.length():
        if  (y + size) <= grid.length():
          next-square-power = calc-next-square-power(
            grid, size, x, y, previous-square-power)
          max-total-power = acc.get(1)
          if next-square-power > max-total-power:
            [list: next-square-power, next-square-power, size]
          else:
            acc.set(0, next-square-power)
          end
        else:
          acc
        end
      else:
        acc
      end
    end,
    [list: square-power, square-power, 1],
    square-sizes)
    [list: best.get(1), best.get(2)]
where:
  grid = make-grid(18,4)
  find-cell-highest-power-square(grid, 0, 0) is [list: -4, 1]
  find-cell-highest-power-square(grid, 1, 2) is [list: 9, 3]
  find-cell-highest-power-square(grid, 2, 2) is [list: 8, 3]
end

fun find-any-largest-square(grid):
  row-positions = range(1, grid.length())
  col-positions = range(1, grid.length())
  best = fold(
    lam(acc-y, y):
      fold(
        lam(acc-x, x):
          best = find-cell-highest-power-square(grid, x, y)
          max-power = acc-x.get(0)
          cell-max-power = best.get(0)
          if cell-max-power > max-power:
            size = best.get(1)
            [list: cell-max-power, x, y, size]
          else:
            acc-x
          end
        end,
        acc-y,
        col-positions)
    end,
    [list: -1, 0, 0, 1],
    row-positions)
  [list: best.get(1), best.get(2), best.get(3)]
where:
  find-any-largest-square(make-grid(18,4)) is [list: 1,2,3]
end

fun part1(serial-number):
  grid = make-grid(serial-number,300)
  coord = find-largest-square(grid, 3)
  x = num-to-string(coord.get(0))
  y = num-to-string(coord.get(1))
  string-append(string-append(x, ","), y)
where:
  part1(18) is "33,45"
  part1(42) is "21,61"
end

fun part2(serial-number, grid-size):
  grid = make-grid(serial-number,grid-size)
  coord = find-any-largest-square(grid)
  x = num-to-string(coord.get(0))
  y = num-to-string(coord.get(1))
  size = num-to-string(coord.get(2))
  string-append(string-append(string-append(string-append(x, ","), y), ","),size)
where:
  part2(18,4) is "1,2,3"
end

GRID-SIZE = 300
SERIAL-NUMBER = 7857
print(string-append("part1: ", part1(SERIAL-NUMBER)))
print(string-append("part2: ", part2(SERIAL-NUMBER, GRID-SIZE)))
