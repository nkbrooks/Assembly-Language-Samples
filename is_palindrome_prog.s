   .data
str1:
   .asciiz "abba"
str2:
   .asciiz "racecar"
str3:
   .asciiz "swap paws",
str4:
   .asciiz "not a palindrome"
str5:
   .asciiz "another non palindrome"
str6:
   .asciiz "almost but tsomla"

# array of char pointers = {&str1, &str2, ..., &str6}
ptr_arr:
   .word str1, str2, str3, str4, str5, str6, 0

yes_str:
   .asciiz " --> Y\n"
no_str:
   .asciiz " --> N\n"

   .text

# main(): ##################################################
#   char ** j = ptr_arr
#   while (*j != 0):
#     rval = is_palindrome(*j)
#     printf("%s --> %c\n", *j, rval ? yes_str: no_str)
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

   la   $s0, ptr_arr        # use s0 for j. init ptr_arr
main_while:
   lw   $s1, ($s0)         # use s1 for *j
   beqz $s1, main_end      # while (*j != 0):
   move $a0, $s1           #    print_str(*j)
   li   $v0, 4
   syscall
   move $a0, $s1           #    v0 = is_palindrome(*j)
   jal  is_palindrome
   beqz $v0, main_print_no #    if v0 != 0:
   la   $a0, yes_str       #       print_str(yes_str)
   b    main_print_resp
main_print_no:             #    else:
   la   $a0, no_str        #       print_str(no_str)
main_print_resp:
   li   $v0, 4
   syscall

   addu $s0, $s0, 4       #     j++
   b    main_while        # end while
main_end:

   # EPILOGUE
   move $sp, $fp           # restore $sp
   lw   $ra, ($fp)         # restore saved $ra
   lw   $fp, -4($sp)       # restore saved $fp
   j    $ra                # return to kernel
# end main ################################################

# Palindrome - Project 5 - by Natalie Brooks, nkbrooks, 116009829

#calling the function
#$a0 is parameter
#$v0 is what is being returned
# ------------
# arguments:
# a0 = *j string
# ------------
strlen: #calls strlen function

	addi $v0, $zero, 0 #set return value to 0
	strlen_loop:#for loop
	lb $t0, 0($a0) #load byte from beginning
	beqz $t0,strlen_exit #when character value == 0
	#go to strlen_exit
	add $a0, $a0, 1 #increment pointer to string array
	add $v0, $v0, 1 #increment return value by one
	j strlen_loop #go back to the top of loop

strlen_exit:
# ------------
# returns:
# strlen(string length)
# ------------
	jr $ra #return

is_palindrome:
# ------------
# arguments:
# a0 = string *j
# ------------

	sub $sp, $sp, 8 #allocate 8 bytes 
	sw $a0 4($sp) #save int value
	sw $ra 0($sp) #save return address

	jal strlen #call strlen function
	move $t0, $v0 #save result

	lw $a0 4($sp) #load argument
	move $t1, $a0 #save its value to t1

	li $t2, 1 #set counter to 1
	li $v0, 1 #reintialize return value
	div $t3, $t0, 2 #calculate strlen / 2
	add $t3, $t3, 1 #add one more in case of even number
	loop:			
	bge $t2, $t3 exit #when counter equals strlen/2
	lb $t4, 0($a0) #load first byte of array

	sub $t5, $t0, $t2 #subtract counter from the string length
	add $t6, $t5, $t1 #add index from the end of the string to start ad	   dress
	lb $t7, 0($t6) #get character from the end of the string

	beq $t4, $t7, continue #loop through to check if characters match
	li $v0,0  #if not return 0
	j exit

	continue:
	add $a0, $a0, 1 #increment pointer by one
	add $t2, $t2, 1 #increment counter by one
	j loop

exit:
# ------------
# returns:
# TRUE (1) or FALSE (0)
# ------------
	lw $ra 0($sp) #load return address
	add $sp, $sp, 8 #deallocate memory
	jr $ra #return
