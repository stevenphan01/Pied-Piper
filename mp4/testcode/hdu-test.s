#  mp4-cp1.s version 4.0
.align 4
.section .text
.globl _start
_start:
    addi x1, x0, 0x00000007
	beq x0, x0, halt
	lw x3, NEGTWO
	addi x2, x0, 0x00000009 
halt:
	lw x1, NEGTWO
	beq x0, x0, halt
	addi x1, x1, 1
.section .rodata
.balign 256
ONE:    .word 0x00000001
TWO:    .word 0x00000002
NEGTWO: .word 0xFFFFFFFE
