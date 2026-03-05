.global main

.text
main:
    ; reservar espacio en el stack
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    ; start engine
    li $v0, 100
    syscall

    ; rectangulo posicion inicial
    li $s0, 100  ;x
    li $s1, 50   ;y

loop:
    ; clear
    li $v0, 103
    li $a0, 0xffffffff
    syscall

    ; leer key
    li $v0, 104
    syscall

    ; space key salir
    li $t0, 5
    beq $v0, $t0, end_loop

    ; revisar arriba 
    li $t0, 1
    bne $v0, $t0, abajo
    addi $s1, $s1, -1
    slti $t1, $s1, 0
    beq $t1, $zero, dibujar
    li $s1, 0

    j dibujar

; check limits
abajo:
    li $t0, 2
    bne $v0, $t0, izqr
    addi $s1, $s1, 1
    slti $t1, $s1, 109
    bne $t1, $zero, dibujar
    li $s1, 108

    j dibujar

izqr:
    li $t0, 3
    bne $v0, $t0, derecha
    addi $s0, $s0, -1
    slti $t1, $s0, 0
    beq $t1, $zero, dibujar
    li $s0, 0
    j dibujar

derecha:
    li $t0, 4
    bne $v0, $t0, dibujar
    addi $s0, $s0, 1
    slti $t1, $s0, 237
    bne $t1, $zero, dibujar
    li $s0, 236

dibujar:
    ; reservar espacio en el stack
    addi $sp, $sp, -4
    li $t0, 0x000000
    sw $t0, 0($sp)

    move $a0, $s0
    move $a1, $s1
    
    li $a2, 20
    li $a3, 20
    jal draw_rectangle
    addi $sp, $sp, 4

    ;  refresh
    li $v0, 102
    syscall

    j loop

end_loop:
    ; cargar datos y balancear stack
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    li $v0, 105
    syscall

; ====================================================

; draw_horizontal_line(x1, x2, y, color)
draw_horizontal_line:
    move $t0, $a0
    move $t1, $a1
    move $t2, $a2
    move $t3, $a3

line_loop:
    slt $t4, $t1, $t0
    bne $t4, $zero, end_line_loop

    li $v0, 101
    move $a0, $t0
    move $a1, $t2
    move $a2, $t3
    syscall

    addi $t0, $t0, 1
    j line_loop

end_line_loop:
    jr $ra

;==================================================

;draw_rectangle(x, y, w, h, color)
draw_rectangle:
    ; reservar espacio en el stack
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2
    move $s3, $a3
    lw $s4, 24($sp)

    add $t0, $s0, $s2

    ; dibjar linea superior
    move $a0, $s0
    move $a1, $t0
    move $a2, $s1
    move $a3, $s4
    jal draw_horizontal_line

    ; dibujar linea inferior
    add $t1, $s1, $s3
    move $a0, $s0
    add $t0, $s0, $s2
    move $a1, $t0
    move $a2, $t1
    move $a3, $s4
    jal draw_horizontal_line

    ; dibujar linea izqr
    move $t2, $s1
    add $t1, $s1, $s3

loop_izqr:
    slt $t3, $t2, $t1
    beq $t3, $zero, end_loop_izqr

    li $v0, 101
    move $a0, $s0
    move $a1, $t2
    move $a2, $s4
    syscall

    addi $t2, $t2, 1
    j loop_izqr

end_loop_izqr:
    move $t2, $s1
    add $t0, $s0, $s2

right_loop:
    slt $t3, $t2, $t1
    beq $t3, $zero, end_right_loop

    li $v0, 101
    move $a0, $t0
    move $a1, $t2
    move $a2, $s4
    syscall

    addi $t2, $t2, 1
    j right_loop

end_right_loop:
    ; devolver datos y balancear stack
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24

    jr $ra
