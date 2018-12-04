// Code for Day 3 of Advent of Code: https://adventofcode.com/2018/day/3
// C Solution
//
// Copyright (C) 2018 Lawrence Woodman <lwoodman@vlifesystems.com>
// Licensed under an MIT licence.  Please see LICENCE.md for details.

#include <stdio.h>
#include <stdlib.h>

#define BITMAPMAXX 1500
#define BITMAPMAXY 1500
#define CLAIMSIZE 100
#define MAXCLASHIDS 2000

int part1 () {
  int count;
  int x, y, maxX, maxY;
  int id, leftMargin, topMargin, width, height;
  char bitmap[BITMAPMAXY][BITMAPMAXX];
  FILE *fp;
  static char claim[CLAIMSIZE];

  for (x = 0; x < BITMAPMAXX; x++) {
    for (y = 0; y < BITMAPMAXY; y++) {
      bitmap[y][x] = 0;
    }
  }

  if ((fp = fopen("day3.input", "r")) == NULL) {
		exit(EXIT_FAILURE);
  }
  while (fgets(claim, CLAIMSIZE, fp)) {
    sscanf(claim, "#%d @ %d,%d: %dx%d",
         &id, &leftMargin, &topMargin, &width, &height);
    maxX = leftMargin + width;
    maxY = topMargin + height;
    if (maxX >= BITMAPMAXX || maxY >= BITMAPMAXY) {
      fprintf(stderr, "bitmap too small\n");
      exit(EXIT_FAILURE);
    }
    for (x = leftMargin + 1; x <= maxX; x++) {
      for (y = topMargin + 1; y <= maxY; y++) {
        bitmap[y][x]++;
      }
    }
  }

  fclose(fp);

  count = 0;
  for (x = 0; x < BITMAPMAXX; x++) {
    for (y = 0; y < BITMAPMAXY; y++) {
      if (bitmap[y][x] >= 2) {
        count++;
      }
    }
  }
  return count;
}

int part2 () {
  int clashIDS[MAXCLASHIDS];
  int maxID = 0;
  int x, y, maxX, maxY;
  int id, leftMargin, topMargin, width, height;
  short bitmap[BITMAPMAXY][BITMAPMAXX];
  FILE *fp;
  static char claim[CLAIMSIZE];

  for (x = 0; x < BITMAPMAXX; x++) {
    for (y = 0; y < BITMAPMAXY; y++) {
      bitmap[y][x] = 0;
    }
  }
  if ((fp = fopen("day3.input", "r")) == NULL) {
    fprintf(stderr, "Couldn't open input\n");
		exit(EXIT_FAILURE);
  }
  while (fgets(claim, CLAIMSIZE, fp)) {
    sscanf(claim, "#%d @ %d,%d: %dx%d",
         &id, &leftMargin, &topMargin, &width, &height);
    maxX = leftMargin + width;
    maxY = topMargin + height;
    if (id >= MAXCLASHIDS) {
      fprintf(stderr, "clashIDS too small\n");
      exit(EXIT_FAILURE);
    }
    for (x = leftMargin + 1; x <= maxX; x++) {
      for (y = topMargin + 1; y <= maxY; y++) {
        if (bitmap[y][x] >= 1) {
          clashIDS[id] = 1;
          maxID = id > maxID ? id : maxID;
          clashIDS[bitmap[y][x]] = 1;
        } else {
          bitmap[y][x] = id;
        }
      }
    }
  }

  fclose(fp);

  for (id = 1; id <= maxID; id++) {
    if (clashIDS[id] == 0) {
      return id;
    }
  }
  return -1;
}

void main(void) {
  printf("part1: %d\n", part1());
  printf("part2: %d\n", part2());
}
