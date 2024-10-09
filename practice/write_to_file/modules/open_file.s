.section .data
filename:
    .string "./write_to_file/log.txt"
.section .text

    mov $SYS_open, %rax               # Syscall number for open
    lea filename(%rip), %rdi          # Pointer to filename (first argument)
    mov $FLAGS, %rsi                  # Flags (second argument)
    mov $FILE_MODE, %rdx               # Mode (third argument, only if O_CREAT is set)
    syscall                            # Invoke syscall

    cmp $-4095, %rax                   # Check if syscall returned an error
    jae exit_program                   # If error, exit

    mov %rax, %rdi                     # Save file descriptor in %rdi for later use
    