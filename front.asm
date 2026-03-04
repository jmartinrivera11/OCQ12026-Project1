.global main

.text
main:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    ; run engine
    li $v0, 100
    syscall

    ; clear
    li $v0, 103
    li $a0, 0xffffffff
    syscall

    li $a0, 20
    li $a1, 200
    li $a2, 10
    li $a3, 0x00000000
    jal draw_horizontal_line

    li $a0, 20
    li $a1, 20
    li $a2, 180
    li $a3, 100
    li $s0, 0x00000000
    jal draw_rectangle
    
    ; refresh
    li $v0, 102
    syscall

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, -8

loop:
    li $v0, 104 ; get key
    syscall

    li $t0, 5
    beq $v0, $t0, end_loop

    j loop

end_loop:
    li $v0, 105 ;exit graphics
    syscall

; draw_horizontal_line(x1, x2, y, color)
draw_horizontal_line:
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3

line_loop:
    slt $t4, $t1, $t0
    bne $t4, $zero, line_loop_end

    li $v0, 101 ;set pixel
    move $a0, $t0
    move $a1, $t2
    move $a2, $t3
    syscall

    addi $t0, $t0, 1
    j line_loop

line_loop_end:
    jr $ra

;-------------------------------------------

; draw_rectangle(x, y, w, h, color)
draw_rectangle:
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3
    move $t4, $s0
    move $t5, $zero

outer_loop:
    slt $t6, $t5, $t3
    beq $t6, $zero, end_outer_loop

    move $t7, $zero
    move $t8, $t0

inner_loop:
    slt $t6, $t7, $t2
    beq $t6, $zero, end_inner_loop

    li $v0, 101
    move $a0, $t8
    move $a1, $t1
    move $a2, $t4
    syscall

    addi $t8, $t8, 1
    addi $t7, $t7, 1
    j inner_loop

end_inner_loop:
    addi $t1, $t1, 1
    addi $t5, $t5, 1
    j outer_loop

end_outer_loop:
    jr $ra