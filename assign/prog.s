# COMP1521 19t2 ... Game of Life on a NxN grid
#
# Written by Xiao xiaoshan (z5191546), June 2019

## Requires (from `boardX.s'):
# - N (word): board dimensions
# - board (byte[][]): initial board state
# - newBoard (byte[][]): next board state

## Provides:
.globl    main
.globl    decideCell
.globl    neighbours
.globl    copyBackAndShow


########################################################################
# .TEXT <main>

# Frame:    $fp, $ra $s0, $s1, $s2, $s3, $s4
# Uses:        ...
# Clobbers:    ...

# Locals:    ...

# Structure:
#    main
#    -> [prologue]
#    -> ...
#    -> [epilogue]

.data
msg1:    .asciiz "# Iterations: "
msg2:    .asciiz "=== After iteration "
msg3:    .asciiz " ==="
eol:    .asciiz "\n"

.text
main:
# Set up stack frame
sw        $fp, -4($sp)    # push $fp onto stack
la        $fp, -4($sp)    # set up $fp for this function
sw        $ra, -4($fp)    # save return address
sw        $s0, -8($fp)    # save $s0 to use as int maxiters
sw        $s1, -12($fp)    # save $s1 to use as int n
sw        $s2, -16($fp)    # save $s2 to use as int i
sw        $s3, -20($fp)    # save $s3 to use as int j
sw        $s4, -24($fp)    # save $s4 to use as int nn
addi    $sp, $sp, -28    # reset $sp to lasr pusheed item

# code for main

la         $a0, msg1
li        $v0, 4
syscall                    # printf("# Iterations: ")

li        $v0, 5            # scanf("%d", &maxiters) into $v0
syscall

move    $s0, $v0        # let s0 holds int maxiters

loop1_init:
li        $s1, 1            # n = 1
loop1_cond:                   # for(int n = 1; n <= maxiters; n++)
bgt        $s1, $s0, loop1_end # if (n > maxiters) break
loop2_init:
li        $s2, 0            # i = 0
loop2_cond:
lw         $t0, N          # t0 = N
bge        $s2, $t0, loop2_end     # if (i >= N), break
loop3_init:
li        $s3, 0            # j = 0
loop3_cond:
lw         $t0, N          # t0 = N
bge        $s3, $t0, loop3_end  # if (j >= N)
move    $a0, $s2        # first argument is i
move    $a1, $s3        # second argument is j
jal        neighbours
nop
move    $s4, $v0        # int nn = neighbours(i, j)

lw      $t0, N
mul        $t7, $s2, $t0    # t7 = row * #cols
add     $t7, $t7, $s3    # offset = t7 + s3
lb        $t2, board($t7) # t7 = *(board+offset)
move    $a0, $t2        # a0 = board[i][j]
move    $a1, $s4        # a1 = nn
jal        decideCell
nop
sb        $v0, newBoard($t7) #newboard[i][j] = decideCell(board[i][j], nn)

loop3_step:
addi    $s3, $s3, 1        # j ++
j         loop3_cond
loop3_end:
loop2_step:
addi    $s2, $s2, 1        # i ++
j       loop2_cond
loop2_end:
la         $a0, msg2
li         $v0, 4
syscall                    # printf("=== After iteration ")

move     $a0, $s1
li        $v0, 1
syscall                    # printf("%d")

la         $a0, msg3
li         $v0, 4            # printf(" ===")
syscall

la         $a0, eol
li        $v0, 4
syscall                    # printf("\n")

jal        copyBackAndShow
loop1_step:
addi    $s1, $s1, 1     # n++
j       loop1_cond
loop1_end:
li        $v0, 0
#clean up stack frame
lw        $s4, -24($fp)
lw        $s3, -20($fp)
lw        $s2, -16($fp)
lw        $s1, -12($fp)
lw        $s0, -8($fp)
lw        $ra, -4($fp)
la         $sp, 4($fp)
lw         $fp, ($fp)


jr        $ra                # return 0

## .TEXT decideCell() function #########################


.align 2

.text
decideCell:

# Frame:    $fp, $ra $s0, $s1, $s2, $s3, $s4
# Uses:        ...
# Clobbers:    ...

# Locals:    ...

# Structure:
#    main
#    -> [prologue]
#    -> ...
#    -> [epilogue]
#
# Code:
# setup stack frame
sw        $fp, -4($sp)    # push $fp onto stack
la        $fp, -4($sp)    # set up $fp for this function
sw        $ra, -4($fp)    # save return address
sw        $s0, -8($fp)    # save s0 to use as int old
sw        $s1, -12($fp)    # save s1 to use as int nn
addi     $sp, $sp, -16    # reset $sp to lasr pusheed item

move    $s0, $a0
move    $s1, $a1

li        $t0, 1
li        $t1, 3

beq        $s0, $t0, decideCell_if        # if old == 1
beq        $s1, $t1, decideCell_elif    # if nn == 3
j         decideCell_else            # else

decideCell_if:

li        $t2, 2                # t2 = 2
li         $t3, 3
beq        $s1, $t2, decideCell_inner_elif # if nn == 2, jump
beq        $s1, $t3, decideCell_inner_elif # if nn == 3, jump
li        $v0, 0                # ret = 0
j         decideCell_end
nop

decideCell_inner_elif:

li      $v0, 1
j         decideCell_end
decideCell_elif:

