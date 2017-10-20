#!/bin/sh

cat $1 |awk -F ',' '{print $1,$4,$5,$6,$7}'|awk '{print $4,$5,$6,$7}' > $2
mv *.csv ../data/gen/
mv $2 ../data/gen/
