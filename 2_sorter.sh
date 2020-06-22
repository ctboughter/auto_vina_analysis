#!/bin/bash

# So by accident, my wild_ligand_maker takes the PERMUTATION
# of all possible oxygen positions (2730 results)
# Order doesn't matter here though, so we want combinations
# ( I think I remember that correctly from Freshman Stats)

for i in $( ls final_ligs/ ) 
do 
    a=$(echo $i | awk -F "." '{print $2}')
    b=$(echo $i | awk -F "." '{print $3}')    
    c=$(echo $i | awk -F "." '{print $4}')
    
    if [ -z "$(ls -A uniq_combos)" ]
        then mv final_ligs/$i uniq_combos/.
    fi

    for j in $( ls uniq_combos )
    do
	  a2=$(echo $j | awk -F "." '{print $2}')
	  b2=$(echo $j | awk -F "." '{print $3}')    
	  c2=$(echo $j | awk -F "." '{print $4}')
	  
	  # Hard code in the combinations (not great)
	  if [ $a == $a2 -a $b == $b2 -a $c == $c2 ]
	  then
	      continue 2
	  fi

	  if [ $a == $b2 -a $b == $c2 -a $c == $a2 ]
	  then
	      continue 2
	  fi

	  if [ $a == $c2 -a $b == $b2 -a $c == $a2 ]
	  then
	      continue 2
	  fi

	  if [ $a == $c2 -a $b == $a2 -a $c == $b2 ]
	  then
	      continue 2
	  fi

	  if [ $a == $b2 -a $b == $a2 -a $c == $c2 ]
	  then
	      continue 2
	  fi

	   if [ $a == $a2 -a $b == $c2 -a $c == $b2 ]
	  then
	      continue 2
	  fi
    done
    # Pretty sure that we shouldn't be able to get through
    # the j loop unless the sum does not exist in
    mv final_ligs/$i uniq_combos/.
done
