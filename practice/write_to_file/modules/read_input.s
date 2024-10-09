.section .text

    movq $SYS_read, %rax            # syscall: sys_read (0)
    movq $SYS_read, %rdi            # file descriptor: stdin (0)
    movq $buffer, %rsi       # address of the buffer to store the input
    movq $100, %rdx          # number of bytes to read (max 100 bytes)
    syscall
    movq %rax, %r12          # Save input lenght to a register
