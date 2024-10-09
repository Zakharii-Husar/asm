.section .text

    mov $SYS_write, %rax               # Syscall number for write
    mov %rdi, %rdi                     # File descriptor (first argument)
    lea buffer(%rip), %rsi             # Pointer to message (second argument)
    mov %r12, %rdx                     # Length of message (third argument)
    syscall                            # Invoke syscall
