#PURPOSE:

#Program to illustrate how functions work
#This program will compute the value of
#2^3 + 5^2
#Everything in the main program is stored in registers,
#so the data section doesn’t have anything.

.section .data

.section .text

.globl _start
_start:

    # Compute 2^3
    pushq $3              # Push second argument (power = 3)
    pushq $2              # Push first argument (base = 2)
    call power            # Call the power function
    addq $16, %rsp        # Move the stack pointer back (64-bit, 8 bytes per argument)

    pushq %rax            # Save the first result (2^3) before calling the next function

    # Compute 5^2
    pushq $2              # Push second argument (power = 2)
    pushq $5              # Push first argument (base = 5)
    call power            # Call the power function
    addq $16, %rsp        # Move the stack pointer back

    popq %rbx             # Retrieve the first result (2^3) from the stack
    addq %rax, %rbx       # Add the second result (5^2) to the first result (2^3)

    movq $60, %rax        # System call for exit
    movq %rbx, %rdi       # Set the exit code to the result (2^3 + 5^2)
    syscall               # Make the syscall

# The power function calculates base^power
.type power, @function
power:
    pushq %rbp                      # Save old base pointer
    movq %rsp, %rbp                 # Set stack pointer as base pointer
    subq $8, %rsp                   # Make space for local variable
    movq 16(%rbp), %rbx             # Get the base number (first argument)
    movq 24(%rbp), %rcx             # Get the power (second argument)
    movq %rbx, -8(%rbp)             # Store the base number as the current result

power_loop_start:
    cmpq $1, %rcx                   # If power is 1, we are done
    je end_power
    movq -8(%rbp), %rax             # Move the current result into %rax
    imulq %rbx, %rax                # Multiply the current result by the base number
    movq %rax, -8(%rbp)             # Store the current result
    decq %rcx                       # Decrease the power
    jmp power_loop_start            # Repeat for the next power

end_power:
    movq -8(%rbp), %rax             # Return the result in %rax
    movq %rbp, %rsp                 # Restore stack pointer
    popq %rbp                       # Restore base pointer
    ret                             # Return from the function
