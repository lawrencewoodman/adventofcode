#lang racket/base
; Code for Day 5 of Advent of Code: https://adventofcode.com/2018/day/5
; Racket Solution
;
; Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
; Licensed under an MIT licence.  Please see LICENCE.md for details.

(require racket/file
         racket/list
         racket/math
         racket/string)

(define (opposite-case? a b)
  (and (not (equal? a b)) (equal? (string-upcase a) (string-upcase b))))

(define input
  (map string (string->list (string-trim (file->string "day5.input")))))


(define (react input start)
  (if (>= start (- (length input) 1))
      input
      (let ([trial (list-tail input start)])
        (let ([a (first trial)]
              [b (second trial)])
          (if (opposite-case? a b)
              (react (append (take input start)
                             (list-tail input (+ start 2)))
                     start)
              (react input (+ start 1)))))))


(define (chainreaction input)
  (let ([new-input (react input 0)])
    (if (= (length input) (length new-input))
        input
        (chainreaction new-input))))

(define (part1 input)
  (length (chainreaction input)))

(define (part2 input)
  (second
   (let* ([letters '("a" "b" "c" "d" "e" "f" "g" "h"
                            "i" "j" "k" "l" "m" "n" "o" "p"
                            "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")]
          [lens (map (lambda (l)
                       (let ([new-input
                            (filter (lambda (e)
                                      (not (equal? (string-downcase l)
                                                   (string-downcase e))))
                                    input)])
                         (list l (part1 new-input))))
                     letters)])
          (for/fold ([shortest (list "!" (length input))])
                    ([l lens])
            (if (< (second l) (second shortest))
                l
                shortest)))))


(printf "Part1: ~a\n" (part1 input))
(printf "Part2: ~a\n" (part2 input))
