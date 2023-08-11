.data
    tuition:    .word 10000         @ Initial tuition amount
    rate:       .word 104           @ Tuition increase rate (4% represented as 104)
    years:      .word 10            @ Number of years to calculate
    buffer:     .space 32            @ Buffer for string conversion

.text
    .extern printf
    .global main

main:
    ldr r1, =tuition    @ Load initial tuition into r1
    ldr r2, =rate       @ Load tuition increase rate into r2
    ldr r3, =years      @ Load number of years into r3

loop:
    add r1, r1, r1, lsr #2  @ Calculate new tuition amount (tuition * 1.04)
    subs r3, r3, #1        @ Decrement years counter

    cmp r3, #0             @ Check if years counter reached zero
    bgt loop               @ If greater than zero, repeat loop

    @ Calculate total cost of four years' worth of tuition after tenth year
    mov r4, #0             @ Initialize total cost (r4) to zero
    mov r3, #4             @ Set years counter for four years
four_years_loop:
    add r4, r4, r1         @ Accumulate tuition in total cost
    subs r3, r3, #1        @ Decrement years counter

    cmp r3, #0             @ Check if years counter reached zero
    bgt four_years_loop    @ If greater than zero, repeat loop

    @ Convert integers to string format for printing
    ldr r0, =buffer
    ldr r2, =10            @ Base 10
    bl int_to_str

    @ Print tuition after ten years
    ldr r0, =tuition
    bl printf

    @ Print total cost of four years' worth of tuition
    ldr r0, =buffer
    bl printf

    @ Exit the program
    mov r7, #1             @ Exit syscall number
    mov r0, #0             @ Exit status
    swi 0                  @ Make the syscall

@ Function to convert an integer to a string
int_to_str:
    push {lr}
    mov r1, r2              @ Copy base to r1
    mov r2, r0              @ Copy input value to r2
    mov r4, r0              @ Copy input value to r4 for later
    mov r5, #0              @ Initialize digit count to 0
    mov r0, #buffer + 31    @ Set buffer pointer to the end

convert_loop:
    sdiv r2, r2, r1         @ Divide value by base
    add r6, r2, r0          @ Calculate remainder
    cmp r6, #'9'            @ Check if remainder is greater than '9'
    ble normal_digit       @ If less than or equal to '9', use it as is

    add r6, r6, #'A' - '0' - 10  @ Convert to ASCII character ('A' = 10)
normal_digit:
    strb r6, [r0]           @ Store character in buffer
    sub r0, r0, #1          @ Move buffer pointer backwards
    add r5, r5, #1          @ Increment digit count

    cmp r4, #0              @ Check if value is zero
    bne convert_loop

    mov r0, #buffer         @ Set r0 to point to the beginning of the string
    pop {pc}
