#!/bin/bash

x=7274
y=870
z=14

date=`date +%Y%m%d%H00`
curl -o jam_${x}-${y}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x&y=$y&z=$z&date=$date&size=406"
curl -o map_${x}-${y}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x&y=$y&z=$z&size=406"

composite -dissolve 50%x50% jam_${x}-${y}-${z}.png map_${x}-${y}-${z}.png com_${x}-${y}-${z}.png
rclone copy "com_${x}-${y}-${z}.png" "GoogleDrive:Google フォト/rclonetest"
