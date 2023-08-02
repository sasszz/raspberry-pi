.section .data
prompt_input:
    .asciz "Please enter a number: "

message_output:
    .asciz "This is your number: "

.section .bss
input_buffer:
    .space  101     @ Allocate space for input buffer (100 characters + null terminator)

.section .text
.global _start

_start:
    @ Display prompt for input
    mov     r0, #1          @ File descriptor 1 (stdout)
    ldr     r1, =prompt_input
    mov     r2, #23         @ Length of the prompt
    mov     r7, #4          @ syscall number for sys_write
    swi     0

    @ Read input from the user
    mov     r0, #0          @ File descriptor 0 (stdin)
    ldr     r1, =input_buffer
    mov     r2, #100        @ Maximum number of bytes to read
    mov     r7, #3          @ syscall number for sys_read
    swi     0

    @ Null-terminate the input
    strb    r9, [r1, r0]

    @ Display the "This is your number" message
    mov     r0, #1          @ File descriptor 1 (stdout)
    ldr     r1, =message_output
    mov     r2, #21         @ Length of the message
    mov     r7, #4          @ syscall number for sys_write
    swi     0

    @ Display the user input
    mov     r0, #1          @ File descriptor 1 (stdout)
    ldr     r1, =input_buffer
    bl      strlen          @ Call the strlen function
    mov     r7, #4          @ syscall number for sys_write
    swi     0

    @ Exit the program
    mov     r7, #1          @ syscall number for sys_exit
    mov     r0, #0          @ exit status 0
    swi     0

strlen:
    push    {r4, lr}        @ Preserve r4 and lr
    mov     r4, r1          @ Copy the string pointer to r4

.loop:
    ldrb    r3, [r4], #1    @ Load a byte from the string and increment the pointer
    cmp     r3, #0          @ Check if the byte is null terminator
    bne     .loop           @ Loop until null terminator is found

    sub     r0, r4, r1      @ Calculate the length of the string
    pop     {r4, pc}        @ Restore r4 and return
