   .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 12
   .word 225
   .word 169
   .word 16
   .word 25
   .word 100
   .word 81
   .word 99
   .word 121
   .word 144
   .word 0 

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", isqrt(*j))
#     j++
#
main:
   # PROLOGUE
   subu $sp, $sp, 8        # expand stack by 8 bytes
   sw   $ra, 8($sp)        # push $ra (ret addr, 4 bytes)
   sw   $fp, 4($sp)        # push $fp (4 bytes)
   addu $fp, $sp, 8        # set $fp to saved $ra

   subu $sp, $sp, 8        # save s0, s1 on stack before using them
   sw   $s0, 8($sp)        # push $s0
   sw   $s1, 4($sp)        # push $s1

   la   $s0, xarr          # use s0 for j. init to xarr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # if *j == 0 go to main_end
   move $a0, $s1           # result (in v0) = isqrt(*j)
   jal  isqrt              # 
   move $a0, $v0           # print_int(result)
   li   $v0, 1
   syscall
   li   $a0, 10            # print_char('\n')
   li   $v0, 11
   syscall
   addu $s0, $s0, 4        # j++
   b    main_while
main_end:
   lw   $s0, -8($fp)       # restore s0
   lw   $s1, -12($fp)      # restore s1

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
# end main #################################################
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
