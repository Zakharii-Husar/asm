.section .data
buffer: .space 100         # Reserve 100 bytes for input buffer
prompt_msg:    .asciz "Enter input: "
prompt_length: .quad 13
greeting_msg: .asciz "Hello "
new_line: .asciz "\n"

.section .text

.globl _start
_start:

    # Write the prompt "Enter input: " to stdout
    movq $1, %rax            # syscall: sys_write (1)
    movq $1, %rdi            # file descriptor: stdout (1)
    movq $prompt_msg, %rsi          # address of the message to write
    movq prompt_length, %rdx           # number of bytes to write (length of the message)
    syscall

        # Read user input into buffer
    movq $0, %rax            # syscall: sys_read (0)
    movq $0, %rdi            # file descriptor: stdin (0)
    movq $buffer, %rsi       # address of the buffer to store the input
    movq $100, %rdx          # number of bytes to read (max 100 bytes)
    syscall

       # Save input lenght to a register
       movq %rax, %r12

        # Write the the greeting to stdout
    movq $1, %rax            # syscall: sys_write (1)
    movq $1, %rdi            # file descriptor: stdout (1)
    movq $greeting_msg, %rsi          # address of the message to write
    movq $7, %rdx           # number of bytes to write (length of the message)
    syscall

       # Write the the name to stdout
    movq $1, %rax            # syscall: sys_write (1)
    movq $1, %rdi            # file descriptor: stdout (1)
    movq $buffer, %rsi          # address of the message to write
    movq %r12, %rdx           # number of bytes to write (length of the message)
    syscall



        # Exit the program
    movq $60, %rax           # syscall: sys_exit (60)
    xor %rdi, %rdi           # exit code 0
    syscall
