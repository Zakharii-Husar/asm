.section .data
buffer: .space 100         # used by write & read_input

message:
    .string "Appending this line.\n"           # Message to append
msg_len = . - message                          # Length of the message

    .section .text
    .global _start

    # Define system call numbers
    .equ SYS_read, 0
    .equ SYS_write, 1
    .equ SYS_open, 2
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
    # ----------------------------
    # 1. Write the prompt
    # ----------------------------
    .include "./write_to_file/modules/prompt_msg.s"
    # ----------------------------
    # 2. Read user input & save it to the buffer
    # ----------------------------
     .include "./write_to_file/modules/read_input.s"
    # ----------------------------
    # 3. Open the File
    # ----------------------------
    .include "./write_to_file/modules/open_file.s"
    # ----------------------------
    # 4. Write to the File
    # ----------------------------
    .include "./write_to_file/modules/write_output.s"
    # ----------------------------
    # 5. Close the File
    # ----------------------------
     .include "./write_to_file/modules/close_file.s"
    # ----------------------------
    # 6. Exit the Program
    # ----------------------------
    .include "./write_to_file/modules/exit.s"

    