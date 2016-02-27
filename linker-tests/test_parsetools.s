# CS 61C Summer 2015 Project 2-2 
# linker-tests/test_parsetools.s

#==============================================================================
#                            parsetools.s Test Cases
#==============================================================================

.include "../linker-src/parsetools.s"
.include "test_core.s"
.include "../linker-src/string.s"

#-------------------------------------------
# Test Data - Feel free to add your own
#-------------------------------------------
.data
hex_str1:	.asciiz "abcdef12\n"
hex_str2:	.asciiz "00034532\n"

num_1:		.asciiz "21"
num_2:		.asciiz "34532"
num_3:		.asciiz "abcdef12"
num_4:		.asciiz "ABCDEF12"

token_1:		.asciiz "15\thello"
expected_name:	.asciiz "hello"

.globl main
.text
#-------------------------------------------
# Test driver
#-------------------------------------------
main:
	print_str(test_header_name)
	
	print_newline()
	jal test_hex_to_str
	
	#print_newline()
	#jal test_parse_int
	#print_newline()
	#jal test_tokenize
	
	li $v0, 10
	syscall
	
#-------------------------------------------
# Tests hex_to_str() from parsetools.s
#-------------------------------------------
test_hex_to_str:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	print_str(test_hex_to_str_name)
	
	li $a0, 2882400018
	la $a1, test_buffer
	jal hex_to_str
	la $a0, test_buffer
	check_str_equals($a0, hex_str1)
	
	li $a0, 214322
	la $a1, test_buffer
	jal hex_to_str
	la $a0, test_buffer
	check_str_equals($a0, hex_str2)
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
#-------------------------------------------
# Tests parse_int() from parsetools.s
#-------------------------------------------
test_parse_int:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	print_str(test_parse_int_name)
	
	la $a0, num_1
	li $a1, 10
	jal parse_int
	check_uint_equals($v0, 21)
	
	la $a0, num_1
	li $a1, 16
	jal parse_int
	check_uint_equals($v0, 33)
	
	la $a0, num_2
	li $a1, 10
	jal parse_int
	check_uint_equals($v0, 34532)
	
	la $a0, num_2
	li $a1, 16
	jal parse_int
	check_uint_equals($v0, 214322)
	
	la $a0, num_3
	li $a1, 16
	jal parse_int
	check_uint_equals($v0, 2882400018)
	
	la $a0, num_4
	li $a1, 16
	jal parse_int
	check_uint_equals($v0, 2882400018)
	
	lw $ra, 0($sp)
	addiu $sp, $sp, 4
	jr $ra
	
#-------------------------------------------
# Tests tokenize() from parsetools.s
#-------------------------------------------
test_tokenize:
	addiu $sp, $sp, -8
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	print_str(test_tokenize_name)
	
	la $a0, token_1
	jal tokenize
	move $s0, $v1
	# Check int matches
	check_uint_equals($v0, 15)
	# Check string matches
	check_str_equals($s0, expected_name)
	
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	jr $ra

.data
test_header_name:	.asciiz "Running test parsetools:\n"

test_parse_int_name:	.asciiz "Testing parse_int():\n"
test_hex_to_str_name:	.asciiz "Testing hex_to_str():\n"
test_tokenize_name:	.asciiz "Testing tokenize():\n"

test_buffer:	.space 10
