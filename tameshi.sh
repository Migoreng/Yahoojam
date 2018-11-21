#!/bin/bash

for i in $( seq -f %02g 0 59 );do
echo -n $i:
curl -o /dev/null -s "https://map.c.yimg.jp/jam?x=7274&y=870&z=14&date=2018112107$i&size=406" -w '%{http_code}\n'
done
