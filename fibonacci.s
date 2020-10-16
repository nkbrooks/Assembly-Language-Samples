# FIBONACCI 
	
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
	jr $ra #return address
	
# ------------
# returns:
# 0
# ------------

return0:
	move $v0, $a0 #save output 
	jr $ra #return address
	
# ------------
# returns:
# 1
# ------------

return1:
	move $v0, $a0 #save output
	jr $ra #return address

recursive:
	sub $sp, $sp, 12  #Subtracts two registers sp = sp - 12
	sw $ra, 8($sp) #store memory address for return address
	sw $s0, 4($sp) #store memory address for $s0
	sw $s1, 0($sp) #store memory address for $s1
	move $s0, $a0 #save input into $s0
	li $v0, 1 # return value for terminal condition
	ble $s0, 0x2, exit #when s0 > 0x2
	addi $a0, $s0, -1 # set args for recursive call to f(n-1)
	jal fibonacci #recalls fibonacci func recursively
	move $s1, $v0 # store result of f(n-1) into s1
	addi $a0, $s0, -2 #recursive call into f(n-2)
	jal fibonacci #recall fibonacci
	add $v0, $s1, $v0 #result of f(n-1) added to output argument
	exit: #exit 
	lw $ra, 8($sp) #load memory for output
	#(up to 8 bytes)
	lw $s0, 4($sp) #load memory for $s0
	lw $s1, 0($sp) #load memory for result of f(n-1)
	add $sp, $sp, 12 #deallocate memory
	jr $ra #return
	
# ------------
# returns:
# INT
# ------------
