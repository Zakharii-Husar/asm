    .section .data
buffer: .space 100         # Reserve 100 bytes for input buffer
prompt_msg:    .asciz "Enter input: "
prompt_length: .quad 13
filename:
    .string "./write_to_file/log.txt"          # File name
message:
    .string "Appending this line.\n"  # Message to append
msg_len = . - message               # Length of the message

    .section .text
    .global _start

    # Define system call numbers
    .equ SYS_open, 2
    .equ SYS_write, 1
    .equ SYS_close, 3
    .equ SYS_exit, 60

    # Define open flags
    .equ O_WRONLY, 0x1
    .equ O_CREAT, 0x40
    .equ O_APPEND, 0x400

    # Combine flags for open syscall
    .equ FLAGS, O_WRONLY | O_CREAT | O_APPEND

    # Define file mode (permissions) for created file: rw-r--r--22
    .equ FILE_MODE, 0644

_start:

        # Write the prompt "Enter input: " to stdout
    movq $SYS_write, %rax
    movq $SYS_write, %rdi
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


    # ----------------------------
    # 1. Open the File
    # ----------------------------

    mov $SYS_open, %rax               # Syscall number for open
    lea filename(%rip), %rdi          # Pointer to filename (first argument)
    mov $FLAGS, %rsi                  # Flags (second argument)
    mov $FILE_MODE, %rdx               # Mode (third argument, only if O_CREAT is set)
    syscall                            # Invoke syscall

    cmp $-4095, %rax                   # Check if syscall returned an error
    jae exit_program                   # If error, exit

    mov %rax, %rdi                     # Save file descriptor in %rdi for later use

    # ----------------------------
    # 2. Write to the File
    # ----------------------------

    mov $SYS_write, %rax               # Syscall number for write
    mov %rdi, %rdi                     # File descriptor (first argument)
    lea buffer(%rip), %rsi             # Pointer to message (second argument)
    mov %r12, %rdx                  # Length of message (third argument)
    syscall                            # Invoke syscall

    # ----------------------------
    # 3. Close the File
    # ----------------------------

    mov $SYS_close, %rax               # Syscall number for close
    mov %rdi, %rdi                     # File descriptor to close (first argument)
    syscall                            # Invoke syscall

    # ----------------------------
    # 4. Exit the Program
    # ----------------------------

exit_program:
    mov $SYS_exit, %rax                 # Syscall number for exit
    xor %rdi, %rdi                      # Exit status 0 (first argument)
    syscall                            # Invoke syscall
