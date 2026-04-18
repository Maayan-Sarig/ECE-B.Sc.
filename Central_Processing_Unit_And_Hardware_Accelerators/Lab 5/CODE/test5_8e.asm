.data
arr:    .word 3, -2, 5, 0, -7, 8, 1, -1, 4, -3
sum:    .word 0

    .text
    .globl main
main:
    li $t0, 0          # i = 0
    li $t1, 10         # limit = 10
    la $t2, arr        # $t2 = &arr[0]
    li $t3, 0          # $t3 = sum

loop:
    slt $t8, $t0, $t1       # if i < 10
    beq $t8, $zero, end_loop

    sll $t4, $t0, 2         # offset = i * 4
    add $t5, $t2, $t4       # $t5 = &arr[i]
    lw  $t6, 0($t5)         # $t6 = arr[i]

    slt $t7, $zero, $t6     # if 0 < arr[i]
    beq $t7, $zero, skip    # skip if not positive

    add $t3, $t3, $t6       # sum += arr[i]

skip:
    addi $t0, $t0, 1        # i++
    j loop

end_loop:
    la $t7, sum
    sw $t3, 0($t7)          # sum = total

forever:
    beq $zero, $zero, forever # infinite loop
