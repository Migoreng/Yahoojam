#!/bin/bash

mapjamname=$1
X=$2
Y=$3
zoom=$4 #本来のZの値
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


#==== START_DATEつくる ====#
TODAY_FIRST=$(date -d '' --iso-8601=minutes)
TODAY_FIRST=$(date -d "-7 days $TODAY_FIRST" --iso-8601=minutes)
START_DATE=${TODAY_FIRST}
echo "\$START_DATE:$START_DATE"
DISPLAY_DATE=$(date -d"$TODAY_FIRST" "+%Y%m%d%H%M")
echo "\$DISPLAY_DATE:$DISPLAY_DATE"

switch=0
DATE=${START_DATE}

#=== END_DATE つくるよ===#
if [ $(date "+%M") -lt 40 -a $(date "+%M") -gt 0 ];then
END_DATE=$(date "+%Y%m%d%H00")
fi
if [ $(date "+%M") -le 59 -a $(date "+%M") -gt 40 ];then
END_DATE=$(date "+%Y%m%d%H40")
fi
echo "$END_DATEだってばよ"
#=========================#

while [ 1 ];do

DISPLAY_DATE=$(date -d "${DATE}" "+%Y%m%d%H%M")

if [ ${DISPLAY_DATE} -gt ${END_DATE} ];then
    break
fi


echo "===1==="
echo "\$DISPLAY_DATE:$DISPLAY_DATE"
echo "\$START_DATE:$START_DATE"
echo "\$DATE:$DATE"
echo "\$END_DATE:$END_DATE"


curl -o jam_${x1}-${y1}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x1&y=$y1&z=$z&date=${DISPLAY_DATE}&size=406"
curl -o jam_${x1}-${y2}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x1&y=$y2&z=$z&date=${DISPLAY_DATE}&size=406"
curl -o jam_${x2}-${y1}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x2&y=$y1&z=$z&date=${DISPLAY_DATE}&size=406"
curl -o jam_${x2}-${y2}-${z}.png -O "https://map.c.yimg.jp/jam?x=$x2&y=$y2&z=$z&date=${DISPLAY_DATE}&size=406"

if [ ! -s "mapmon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png" ];then 
curl -o map_${x1}-${y1}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x1&y=$y1&z=$z&size=406"
curl -o map_${x1}-${y2}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x1&y=$y2&z=$z&size=406"
curl -o map_${x2}-${y1}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x2&y=$y1&z=$z&size=406"
curl -o map_${x2}-${y2}-${z}.png -O "https://map.c.yimg.jp/m?r=1&x=$x2&y=$y2&z=$z&size=406"

montage map_${x1}-${y2}-${z}.png map_${x2}-${y2}-${z}.png map_${x1}-${y1}-${z}.png map_${x2}-${y1}-${z}.png -tile 2x2 -resize 100% -geometry +0+0 mapmon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png

fi

montage jam_${x1}-${y2}-${z}.png jam_${x2}-${y2}-${z}.png jam_${x1}-${y1}-${z}.png jam_${x2}-${y1}-${z}.png -tile 2x2 -resize 100% -geometry +0+0 jammon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png

composite -dissolve 50%x50% jammon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png mapmon_${x1}-${y2}-${z}_${x2}-${y2}-${z}_${x1}-${y1}-${z}_${x2}-${y1}-${z}.png ${mapjamname}_${DISPLAY_DATE}.png
#rclone copy "com_${x}-${y}-${z}.png" "GoogleDrive:Google フォト/rclonetest"


if [ $(( $switch % 2 )) -eq 0 ] ;then DATE=$(date -d "+40 minutes ${DATE}" --iso-8601=minutes) ;fi
if [ $(( $switch % 2 )) -eq 1 ] ;then DATE=$(date -d "+20 minutes ${DATE}" --iso-8601=minutes) ;fi
switch=$(( ${switch} + 1 ))

echo "===2==="
echo "\$switch:$switch"
echo "\$DISPLAY_DATE:$DISPLAY_DATE"
echo "\$START_DATE:$START_DATE"
echo "\$DATE:$DATE"
echo "\$END_DATE:$END_DATE"
done
