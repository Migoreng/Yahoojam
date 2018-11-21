#!/bin/bash

mapjamname='Shinjuku'
X=14549
Y=6451
zoom=14 #本来のZの値
z=$(($zoom + 1))

 if [ $zoom -eq 0 ]; then   Y=$Y ;fi
 if [ $zoom -eq 1 ]; then   Y=$((0 - $Y)) ;fi
 if [ $zoom -eq 2 ]; then   Y=$((1 - $Y)) ;fi
 if [ $zoom -eq 3 ]; then   Y=$((3 - $Y)) ;fi
 if [ $zoom -eq 4 ]; then   Y=$((7 - $Y)) ;fi
 if [ $zoom -eq 5 ]; then   Y=$((15 - $Y)) ;fi
 if [ $zoom -eq 6 ]; then   Y=$((31 - $Y)) ;fi
 if [ $zoom -eq 7 ]; then   Y=$((63 - $Y)) ;fi
 if [ $zoom -eq 8 ]; then   Y=$((127 - $Y)) ;fi
 if [ $zoom -eq 9 ]; then   Y=$((255 - $Y)) ;fi
 if [ $zoom -eq 10 ]; then  Y=$((511 - $Y)) ;fi
 if [ $zoom -eq 11 ]; then  Y=$((1023 - $Y)) ;fi
 if [ $zoom -eq 12 ]; then  Y=$((2047 - $Y)) ;fi
 if [ $zoom -eq 13 ]; then  Y=$((4095 - $Y)) ;fi
 if [ $zoom -eq 14 ]; then  Y=$((8191 - $Y)) ;fi
 if [ $zoom -eq 15 ]; then  Y=$((16383 - $Y)) ;fi
 if [ $zoom -eq 16 ]; then  Y=$((32767 - $Y)) ;fi
 if [ $zoom -eq 17 ]; then  Y=$((65535 - $Y)) ;fi
 if [ $zoom -eq 18 ]; then  Y=$((131071 - $Y)) ;fi
 if [ $zoom -eq 19 ]; then  Y=$((262143 - $Y)) ;fi
 if [ $zoom -eq 20 ]; then  Y=$((524287 - $Y)) ;fi

x1=$X
x2=$(($x1 + 1))
y1=$Y
y2=$(($y1 + 1))


for D in $( seq -f %02g 14 21 );do
for H in $( seq -f %02g 0 23 );do
for M in 00 40;do
date=`date +%Y11${D}${H}${M}` #%Mの値は00または40でなければデータ取得に失敗するのでcronで回すときは考慮して

echo "えこーーー$date"

curl -o map_${x1}-${y1}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x1&y=$y1&z=$z&size=406"
curl -o map_${x1}-${y2}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x1&y=$y2&z=$z&size=406"
curl -o map_${x2}-${y1}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x2&y=$y1&z=$z&size=406"
curl -o map_${x2}-${y2}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x2&y=$y2&z=$z&size=406"

curl -o jam_${x1}-${y1}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x1&y=$y1&z=$z&date=$date&size=406"
curl -o jam_${x1}-${y2}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x1&y=$y2&z=$z&date=$date&size=406"
curl -o jam_${x2}-${y1}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x2&y=$y1&z=$z&date=$date&size=406"
curl -o jam_${x2}-${y2}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x2&y=$y2&z=$z&date=$date&size=406"

montage map_${x1}-${y2}-${z}.png map_${x2}-${y2}-${z}.png map_${x1}-${y1}-${z}.png map_${x2}-${y1}-${z}.png -tile 2x2 -resize 100% -geometry +0+0 mapmon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png
montage jam_${x1}-${y2}-${z}.png jam_${x2}-${y2}-${z}.png jam_${x1}-${y1}-${z}.png jam_${x2}-${y1}-${z}.png -tile 2x2 -resize 100% -geometry +0+0 jammon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png

composite -dissolve 50%x50% jammon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png mapmon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png ${mapjamname}_${date}.png
#rclone copy "com_${x}-${y}-${z}.png" "GoogleDrive:Google フォト/rclonetest"
done
done
done
