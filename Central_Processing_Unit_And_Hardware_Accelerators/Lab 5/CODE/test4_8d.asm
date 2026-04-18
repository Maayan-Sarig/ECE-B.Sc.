.data

Mat1:   .word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
Mat2:   .word 13,14,15,16,9,10,11,12,5,6,7,8,1,2,3,4
resMat: .space 64          

.text
.globl main
main:

    la $t0, Mat1           
    la $t1, Mat2          
    la $t2, resMat       

    li $t3, 16          
loop:
    beq $t3, $zero, done  

    lw $t4, 0($t0)       
    lw $t5, 0($t1)       
    add $t6, $t4, $t5    
    sw $t6, 0($t2)         

    addi $t0, $t0, 4       
    addi $t1, $t1, 4     
    addi $t2, $t2, 4    
    subi $t3, $t3, 1      
    j loop                 

done:
    beq $zero, $zero, done 
