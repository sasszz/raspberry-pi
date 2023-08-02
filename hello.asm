@ hello_arm.asm
@ A simple "Hello, World!" program in ARM assembly language

.section .data
hello_msg:   .asciz "I'm alivvvveeee!!!!\n"

.section .text
.global _start
_start:
    @ write(1, hello_msg, 13)
    mov r0, #1          @ syscall: write
    ldr r1, =hello_msg @ pointer to the message
    ldr r2, =13         @ message length
    mov r7, #4          @ syscall number for write
    swi 0               @ software interrupt to invoke syscall

    @ exit(0)
    mov r7, #1          @ syscall number for exit
    mov r0, #0          @ status code: 0
    swi 0               @ software interrupt to invoke syscall
