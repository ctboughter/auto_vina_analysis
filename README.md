# auto_vina_analysis

NOTE: For now, this is really only for those who have some familiarity with bash
programming and the inputs inherent to autodock vina. It should be used as inspiration
for other new projects, and sections of the code should be borrowed. It is actually NOT
currently able to be run on a given computer without some light editing. Hopefully
in updates I can make it more adaptable for different applications.

Orginally wrote these scripts probably two years ago, here
was the original goal of it all:

######### Time Travel to 2018 #############
So the goal is to take the mol file that Curtis sent me with the "guessed"
hydroxyl locations. I believe vina makes the ligand flexible, so we
don't actually need to do stereochemistry (hence 0 everywhere in Z)

So we need to change the X-values of all of the Oxygens, but then also
change the vina input commands. I think we should only need to change
one line in the input commands though, which is nice

We only move oxygens: 18, 24, and 25

we only put them on carbons: 1-10, 19-23

######## Come back to modern day #########

So you can run through and re-create the original analysis,
to understand exactly what it does (warning, it will be slow)
or you can just try to adapt it yourself.

Here are the steps to run the original analysis:

1) Run 1_wild_ligand_maker.sh in some folder. This will create a massive number of *mol files.
In this step, we are taking the three oxygens and moving them around in physical
space, attaching them to every possible permutation of carbons we are interested in.
For *.mol files, it turns out it really doesn't matter in what order you define an atom
so long as you remember what number entry it is in the full atom list. So here, the first
oxygen atom we want to shuffle around is always entry number 18. We can arbitrarily move
the position of this oxygen 18 to anywhere in space. Then, at the bottom of the *.mol file
we actually specify where the bonds are and should be. You could imagine doing a similar
thing with amino acids, where you have your carbon backbone position and arbitrarily add
in side chains. This will take a good bit of work, but may be worth it in the long run...
NOTE, I wrote this in a very lazy manner. It turns out we only want *combinations* of
the positions, not *permutations*. Which brings us to step 2.

2) Make directories called final_ligs and uniq_combos, and put all of the newly generated 
*mol files into the final_ligs directory. Then, run 2_sorter.sh. This is necessary because
of that combinations vs. permutations point above. NOTE, this step will become redundant
if I actually go through and fix the code in step 1 at some point...

3) Run 3_converter.sh. This is because we need to go *.mol file to *.pdb file to *.pdbqt
file. NOTE, to run all of this stuff, you will need to have autodock vina installed.

4) Run 4_high_throughput_vina.sh. Now this is where we actually run autodock vina.
You need to already have your pdbqt file prepared for this. Also note how I have
a custom system for creating the vina search space. I think this is fairly well
commented, so read through the sections that need to be changed

5) Run 5_final_analysis.sh. Lastly, there is an analysis script created specifically
for this application of a lipid-like ligand. From the output files, you can pull out
a nice summarry across ALL of the new files... This is where I should note, however,
that I don't personally trust vina's scoring function to compare ligands. I think it
is incredibly powerful for trying to guess how a *known* ligand binds to a structure,
but if you are trying to use it for ligand screening, you might be playing with fire.
