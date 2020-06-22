#!/bin/bash

# Need to go through and find the 3 carbon positions, AND find the
# highest free energy of each. Looking like they're gonna be similar

# print out the 30th row

echo 'c1  c2  c3  G' > energy_out.dat
for i in $( ls vina_outfiles/log*txt )
do
    c1=$( awk 'FNR == 16 {print}' $i | awk -F '.' '{print $2}' )
    c2=$( awk 'FNR == 16 {print}' $i | awk -F '.' '{print $3}' )
    c3=$( awk 'FNR == 16 {print}' $i | awk -F '.' '{print $4}' )
    G=$( awk 'FNR == 28 {print}' $i | awk '{print $2}')
    if [ -z $G ]
    then
	continue
    fi
    echo "$c1  $c2  $c3  $G" >> energy_out.dat
done
