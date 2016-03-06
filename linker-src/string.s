# CS 61C Spring 2016 Project 2-2 
# string.s

#==============================================================================
#                              Project 2-2 Part 1
#                               String README
#==============================================================================
# In this file you will be implementing some utilities for manipulating strings.
# The functions you need to implement are:
#  - strlen()
#  - strncpy()
#  - copy_of_str()
# Test cases are in linker-tests/test_string.s
#==============================================================================

.data
newline:	.asciiz "\n"
tab:		.asciiz "\t"

.text
#------------------------------------------------------------------------------
# function strlen()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string input
#
# Returns: the length of the string
#------------------------------------------------------------------------------
strlen:
	addiu $t0, $0, 0		#Initial Char Count 0.
strlenLoop:
	lb $t1, 0($a0)			#load current char.
	beqz $t1, strlenEnd		#compare if current char is '\0'.
	addiu $t0, $t0, 1		#add one to count.
	addiu $a0, $a0, 1		#point to the next char.
	j strlenLoop
strlenEnd:
	addiu $v0, $t0, 0
	jr $ra

#------------------------------------------------------------------------------
# function strncpy()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = pointer to destination array
#  $a1 = source string
#  $a2 = number of characters to copy
#
# Returns: the destination array
#------------------------------------------------------------------------------
strncpy:
	addiu $v0, $a0, 0		#return the copied string.
strncpyLoop:
	beqz $a2, strncpyEnd	#end if n == 0.
	lb $t1, 0($a1) 			#load the char to be copied.
	beqz $t1 strncpyEnd 	#Nothing to be copied.
	sb $t1, 0($a0)			#store the loaded char to dest.
	addiu $a1, $a1, 1 		#next char to be read.
	addiu $a0, $a0, 1		#next location to be written.
	addiu $a2, $a2, -1		#n--.
	j strncpyLoop
strncpyEnd:
	sb $0, 0($a0)			#null terminate the string.
	jr $ra

#------------------------------------------------------------------------------
# function copy_of_str()
#------------------------------------------------------------------------------
# Creates a copy of a string. You will need to use sbrk (syscall 9) to allocate
# space for the string. strlen() and strncpy() will be helpful for this function.
# In MARS, to malloc memory use the sbrk syscall (syscall 9). See help for details.
#
# Arguments:
#   $a0 = string to copy
#
# Returns: pointer to the copy of the string
#------------------------------------------------------------------------------
copy_of_str:
	addiu $sp, $sp, -12	#0: original string, 4: len, 8: $ra.
	sw $ra, 8($sp)		#storing the return address.
	sw $a0, 0($sp)		#storing original string address.

	jal strlen
	sw $v0, 4($sp) 		#storing the len of string.

	addiu $a0, $v0, 1	#len of string +1 (null) as argument for syscall.
	li $v0, 9
	syscall				#return address at v0.

	move $a0, $v0			#arg0 for destination.
	lw $a1, 0($sp)		#arg1 for source.
	lw $a2, 4($sp)		#arg2 for char to copy.
	jal strncpy 		#return address at v0 already.

	lw $ra, 8($sp)
	addiu $sp, $sp, 12
	jr $ra

###############################################################################
#                 DO NOT MODIFY ANYTHING BELOW THIS POINT                       
###############################################################################

#------------------------------------------------------------------------------
# function streq() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string 1
#  $a1 = string 2
#
# Returns: 0 if string 1 and string 2 are equal, -1 if they are not equal
#------------------------------------------------------------------------------
streq:
	beq $a0, $0, streq_false	# Begin streq()
	beq $a1, $0, streq_false
streq_loop:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	bne $t0, $t1, streq_false
	beq $t0, $0, streq_true
	j streq_loop
streq_true:
	li $v0, 0
	jr $ra
streq_false:
	li $v0, -1
	jr $ra			# End streq()

#------------------------------------------------------------------------------
# function dec_to_str() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Convert a number to its unsigned decimal integer string representation, eg.
# 35 => "35", 1024 => "1024". 
#
# Arguments:
#  $a0 = int to write
#  $a1 = character buffer to write into
#
# Returns: the number of digits written
#------------------------------------------------------------------------------
dec_to_str:
	li $t0, 10			# Begin dec_to_str()
	li $v0, 0
dec_to_str_largest_divisor:
	div $a0, $t0
	mflo $t1		# Quotient
	beq $t1, $0, dec_to_str_next
	mul $t0, $t0, 10
	j dec_to_str_largest_divisor
dec_to_str_next:
	mfhi $t2		# Remainder
dec_to_str_write:
	div $t0, $t0, 10	# Largest divisible amount
	div $t2, $t0
	mflo $t3		# extract digit to write
	addiu $t3, $t3, 48	# convert num -> ASCII
	sb $t3, 0($a1)
	addiu $a1, $a1, 1
	addiu $v0, $v0, 1
	mfhi $t2		# setup for next round
	bne $t2, $0, dec_to_str_write
	jr $ra			# End dec_to_str()
