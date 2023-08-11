.data
input_prompt:       .asciz "Enter the weight of the package (in pounds): "
output_prompt:      .asciz "The shipping cost is $"
cannot_ship:        .asciz "The package cannot be shipped."
input_buffer:       .space 64
.align 4
output_buffer:      .space 32
.align 4
cost_3_10_value:    .word 350
cost_10_20_value:   .word 550
cost_float_buffer:  .space 16
.align 4

.equ INPUT_BUFFER_SIZE, 64
.equ OUTPUT_BUFFER_SIZE, 32

.text
.global main

main:
    @ Display input prompt
    ldr r0, =input_prompt
    bl printf

    @ Read user input
    ldr r0, =input_buffer
    ldr r1, =INPUT_BUFFER_SIZE
    bl fgets

    @ Null-terminate the input_buffer
    mov r2, #0
    strb r2, [r0, r1]  @ Null-terminate the input at r0 + r1

    @ Convert input to integer
    ldr r0, =input_buffer
    bl atoi

    @ Check weight and calculate cost
    cmp r0, #0
    ble cannot_ship_message

    cmp r0, #1
    blt cost_3_10

    cmp r0, #3
    blt cost_10_20

    b cannot_ship_message

cost_3_10:
    ldr r1, =cost_3_10_value
    b calculate_cost

cost_10_20:
    ldr r1, =cost_10_20_value
    b calculate_cost

calculate_cost:
    @ Calculate floating-point representation of cost
    mov r2, #100     @ Scaling factor for floating-point
    mul r4, r1, r2   @ Use r4 as an intermediate register
    bl calculate_float

    @ Display the cost message
    ldr r0, =output_prompt
    bl printf

    @ Display the calculated cost
    ldr r0, =output_buffer   @ Load the calculated cost string
    bl printf

    b end

cannot_ship_message:
    ldr r0, =cannot_ship
    bl printf
    b end

calculate_float:
    @ Calculate floating-point representation from integer
    @ Inputs: r4 = integer value to convert
    @ Outputs: r0 = address of the converted floating-point value (output_buffer)

    push {r5}

    ldr r5, =output_buffer
    mov r6, r4          @ Copy integer value to r6

    cmp r4, #0          @ Check if the integer is negative
    blt is_negative

    mov r4, #0          @ Clear the sign bit
    strb r4, [r5]
    b convert

is_negative:
    mov r4, #1          @ Set the sign bit
    strb r4, [r5]
    rsbs r6, r6, #0     @ Make the integer positive

convert:
    mov r3, #10         @ Base 10
    mov r4, #0          @ Exponent
    mov r2, #0          @ Fractional part

convert_loop:
    cmp r6, #0
    beq convert_done

    sdiv r6, r6, r3     @ Divide integer by base
    sub r2, r2, r3      @ Subtract base from fractional part
    add r2, r2, r6, LSL r4   @ Add quotient to fractional part (scaled)
    add r4, r4, #1      @ Increment exponent
    b convert_loop

convert_done:
    strb r4, [r5, #4]    @ Store exponent
    strb r2, [r5, #5]    @ Store fractional part

    pop {r5}
    bx lr

end:
    mov r7, #1          @ Exit syscall
    swi 0

.align 2
