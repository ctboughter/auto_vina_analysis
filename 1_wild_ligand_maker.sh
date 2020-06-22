#!/bin/bash

# So this script is going to systematically place the oxygens on
# every carbon tail (from 1-10 and 19-23). The 3 oxygens in question
# are serial 18,24 and 25... Let's get going

# Cycle through  all of the carbon options we are interested in
for i in {1..10} {19..23};
	do 
        # There is a certain sidedness to where the oxygens go
        # in physical space. This was determined through inspection
	if [ $i -gt 11 ]
		then o_y=-10.3520
        fi      
        if [ $i -lt 11 ] 
        	then o_y=-13.6901
        fi 
        # Notice the fliparound here for even entries
	# Definitely could have written this up cleaner
	# But no chance I go back to re-write
	if [ $(( $i % 2 )) == 0 ] 
		then 
		if [ $i -lt 11 ]
			then o_y=-10.3520
		fi
		if [ $i -gt 11 ]
			then o_y=-13.6901
		fi
	fi

	# leave the long-ass name we're using as a template
	# that way future users know what the base molecule was
	head -21 n-trihydroxypalmitoyl-glycine.mol > lig.$i.mol
	# grab the x-coordinate of our carbon of choice
	c_x=$(grep " $i " carbon.txt | awk '{print $2}')
	# Place our rogue oxygen first
	echo "   $c_x  $o_y    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0" >> lig.$i.mol
	# hard code in a couple more carbons that we know we aren't changing
	echo "   14.1119  -11.6553    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0" >> lig.$i.mol
	echo "   12.9525  -12.3069    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0" >> lig.$i.mol
	echo "   11.8084  -11.6287    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0" >> lig.$i.mol
	echo "   10.6490  -12.2803    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0" >> lig.$i.mol
	echo "   9.5049   -11.6020    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0" >> lig.$i.mol

	for j in {1..10} {19..23};
        	do      

		if [ $j == $i ]
		then continue
		fi
	
		cp lig.$i.mol lig.$i.$j.mol

        	if [ $j -gt 11 ]
                	then o_y=-10.3520
        	fi        
        	if [ $j -lt 11 ]        
                	then o_y=-13.6901
        	fi        
     # Notice the fliparound here for even entries
        	if [ $(( $j % 2 )) == 0 ]  
                	then 
                	if [ $j -lt 11 ]
                        	then o_y=-10.3520
                	fi      
                	if [ $j -gt 11 ] 
                        	then o_y=-13.6901
                	fi      
        	fi      

        	c_x=$(grep " $j " carbon.txt | awk '{print $2}')
        	echo "   $c_x  $o_y    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0" >> lig.$i.$j.mol

		for k in {1..10} {19..23};
        		do

        			if [ $k == $i ]
        			then 
					continue
        			fi

				if [ $k == $j ]
				then 
					continue
				fi
				cp lig.$i.$j.mol lig.$i.$j.$k.mol
        			if [ $k -gt 11 ]
                		then 
					o_y=-10.3520
        			fi
        			if [ $k -lt 11 ]
                		then 
					o_y=-13.6901
        			fi
     # Notice the fliparound here for even entries
			        if [ $(( $k % 2 )) == 0 ]
                		then
                			if [ $k -lt 11 ]
                        		then 
						o_y=-10.3520
                			fi
                			if [ $k -gt 11 ]
                        		then 
						o_y=-13.6901
                			fi
        			fi

        			c_x=$(grep " $k " carbon.txt | awk '{print $2}')
        			echo "   $c_x  $o_y    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0" >> lig.$i.$j.$k.mol

				tail -25 n-trihydroxypalmitoyl-glycine.mol >> lig.$i.$j.$k.mol
				sed "s/ 2 18  1  0  0  0  0/$i 18  1  0  0  0  0 /g" lig.$i.$j.$k.mol > test
				sed "s/23 24  1  0  0  0  0/$j 24  1  0  0  0  0 /g" test > test1
                                sed "s/ 3 25  1  0  0  0  0/$k 25  1  0  0  0  0 /g" test1 > test2
				mv test2 lig.$i.$j.$k.mol
				rm test1 test
		done
	done
done
