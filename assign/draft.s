		.data
msg1:	.asciiz "# Iterations: "
msg2:	.asciiz "=== After iteration "
msg3:	.asciiz " ==="
eol:	.asciiz "\n"

		.text
main:
		# Set up stack frame
		sw		$fp, -4($sp)	# push $fp onto stack
		la		$fp, -4($sp)	# set up $fp for this function
		sw		$ra, -4($fp)	# save return address
		sw		$s0, -8($fp)	# save $s0 to use as int maxiters
		sw		$s1, -12($fp)	# save $s1 to use as int n
		sw		$s2, -16($fp)	# save $s2 to use as int i
		sw		$s3, -20($fp)	# save $s3 to use as int j
		sw		$s4, -24($fp)	# save $s4 to use as int nn
		add     $sp, $sp, -28	# reset $sp to lasr pusheed item

		# code for main

		la 		$a0, msg1
		li		$v0, 4
		syscall					# printf("# Iterations: ")

		li		$v0, 5			# scanf("%d", &maxiters) into $v0
		syscall

		move	$s0, $v0		# let s0 holds int maxiters

		li		$s1, 1			# n = 1
loop1:   						# for(int n = 1; n <= maxiters; n++)
		bgt		$s1, $s0, end1	# if (n > maxiters) break
		li		$s2, 0			# i = 0
loop2:
		la 		$t0, N          # t0 = N
		bge		$s2, $t0, end2	# if (i >= N)
		li		$s3, 0			# j = 0
loop3:
		bge		$s3, $t0, end3	# if (j >= N)
		move	$a0, $s2		# first argument is i
		move	$a1, $s3		# second argument is j
		jal		neignbour
		move	$s4, $v0		# int nn = neighbours(i, j)
		mul		$t1, $s2, $t0	# t1 = row * #cols
		add 	$t1, $t1, $s3	# offset = t1 + s3
		lw		$t1, board($t1) # t1 = *(board+offset)
		move	$a0, $t1		# a0 = board[i][j]
		move	$a1, $s4		# a1 = nn
		jal		decideCell
		lw		$t1, newboard($t1) 
		move	$t1, $v0		#newboard[i][j] = decideCell(board[i][j], nn)
		addi	$s3, $s3, 1		# j ++
		j 		loop3
end3:
		addi	$s2, $s2, 1		# i ++
end2:
		la 		$a0, msg2
		li 		$v0, 4
		syscall					# printf("=== After iteration ")

		la 		$a0, s1
		li		$v0, 4
		syscall					# printf("%d")

		la 		$a0, msg3
		li 		$v0, 4			# printf(" ===")
		syscall

		la 		$a0, eol
		li		$v0, 4
		syscall					# printf("\n")

		jal		copyBackAndShow

end3:

		#clean up stack frame
		lw		$s4, -24($fp)
		lw		$s3, -20($fp)
		lw		$s2, -16($fp)
		lw		$s1, -12($fp)
		lw		$s0, -8($fp)
		lw		$ra, -4($fp)
		la 		$sp, 4($fp)
		lw 		$fp, ($fp)

		li		$v0, 0
		jr		$ra				# return 0

## decideCell() function

		.data
		.align 2

		.text
decideCell:
		# setup stack frame
		sw		$fp, -4($sp)	# push $fp onto stack
		la		$fp, -4($sp)	# set up $fp for this function
		sw		$ra, -4($fp)	# save return address
		sw		$s0, -8($fp)	# save s0 to use as int old
		sw		$s1, -12($fp)	# save s1 to use as int nn
		add 	$sp, $sp, -16	# reset $sp to lasr pusheed item

		move	$s0, $a0
		move	$s1, $a1

		li		$t0, 1
		li		$t1, 3

		beq		$s0, $t0, if		# if old == 1
		beq		$s1, $t1, else_if	# if nn == 3
		j 		else_part			# else
if:
		li		$t0, 2				# t0 = 2
		bge		$s1, $t0, inner_elif# if nn >= 2, jump
		li		$t3, 0				# ret = 0
		j 		end_if
inner_elif:
		//TODO
		j 		end_if
else_if:
		li		$t3, 1				# ret = 1
		j 		end_if
else_part:
		li		$t3, 0				# ret = 0
		j 		end_if
end_if:

