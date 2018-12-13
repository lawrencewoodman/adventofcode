10 rem code for day 6 of advent of code
20 rem commodore 128 basic
30 rem
40 rem copyright (c) 2018 lawrence woodman
50 rem licensed under an mit licence.

100 gosub 6000: rem get coordinate stats
110 dim di(nc)
120 gosub 8000: rem part1
130 gosub 9000: rem part2
140 end


1000 rem manhatten distance subroutine
1001 rem args: ma mb mc md
1002 rem representing: x1 y1 x2 y2
1003 rem ret: d
1010 d = abs(ma-mc) + abs(mb-md)
1020 return


2000 rem create distances subroutine
2001 rem args: x, y
2002 rem populates: di array (distances)
2010 for n = 1 to nc
2020 read ix, iy
2030 ma = x: mb = y: mc = ix: md = iy
2040 gosub 1000: rem manhatten distance
2050 di(n) = d
2060 next n
2070 restore 10020
2080 return


3000 rem check if clashes
3001 rem args: di
3002 rem ret: c (1 if clashes else 0)
3010 nd = (mx+2)*(my+2): rem nearest distance
3020 nn = 100: rem nearest num
3030 c = 0: rem clash = false
3040 for n = 1 to nc
3050 if di(n) = nd then c = 1: else begin
3060 if di(n) < nd then nn = n: nd = di(n): c = 0
3070 bend
3080 next n
3090 return

4000 rem make areas and excludes subroutine
4010 dim e(nc): rem excludes
4020 dim a(nc): rem areas
4030 print "progress:   0%";
4040 for y = 0 to my+2
4050 print chr$(20);chr$(20);chr$(20);chr$(20);
4060 print using "###%";int((y*100)/(my+2));
4070 for x = 0 to mx+2
4080 gosub 2000: rem create distances to coords from x,y
4090 gosub 3000: rem check if clashes
4100 if c = 1 then n=255: else n=nn
4110 if n <> 255 then begin
4120 if x = 0 then e(n) = 1
4130 if y = 0 then e(n) = 1
4140 if x = mx+2 then e(n) = 1
4150 if y = my+2 then e(n) = 1
4160 if e(n) = 0 then a(n) = a(n) + 1
4170 bend
4180 next x
4190 next y
4200 print
4210 return

5000 rem find biggest subroutine
5010 bg = 0
5020 for n = 1 to nc
5030 if a(n) > bg then begin
5040 if e(n) = 0 then bg = a(n)
5050 bend
5060 next n
5070 return

6000 rem get coordinate stats (nc, mx, my)
6010 mx = 0
6020 my = 0
6030 read nc: rem number of coordinates
6040 for n = 1 to nc
6050 read x, y
6060 if x > mx then mx = x
6070 if y > my then my = y
6080 next n
6090 restore 10020
6100 return

7000 rem find safe region size subroutine
7010 rs = 0: rem region size
7020 print "progress:   0%";
7030 for y = 0 to my
7040 print chr$(20);chr$(20);chr$(20);chr$(20);
7050 print using "###%";int((y*100)/my);
7060 for x = 0 to mx
7070 td = 0: rem total distance
7080 for n = 1 to nc
7090 read ix, iy
7100 ma = x: mb = y: mc = ix: md = iy
7110 gosub 1000: rem manhatten distance
7120 td = td + d
7130 next n
7140 if td < 10000 then rs = rs + 1
7150 restore 10020
7160 next x
7170 next y
7180 print
7190 return

8000 rem part1 subroutine
8010 print "part1": print "====="
8020 gosub 4000: rem make areas and excludes
8030 gosub 5000: rem find biggest
8040 print "answer: ";bg
8050 return

9000 rem part2 subroutine
9010 print "part2": print "====="
9020 gosub 7000: rem find safe region size subroutine
9030 print "answer: ";rs
9040 return


10000 rem day6 test input
10010 data 50: rem number of coordinates
10020 rem the coordinates
10010 data 154, 159, 172, 84, 235, 204, 181, 122
10020 data 161, 337, 305, 104, 128, 298, 176, 328
10030 data 146, 71, 210, 87, 341, 195, 50, 96
10040 data 225, 151, 86, 171, 239, 68, 79, 50
10050 data 191, 284, 200, 122, 282, 240, 224, 282
10060 data 327, 74, 158, 289, 331, 244, 154, 327
10070 data 317, 110, 272, 179, 173, 175, 187, 104
10080 data 44, 194, 202, 332, 249, 197, 244, 225
10090 data 52, 127, 299, 198, 123, 198, 349, 75
10100 data 233, 72, 284, 130, 119, 150, 172, 355
10110 data 147, 314, 58, 335, 341, 348, 236, 115
10120 data 185, 270, 173, 145, 46, 288, 214, 127
10130 data 158, 293, 237, 311
