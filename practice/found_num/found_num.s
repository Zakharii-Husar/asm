# %edi - Holds the index of the data item being examined
# %ebx - Found data item found
# %eax - Current data item

.section .data
data_items:
    .long 28, 67, 34, 222, 45, 75, 255, 7, 44, 33, 22, 300, 11, 66, 777

.section .text
.globl _start
_start:
    movl $0, %edi                # Initialize index (for array indexing)
    
start_loop:
    cmpl $14, %edi               # Compare index with the length (14 items)
    jge loop_exit                # If index >= length, exit the loop
    movl data_items(,%edi,4), %eax  # Load the current data item
    
    cmpl $255, %eax              # Check if the current item is 255
    je found_number              # If yes, jump to found_number
    
    incl %edi                    # Increment index
    jmp start_loop               # Repeat the loop

found_number:
    movl %eax, %edi                # Set exit status to 1 (indicating 222 was found)
    jmp loop_exit                # Jump to exit

loop_exit:
    movl $60, %eax               # System call for exit (60)
    syscall                       # Make the syscall to exit
