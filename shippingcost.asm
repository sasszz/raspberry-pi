.data
    input_prompt:   .asciz "Enter the weight of the package (in pounds): "
    output_message: .asciz "Shipping cost: $"
    error_message:  .asciz "The package cannot be shipped."

.text
.global main
    main:
        @ Display input prompt
        ldr r0, =input_prompt
        bl printf

        @ Read user input
        ldr r0, =0
        bl scanf

        @ Load the weight into a register
        ldr r1, [r0]   @ Load the value from the address pointed to by r0

        @ Check weight range and calculate cost
        cmp r1, #1
        blt cannot_ship
        ldr r0, =output_message
        cmp r1, #1
        blt less_than_3
        ldr r2, =#3
        cmp r1, r2
        blt less_than_10
        ldr r2, =#10
        cmp r1, r2
        blt less_than_20
        bgt cannot_ship
        ldr r0, =#20

        less_than_3:
            ldr r0, =#55
            b display_cost

        less_than_10:
            ldr r0, =#85
            b display_cost

        less_than_20:
            ldr r0, =#105
            b display_cost

        cannot_ship:
            ldr r0, =error_message
            bl printf
            b end

        display_cost:
            bl printf

        end:
            mov r7, #1
            swi 0
