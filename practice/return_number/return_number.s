.section .data
number:  .asciz "3\n"  # The string to print with a newline at the end
len = . - number                       # Calculate length of the string

.section .text
.global _start                        # Entry point for the program

_start:
    # Write "3" to stdout
    movq   $1, %rax                  # System call for sys_write (1)
    movq   $1, %rdi                  # File descriptor for stdout (1)
    lea    number, %rsi               # Load address of the string into %rsi
    movq   $len, %rdx                # Length of the string
    syscall                           # Make the system call

    # Exit the program
    movq   $60, %rax                 # System call for sys_exit (60)
    xor    %rdi, %rdi                # Exit code 0
    syscall      