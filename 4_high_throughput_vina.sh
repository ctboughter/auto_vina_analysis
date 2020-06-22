#!/bin/bash

# Start off by defining which directory you are in
# As an example, I'll use my path, but you'll NEED to change this
# This one is the working directory
path=/Users/boughter/Desktop/vina_stuff
# This one is wherever your vina is
vina_path=/Users/boughter/Desktop/vina

# So heres the deal, create a script that runs
# through all of the options quickly, then outputs the
# final structure files and docking results
# the sort command here makes sure that we actually get the ligans in numerical
# order so that we can maintain that from the original key file.
ls $path/pdbqt_combos/*.pdbqt | sort -n -t g -k 2 > $path/tests.txt

# Still use MR1
receptor=$(echo $path/prot.pdbqt)

# Here is how we loop around the different ligand files (originally was stupid and
# had this loop above the pocket determination... but this only needs to be done once
# Idea: get the values for the center of the binding pocket and the
# size by selecting the residues in the pocket and getting their coordinates
cp $path/prot.pdb .
# Need to start a smaller loop here for picking out the residues:

startres=48
grep CA prot.pdb | awk '$6=='$startres' {print $7}' > x_coor.txt
grep CA prot.pdb | awk '$6=='$startres' {print $8}' > y_coor.txt
grep CA prot.pdb | awk '$6=='$startres' {print $9}' > z_coor.txt

# Almost kind of automated... just need to know the residues framing your binding pocket
# Here it is residue 49 to 85 and 133 to 176
a=49 
while [ $a -le 85 ]
do
    grep CA prot.pdb | awk '$6=='$a' {print $7}' >> x_coor.txt
    grep CA prot.pdb | awk '$6=='$a' {print $8}' >> y_coor.txt
    grep CA prot.pdb | awk '$6=='$a' {print $9}' >> z_coor.txt
    a=$[$a+1]
done

a=133
while [ $a -le 176 ]
do
    grep CA prot.pdb | awk '$6=='$a' {print $7}' >> x_coor.txt
    grep CA prot.pdb | awk '$6=='$a' {print $8}' >> y_coor.txt
    grep CA prot.pdb | awk '$6=='$a' {print $9}' >> z_coor.txt
    a=$[$a+1]
done 

# Now we need to do some math (add the columns)
awk '{sum += $1} END {print sum}' x_coor.txt > x_coor2.txt
awk '{sum += $1} END {print sum}' y_coor.txt > y_coor2.txt
awk '{sum += $1} END {print sum}' z_coor.txt > z_coor2.txt
#(do the division, dividing by number of residues)
xcoor=$(awk 'BEGIN {FS=OFS=","} {for (i=1; i<=NF; i++) $i/=81;}1' x_coor2.txt)
ycoor=$(awk 'BEGIN {FS=OFS=","} {for (i=1; i<=NF; i++) $i/=81;}1' y_coor2.txt)
zcoor=$(awk 'BEGIN {FS=OFS=","} {for (i=1; i<=NF; i++) $i/=81;}1' z_coor2.txt)

# Need to determine the size of the box by finding the max and min
# of each of these columns (then subtract these maxs and mins)
# notice that the r in sort is the only difference between getting max and min
xmax=$(sort -nrk1,1 x_coor.txt | head -1)
xmin=$(sort -nk1,1 x_coor.txt | head -1)
ymax=$(sort -nrk1,1 y_coor.txt | head -1)
ymin=$(sort -nk1,1 y_coor.txt | head -1)
zmax=$(sort -nrk1,1 z_coor.txt | head -1)
zmin=$(sort -nk1,1 z_coor.txt | head -1)

# Apparently bc is a function that let's you do floating point operations so...
xbox=$(echo "$xmax - $xmin" | bc | awk ' { if($1>=0) { print $1} else {print $1*-1 }}')
ybox=$(echo "$ymax - $ymin" | bc | awk ' { if($1>=0) { print $1} else {print $1*-1 }}')
zbox=$(echo "$zmax - $zmin" | bc | awk ' { if($1>=0) { print $1} else {print $1*-1 }}')
# awk takes the absolute value of the function

#now loop to make the config files and run autodock vina
z=1
len=$(wc -l tests.txt | awk '{print $1}')
while [ $z -le $len ]
do
    ligand=$(awk 'FNR == '$z' {print}' tests.txt)

# create the configuration file
    echo "receptor = $receptor" > config.txt
    echo "ligand = $ligand" >> config.txt
# to actually get the values for this, need to actually 
    echo "center_x = $xcoor" >> config.txt
    echo "center_y = $ycoor" >> config.txt
    echo "center_z = $zcoor" >> config.txt
    echo "size_x = $xbox" >> config.txt
    echo "size_y = $ybox" >> config.txt
    echo "size_z = $zbox" >> config.txt
    echo "exhaustiveness = 15" >> config.txt

# and now actually run vina with these...

    $vina_path/vina --config config.txt --log log$z.txt

    z=$[$z+1]
done