li        $v0, 1                # ret = 1
j         decideCell_end

decideCell_else:

li        $v0, 0                # ret = 0
j       decideCell_end
nop

decideCell_end:

#clean up stack frame

lw        $s1, -12($fp)
lw        $s0, -8($fp)
lw        $ra, -4($fp)
la         $sp, 4($fp)
lw         $fp, ($fp)

jr        $ra                # return ret

## .TEXT neighbours function #########################

.data
.align 2

.text
neighbours:
# Frame:    $fp, $ra $s0, $s1, $s2, $s3, $s4
# Uses:        ...
# Clobbers:    ...

# Locals:    ...

# Structure:
#    main
#    -> [prologue]
#    -> ...
#    -> [epilogue]
#
# Code:
# setup stack frame
sw        $fp, -4($sp)    # push $fp onto stack
la        $fp, -4($sp)    # set up $fp for this function
sw        $ra, -4($fp)    # save return address
sw        $s0, -8($fp)    # save s0 to use as int x
sw        $s1, -12($fp)    # save s1 to use as int y
sw        $s2, -16($fp)    # save s2 to use as int nn
addi     $sp, $sp, -20    # reset $sp to lasr pusheed item


li         $s2, 0        # int nn = 0

neighbours_row_init:

li         $s0, -1        # x = -1

neighbours_row_cond:
li         $t0, 1        # t0 = 1
bgt        $s0, $t0, neighbours_row_f      # x > 1

neighbours_col_init:
li      $s1, -1        # y = -1

neighbours_col_cond:
bgt        $s1, $t0, neighbours_col_f    # y > 1

add     $t1, $a0, $s0        # i + x
bltz    $t1, neighbours_col_step  # i + x < 0, continue
lw      $t2, N
sub        $t2, $t2, $t0        # t2 = N - 1
bgt        $t1, $t2, neighbours_col_step
nop

add     $t3, $a1, $s1        # j + y
bltz    $t3, neighbours_col_step   # j + y < 0 , continue
bgt        $t3, $t2, neighbours_col_step
nop

beqz    $s0, neighbours_check_y        # if x == 0 , check y == 0 or not
j         neighbours_check_board
neighbours_check_y:
beqz    $s1, neighbours_col_step        # if  && y == 0, continue
nop
neighbours_check_board:
lw      $t2, N
mul        $t2, $t1, $t2    # % -> row * #col
add     $t2, $t2, $t3        # t2 = offset
lb        $t4, board($t2)

bne     $t4, $t0, neighbours_col_step    # board[i + x][j + y] != 1, conitnue
addi    $s2, $s2, 1            # board[i + x][j + y] == 1 , nn++
neighbours_col_step:
addi    $s1, $s1, 1
j       neighbours_col_cond
nop
neighbours_col_f:

neighbours_row_step:
addi    $s0, $s0, 1
j       neighbours_row_cond
nop
neighbours_row_f:

move $v0, $s2

#clean up stack frame
lw        $s2, -16($fp)
lw        $s1, -12($fp)
lw        $s0, -8($fp)
lw        $ra, -4($fp)
la         $sp, 4($fp)
lw         $fp, ($fp)

jr        $ra                # return ret

## .TEXT copyBackAndShow function #########################

.data
msg4: .asciiz "."
msg5: .asciiz "#"

.data
.align 2

.text
copyBackAndShow:
# Frame:    $fp, $ra $s0, $s1, $s2, $s3, $s4
# Uses:        ...
# Clobbers:    ...

# Locals:    ...

# Structure:
#    main
#    -> [prologue]
#    -> ...
#    -> [epilogue]
#
# Code:
# setup stack frame
sw        $fp, -4($sp)    # push $fp onto stack
la        $fp, -4($sp)    # set up $fp for this function
sw        $ra, -4($fp)    # save return address
sw        $s0, -8($fp)    # save s0 to use as int i
sw        $s1, -12($fp)    # save s1 to use as int j
addi     $sp, $sp, -26    # reset $sp to lasr pusheed item

lw      $t0, N     # t0 = N

show_row_init:
li      $s0, 0        # i = 0
show_row_cond:
bge        $s0, $t0, show_row_f

show_col_init:
li      $s1, 0        # j = 0

show_col_cond:
bge        $s1, $t0, show_col_f    # j >= N , break

mul        $t1, $s0, $t0        # % -> row * #col
add     $t1, $t1, $s1        # offset = row * #col + col
lb        $t2, newBoard($t1)
sb      $t2, board($t1)

beqz    $t2, show_if        # if board[i][j] == 0
j       show_else
nop
show_if:
la      $a0, msg4
li      $v0, 4
syscall                # putchar('.')
j       show_col_step
show_else:
la      $a0, msg5
li      $v0,4
syscall                # putchar('#')
j       show_col_step
show_col_step:
addi    $s1, $s1, 1 # j++
j       show_col_cond
show_col_f:
show_row_step:
addi    $s0, $s0, 1 # i++
la      $a0, eol    # putchar('\n')
li      $v0, 4
syscall

j         show_row_cond
show_row_f:

#clean up stack frame
lw        $s1, -12($fp)
lw        $s0, -8($fp)
lw        $ra, -4($fp)
la         $sp, 4($fp)
lw         $fp, ($fp)

jr        $ra                # return
