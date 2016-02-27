# CS 61C Summer 2015 Project 2-2 
# linker-tests/test_symbols.s

#==============================================================================
#                            symbol_list.s Test Cases
#==============================================================================
# Note that test_add_to_list() does NOT output whether the test passes or fails
# because it is written to standard output.
#==============================================================================

.include "../linker-src/symbol_list.s"
.include "test_core.s"

#-------------------------------------------
# Test Data - Feel free to add your own
#-------------------------------------------
.data
# Test strings
test_label1:	.asciiz "Label 1"
test_label2:	.asciiz "Label 2"
test_label3:	.asciiz "Label 3"

# Test nodes
node1:		.word 1234 test_label1 0
node2:		.word 3456 test_label2 node1
node3:		.word 5678 test_label3 node2

.globl main
.text
#-------------------------------------------
# Test driver
#-------------------------------------------
main:	
	print_str(test_header_name)
	
	#print_newline()
	#la $a0, node3
	#jal test_print_list
	
	#print_newline()
	#la $a0, node3
	#jal test_print_to_file
	
	print_newline()
	la $a0, node3
	jal test_addr_for_symbol
	
	print_newline()
	la $a0, node3
	jal test_symbol_for_addr
	
	print_newline()
	jal test_add_to_list
	
	li $v0, 10
	syscall

#-------------------------------------------
# Tests addr_for_symbol()
# $a0 = address of beginning of list
#-------------------------------------------
test_addr_for_symbol:
	addiu $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	print_str(test_symbol_for_addr_name)
	
	lw $a0, 4($sp)
	la $a1, test_label1
	jal addr_for_symbol
	check_uint_equals($v0, 1234)

	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	jr $ra
		
#-------------------------------------------
# Tests symbol_for_addr()
# $a0 = address of beginning of list
#-------------------------------------------
test_symbol_for_addr:
	addiu $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	print_str(test_addr_for_symbol_name)

	lw $a0, 4($sp)
	li $a1, 3456
	jal symbol_for_addr
	check_str_equals($v0, test_label2)
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	jr $ra

#-------------------------------------------
# Tests add_to_list()
# $a0 = address of beginning of list
#-------------------------------------------
test_add_to_list:				# Begin test_add_to_list
	addiu $sp, $sp, -8
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	print_str(test_add_to_list_name)
	li $a0, 0			
	li $a1, 1234
	la $a2, test_label1
	jal add_to_list			# Test label 1
	move $a0, $v0
	li $a1, 3456
	la $a2, test_label2
	jal add_to_list			# Test label 2
	move $a0, $v0
	li $a1, 5678
	la $a2, test_label3			
	jal add_to_list			# Test label 3
	move $s0, $v0
	
	move $a0, $s0
	la $a1, print_symbol
	li $a2, 0		# dummy argument
	jal print_list
	print_str(expected_print_list)
	
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	jr $ra
	
# $a0 = address of beginning of list
test_print_list:
	addiu $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	
	print_str(test_print_list_name)
	print_str(tc_actual_str)
	print_newline()
	lw $a0, 4($sp)
	la $a1, print_symbol
	li $a2, 0		# dummy argument
	jal print_list
	print_str(expected_print_list)
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	jr $ra
	
# $a0 = address of beginning of list
test_print_to_file:
	addiu $sp, $sp, -8
	sw $a0, 4($sp)
	sw $ra, 0($sp)
	
	print_str(test_print_to_file_name)
	
	la $a0, print_location
	li $a1, 1
	li $v0, 13
	syscall
	
	blt $v0, $0, test_print_to_file_err
	
	lw $a0, 4($sp)
	la $a1, write_symbol
	move $a2, $v0
	jal print_list
	j test_print_to_file_end
test_print_to_file_err:
	print_str(print_file_open_error)
test_print_to_file_end:	
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	jr $ra
	
.data
test_print_list_name:	.asciiz "Testing print_list() printing to standard output:\n"
test_print_to_file_name:.asciiz "Testing print_list() printing to file. Check results in print_test.txt\n"
test_header_name:	.asciiz "Running symbol list tests:\n"
test_addr_for_symbol_name:.asciiz "Testing addr_for_symbol():\n"
test_symbol_for_addr_name:.asciiz "Testing symbol_for_addr():\n"
test_add_to_list_name:	.asciiz "Testing add_to_list():\n"

expected_symbol:	.asciiz "Label 2"
expected_print_list:	.asciiz "expected:\n5678\tLabel 3\n3456\tLabel 2\n1234\tLabel 1\n"
print_location:	.asciiz "print_test.txt"
print_file_open_error:	.asciiz "Error opening print_test.txt\n"
