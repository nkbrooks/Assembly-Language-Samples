
# Palindrome
#calling the function
#$a0 is parameter
#$v0 is what is being returned
# ------------
# arguments:
# a0 = *j string
# ------------
strlen: #calls strlen function

	addi $v0, $zero, 0 	#set return value to 0
	strlen_loop:		#for loop
	lb $t0, 0($a0) 		#load byte from beginning
	beqz $t0,strlen_exit 	#when character value == 0
				#go to strlen_exit
	add $a0, $a0, 1 	#increment pointer to string array
	add $v0, $v0, 1 	#increment counter by one
	j strlen_loop 		#go back to the top of loop
# ------------
# returns:
# strlen(string length)
# ------------
strlen_exit:

	jr $ra 			#return address

# ------------
# arguments:
# a0 = string *j
# ------------
is_palindrome:

	sub $sp, $sp, 8 	#allocate 8 bytes - sp = sp-8
	sw $a0 4($sp) 		#save int value
	sw $ra 0($sp) 		#save return address
	jal strlen 		#call strlen function
	move $t0, $v0 		#save result
	lw $a0 4($sp) 		#load argument
	move $t1, $a0 		#save its value to t1
	li $t2, 1 		#list counter to 1
	li $v0, 1 		#reintialize return value
	div $t3, $t0, 2 	#calculate strlen / 2
	add $t3, $t3, 1 	#add one more in case of even number
	loop:			
	bge $t2, $t3 exit 	#when counter equals strlen/2
	lb $t4, 0($a0) 		#load first byte of array

	sub $t5, $t0, $t2 	#subtract counter from the string length
	add $t6, $t5, $t1 	#add index from the end
				#of the string to start address
	lb $t7, 0($t6) 		#get character from the end of the string
	beq $t4, $t7, continue #loop through to check if characters match
	li $v0,0  		#if not return 0
	j exit
	continue:
	add $a0, $a0, 1 	#increment pointer by one in array
	add $t2, $t2, 1 	#increment counter by one in array
	j loop 			#go back to top of the loop

exit: 
# ------------
# returns:
# TRUE (1) or FALSE (0)
# ------------
	lw $ra 0($sp) 		#load return address
	add $sp, $sp, 8 	#deallocate memory
	jr $ra 			#return address
