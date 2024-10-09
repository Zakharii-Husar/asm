.section .text
    mov $SYS_close, %rax               # Syscall number for close
    mov %rdi, %rdi                     # File descriptor to close (first argument)
    syscall                            # Invoke syscall
    