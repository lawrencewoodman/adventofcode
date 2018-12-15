// Code for Day 8 of Advent of Code: https://adventofcode.com/2018/day/8
// F# Solution
//
// Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
// Licensed under an MIT licence.  Please see LICENCE.md for details.

open System.IO
open System

type Node = {Children: list<Node>; Meta: array<Int32>}

let rec GetChildren (header : array<Int32>) =
  let numChildNodes = header.[0]
  let folder acc i =
    let (totalNumNums,pos,children) = acc
    let (childNode, numNums) = ParseHeader header.[pos..]
    (totalNumNums+numNums, pos+numNums, childNode::children)
  let (totalNumNums,pos,children) =
    List.fold folder (0,2,[]) [0..numChildNodes-1]
  (List.rev children, totalNumNums)

and ParseHeader header =
  let numMetadata = header.[1]
  let (children, numNums) = GetChildren header
  let metadata =
    if numMetadata > 0 then
      header.[numNums+2..numNums+1+numMetadata]
    else
      [||]
  let totalNumNums = 2+numNums+numMetadata
  ({Children = children; Meta = metadata}, totalNumNums)

let rec AddMetadata (node) =
  let childrenMetadataSum =
    node.Children
    |> List.map AddMetadata
    |> List.sum
  childrenMetadataSum + Array.sum(node.Meta)

let rec AddMetadata2 (node) =
  let mapper m =
    if m <= List.length(node.Children) then
      AddMetadata2 node.Children.[m-1]
    else
      0
  if List.length(node.Children) = 0 then
    Array.sum(node.Meta)
  else
    node.Meta
    |> Array.map mapper
    |> Array.sum

let Part1 input =
  let (root, numNums) = ParseHeader input
  AddMetadata root

let Part2 input =
  let (root, numNums) = ParseHeader input
  AddMetadata2 root

let ReadInput filename : array<Int32> =
  let InputFile = File.ReadAllLines(filename)
  InputFile.[0].Split ' '
  |> Seq.map System.Int32.Parse
  |> Seq.toArray

let Input = ReadInput("day8.input")
printfn "Part1: %d" (Part1 Input)
printfn "Part2: %A" (Part2 Input)
