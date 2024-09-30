.section .data
data_items:
    # These are the data items
    .long 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 66, 0
    length:
    .long 13  # Number of items in data_items

.section .text
.globl _start
_start:
    movl $0, %edi                # Move 0 into the index register (for array indexing)
    movl data_items(,%edi,4), %eax  # Load the first data item
    movl %eax, %ebx              # The first item is the largest so far

start_loop:
    cmpl $0, %eax                # Check if we've reached the end (0 terminator)
    je loop_exit                 # If yes, jump to loop_exit
    incl %edi                    # Increment index
    movl data_items(,%edi,4), %eax  # Load the next value
    cmpl %ebx, %eax              # Compare the current value with the largest
    jle start_loop               # If the current value is not larger, continue loop
    movl %eax, %ebx              # Otherwise, update the largest value
    jmp start_loop               # Repeat the loop

loop_exit:
    # %ebx contains the largest value found
    # %ebx is also the status code for the exit system call
    movl %ebx, %edi              # Move the result to the exit status

    # Perform system call to exit
    movl $60, %eax               # System call for exit (60)
    syscall                      # Make the syscall to exit
