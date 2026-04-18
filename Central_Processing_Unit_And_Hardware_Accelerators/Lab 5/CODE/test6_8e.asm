.data
res1: .word 0
res2: .word 0
res3: .word 0
res4: .word 0
res5: .word 0
res6: .word 0
res7: .word 0
res8: .word 0
res9: .word 0

.text
.globl main
main:
    # a = 5
    li $t0, 5         # $t0 = a
    # b = 12
    li $t1, 12        # $t1 = b

    # res1 = a & 0xF
    andi $t2, $t0, 0xF
    sw   $t2, res1

    # res2 = a | 0x3
    ori  $t3, $t0, 0x3
    sw   $t3, res2

    # res3 = a ^ 0x7
    xori $t4, $t0, 0x7
    sw   $t4, res3

    # res4 = (a < 10)
    slti $t5, $t0, 10
    sw   $t5, res4

    # res5 = a & b
    and  $t6, $t0, $t1
    sw   $t6, res5

    # res6 = a | b
    or   $t7, $t0, $t1
    sw   $t7, res6

    # res7 = a ^ b
    xor  $t8, $t0, $t1
    sw   $t8, res7

    # res8 = b >> 2
    li   $t9, 2
    srl  $s0, $t1, 2
    sw   $s0, res8

    # res9 = a  (move דרך addu)
    addu $s1, $t0, $zero
    sw   $s1, res9

infinite_loop:
    beq $zero, $zero, infinite_loop
