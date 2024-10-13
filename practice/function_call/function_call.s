# FUNCTION CALL PHASES:
# 1) Caller's Context: place arguments in registers;

# 2) The Call Instruction(call my_function): 
#    -pushes the return address onto the stack  
#    -jumps to the address of the function being called)

# 3) Function Prologue (Entering the Function):
#    -Saving the caller's frame by pushing the old base pointer (%rbp) onto the stack.
#    -Setting up a new base pointer (%rbp) for the current function's stack frame.

# 4) Function Body (doing the work):
#    -The function uses the parameters from the registers.
#    -If local variables are needed, the function allocates space on the stack by decrementing %rsp.

# 5) Function Epilogue (Cleaning Up):
#     -If you have return value place it in the rax register
#     -Restoring the old base pointer (popq %rbp) from the stack to maintain the correct stack frame for the caller.
#    -Using the ret instruction to pop the return address from the stack and jump back to the caller.


.section .data
buffer: .space 100         # Reserve 100 bytes for input buffer
prompt_msg:    .asciz "Enter input: "
prompt_length: .quad 13
greeting_msg: .asciz "Hello "

.section .text

.globl _start

.type print_string, @function
print_string:
    pushq %rbp                    # 3: Save the caller's base pointer
    movq %rsp, %rbp               # 3: Set the new base pointer (stack frame)

    movq $1, %rax                 # 4: syscall: sys_write (1)
    movq $1, %rdi                 # 4: file descriptor: stdout (1) 
    syscall                       # 4: Making syscall with arguments from %rsi and %rdx

    popq %rbp                     # 5: Restore the caller's base pointer
    ret                           # 5: Return to the caller

.type read_string, @function
read_string:
    pushq %rbp                    # 3: Save the caller's base pointer
    movq %rsp, %rbp               # 3: Set the new base pointer (stack frame)

    movq $0, %rax                 # 4: syscall: sys_read (0)
    movq $0, %rdi                 # 4: file descriptor: stdout (0) 
    syscall                       # 4: Making syscall with arguments from %rsi and %rdx
    movq %rax, %r12               # 4: Save input lenght to a register

    popq %rbp                     # 5: Restore the caller's base pointer
    ret                           # 5: Return to the caller

_start:

    #Print the prompt "Enter input: " to stdout
    movq $prompt_msg, %rsi        # 1: address of the message to write
    movq prompt_length, %rdx      # 1: number of bytes to write (length of the message)
    call print_string             # 2

# Read user input into buffer
    movq $buffer, %rsi            # 1: address of the buffer to store the input
    movq $100, %rdx               # 1: number of bytes to read (max 100 bytes)
    call read_string              # 2

    # Write the the greeting to stdout
    movq $greeting_msg, %rsi      # 1: address of the message to write
    movq $7, %rdx                 # 1: number of bytes to write (length of the message)
    call print_string             # 2

       # Write the the name to stdout
    movq $buffer, %rsi            # 1: address of the message to write
    movq %r12, %rdx               # 1: number of bytes to write (length of the message)
    call print_string             # 2



        # Exit the program
    movq $60, %rax           # syscall: sys_exit (60)
    xor %rdi, %rdi           # exit code 0
    syscall
