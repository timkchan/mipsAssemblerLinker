		addiu $t0, $t3, $t3				# not a number
label:	jal								# no label
		ori $t2, $99, 0xAB				# invalid register

# Things to ignore
		bne $t0, $t1, not_found			# nonexistant label
		addiu $t3 $t5 0x80808080		# number too large

# Can you think of any others?
