// Code for Day 7 of Advent of Code: https://adventofcode.com/2018/day/7
// Pascal Solution
//
// Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
// Licensed under an MIT licence.  Please see LICENCE.md for details.

program day7;

uses
  Sysutils, Strutils;

type
  step_details = array [0..2] of char;
  all_step_details = array of step_details;
  char_array = array of char;
  worker_details = record
    letter: char;
    secs: integer;
  end;

function num_seconds(const l: char) : integer;
begin
  num_seconds := ord(l) - 65 + 1 + 60;
end;

function get_steps(const filename: string) : all_step_details;
var
  i: integer;
  s: string;
  a: string;
  b: string;
  f: TextFile;
begin
  i := 0;
  assign(f, filename);
  reset(f);
  while not eof(f) do
  begin
    setlength(get_steps, i+1);
    readln(f, s);
    a := ExtractWord(2, s, [' ']);
    b := ExtractWord(8, s, [' ']);
    get_steps[i,0] := a[1];
    get_steps[i,1] := b[1];
    inc(i);
  end;
  close(f);
end;

function remove_letter(steps: all_step_details; letter: char) : all_step_details;
var
  i: integer;
  details: step_details;
begin
  i := 0;
  setlength(remove_letter, 0);
  for details in steps do
  begin
    if details[0] <> letter then
    begin
      setlength(remove_letter, i+1);
      remove_letter[i] := details;
      inc(i);
    end;
  end;
end;

function cando_letters(steps: all_step_details) : char_array;
var
  i: integer;
  s: step_details;
  l: char;
  waiting_letters: set of char;
  starting_letters: set of char;
begin
  i := 0;
  starting_letters := [];
  waiting_letters := [];
  for s in steps do
  begin
    include(starting_letters, s[0]);
    include(waiting_letters, s[1]);
  end;
  for l in starting_letters do
  begin
    if not(l in waiting_letters) then
    begin
      setlength(cando_letters, i+1);
      cando_letters[i] := l;
      inc(i);
    end;
  end;
end;

// This should be included as part of cando_letters
function waiting_letters(steps: all_step_details) : char_array;
var
  i: integer;
  s: step_details;
  l: char;
  waiting_letters_set: set of char;
begin
  i := 0;
  waiting_letters_set := [];
  for s in steps do
  begin
    include(waiting_letters_set, s[1]);
  end;
  for l in waiting_letters_set do
  begin
    setlength(waiting_letters, i+1);
    waiting_letters[i] := l;
    inc(i);
  end;
end;

function part1 (steps: all_step_details) : string;
var
  l: char;
  next_letter: char;
  last_letter: char;
begin
  part1 := '';
  while length(steps) > 0 do
  begin
    last_letter := waiting_letters(steps)[0];
    next_letter := 'Z';
    for l in cando_letters(steps) do
    begin
      if l < next_letter then
      begin
        next_letter := l;
      end;
    end;
    steps := remove_letter(steps, next_letter);
    part1 := part1+next_letter;
  end;
  part1 := part1+last_letter;
end;

function isLetterBeingWorkedOn(workers: array of worker_details; l: char)
: boolean;
var
  w: worker_details;
begin
  isLetterBeingWorkedOn := false;
  for w in workers do
  begin
    if w.letter = l then
    begin
      isLetterBeingWorkedOn := true;
      break;
    end;
  end;
end;

function part2 (steps: all_step_details) : integer;
var
  i: integer;
  l: char;
  seconds: integer;
  workers: array of worker_details;
  last_letter: char;

begin
  setlength(workers, 5);
  for i := 0 to 5 do
  begin
    workers[i].letter := '.';
    workers[i].secs := -1;
  end;
  seconds := 0;
  while length(steps) > 0 do
  begin
    for i := 0 to 5 do
    begin
      if workers[i].letter <> '.' then
      begin
        workers[i].secs := workers[i].secs-1;
        if workers[i].secs = 0 then
        begin
          steps := remove_letter(steps, workers[i].letter);
          workers[i].letter := '.';
          workers[i].secs := -1;
        end;
      end;
    end;

    for i := 0 to 5 do
    begin
      if workers[i].letter = '.' then
      begin
        last_letter := waiting_letters(steps)[0];
        for l in cando_letters(steps) do
        begin
          if not(isLetterBeingWorkedOn(workers, l)) then
          begin
            workers[i].letter := l;
            workers[i].secs := num_seconds(l);
            break;
          end;
        end;
      end;
    end;
    inc(seconds);
  end;
  part2 := seconds + num_seconds(last_letter) -1;
end;

var
  steps: all_step_details;
begin
  steps := get_steps('day7.input');
  writeln('Part1: ', part1(steps));
  writeln('Part2: ', part2(steps));
end.
