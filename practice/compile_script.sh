#!/bin/bash

# Check if an argument is provided
if [ "$#" -lt 1 ]; then
    echo "Error: Missing argument."
    echo "Usage: $0 <program_name> [true|false]"
    exit 1
fi

program_name=$1
debug_mode=${2:-false} # Default to 'false' if no second argument is provided

# Check if the specified directory exists
if [ ! -d "$program_name" ]; then
    echo "Error: Directory '$program_name' does not exist. Provide a valid program name."
    exit 1
fi

# Compile and link
as -o "${program_name}/${program_name}.o" "${program_name}/${program_name}.s" &&
    ld -o "${program_name}/${program_name}" "${program_name}/${program_name}.o"

# Execute the program
./"${program_name}/${program_name}"
exit_code=$? # Capture the exit code

# Check if debug mode is enabled
if [ "$debug_mode" == "true" ]; then
    echo $exit_code # Print the exit code if in debug mode
fi

exit $exit_code # Exit with the program's exit code
