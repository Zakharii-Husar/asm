.section .text
exit_program:
    mov $SYS_exit, %rax                 # Syscall number for exit
    xor %rdi, %rdi                      # Exit status 0 (first argument)
    syscall                             # Invoke syscall

    