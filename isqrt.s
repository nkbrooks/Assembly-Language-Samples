# isqrt - Project 5 - by Natalie Brooks, nkbrooks, 116009829

#calling the function
#$a0 is parameter
#$v0 is what is being returned
# ------------
# arguments:
# a0 = *j string
# ------------
isqrt:
	li  $v0, 0        	# initialize return
	move  $t1, $a0          # save *j string into $t0
	li  $t0, 1		#initialize bit to 1
	sll $t0, $t0, 30      	# shift to second bit from the top
	#$t0 = $t0 << 30

isqrt_bit:
	slt  $t2, $t1, $t0     	# num < bit
	beqz  $t2,loop          #if $t2 == 0
	#go to loop
	srl  $t0, $t0, 2       	# bit >> 2
	j   isqrt_bit           #go back to top of the loop

loop:
	beqz  $t0, exit	        #if bit is 0, return memory address
	add  $t3, $v0, $t0     	# t3 = return + bit
	slt  $t2, $t1, $t3	# input < t3
	beqz  $t2, else         #if input is greater
	srl  $v0, $v0, 1       	# return >> 1
	j    loop_end           #go back to top of the loop
	
else:
	sub $t1, $t1, $t3     	# num -= return + bit
	srl $v0, $v0, 1       	# return >> 1
	add $v0, $v0, $t0     	# return + bit

loop_end:
	srl $t0, $t0, 2       	# bit >> 2
	j  loop			#go back to top of the loop
	jr $ra			#returns address

exit:
	jr  $ra			#returns address
# ------------
# returns:
# Integer square root
# ------------
