    movq $SYS_write, %rax
    movq $SYS_write, %rdi
    movq $prompt_msg, %rsi          # address of the message to write
    movq prompt_length, %rdx           # number of bytes to write (length of the message)
    syscall