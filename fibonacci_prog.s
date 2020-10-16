   .data

# array terminated by 0 (which is not part of the array)
xarr:
   .word 1
   .word 2
   .word 3
   .word 4
   .word 5
   .word 6
   .word 7
   .word 8
   .word 9
   .word 10
   .word 11
   .word 12
   .word 13
   .word 14
   .word 15
   .word 16
   .word 17
   .word 18
   .word 19
   .word 20
   .word 21
   .word 22
   .word 23
   .word 24
   .word 0

   .text

# main(): ##################################################
#   uint* j = xarr
#   while (*j != 0):
#     printf(" %d\n", fibonacci(*j))
#     j++
#
main:
   li   $sp, 0x7ffffffc    # initialize $sp

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
   move $a0, $s1
   jal  fibonacci          # result = fibonacci(*j)
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
## end main #################################################
# FIBONACCI - Project 5 - by Natalie Brooks, nkbrooks, 116009829
	
#calling the function
#$a0 is parameter
#$v0 is what is being returned
# ------------
# arguments:
# a0 = *j string
# ------------
fibonacci:

	beq $a0, 1, return1 #if 1 return 1
	beqz $a0, return0 #if 0 return 0
	bgt $a0, 1, recursive #if
	#not 1 || 0 go to recursive func
	move $v0, $a0 #save output
	jr $ra #return

return0:
	move $v0, $a0 #save output
	jr $ra #return

return1:
	move $v0, $a0 #save output
	jr $ra #return

recursive:
	sub $sp, $sp, 12  #Subtracts two registers 
	sw $ra, 8($sp) #store memory address  8 bytes 
	sw $s0, 4($sp) #store memory address for $s0
	sw $s1, 0($sp) #store memory address for $s1
	move $s0, $a0 #save input into $s0
	li $v0, 1 # return value for terminal condition
	ble $s0, 0x2, exit
	addi $a0, $s0, -1 # set args for recursive call to f(n-1)
	jal fibonacci
	move $s1, $v0 # store result of f(n-1) to s1
	addi $a0, $s0, -2 #recursive call to f(n-2)
	jal fibonacci #recall fibonacci
	add $v0, $s1, $v0 #result of f(n-1)
	exit: #exit
	lw $ra, 8($sp) #load memory
	lw $s0, 4($sp) #load memory
	lw $s1, 0($sp) #load memory
	add $sp, $sp, 12 #increment by 12
	jr $ra #return
	
# ------------
# returns:
# INT
# ------------
