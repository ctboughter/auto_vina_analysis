#!/bin/bash

# Need to convert these *.mol files to the pdb files, which we
# THEN convert to a pdbqt file (and add hydrogens)

for i in $( ls uniq_combos/*mol )
do
    babel -i mol $i -o pdb $i.pdb
    # I think this should automatically change it to pdbqt
    pythonsh prepare_ligand4.py -l $i.pdb -A checkhydrogens
done

# this ought to be slow as shit
