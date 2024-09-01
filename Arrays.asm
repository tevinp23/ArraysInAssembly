# Define constants
.data
array:  .space 400      # Reserve space for 100 integers (each integer takes 4 bytes)


# Initialize variables
    .text
    .globl main

main:
    # Initialize variables
    li  t0, 0    # Loop counter
    li  t1, 100  # Number of integers in the array
    li  t2, 0    # Accumulator for sum
    la  t3, array # Load address of the array into t3
    
    # Generate random numbers and store in array
generate_loop:
    beq t0, t1, accumulate   # If loop counter == 100, exit loop
    jal ra, random_number     # Call random_number function
    sw  a0, 0(t3)             # Store random number in array
    addi t3, t3, 4            # Move to next element in array
    addi t0, t0, 1            # Increment loop counter
    j   generate_loop         # Jump back to the beginning of the loop

accumulate:
    li  t0, 0                  # Reset loop counter
    lw  t3, array              # Load address of the array into t3
    
    # Accumulate sum of array elements
accumulate_loop:
    beq t0, t1, calculate_average # If loop counter == 100, exit loop
    lw  t4, 0(t3)                 # Load array element into t4
    add  t2, t2, t4               # Add array element to sum
    addi t3, t3, 4                # Move to next element in array
    addi t0, t0, 1                # Increment loop counter
    j   accumulate_loop           # Jump back to the beginning of the loop

calculate_average:
    li  t5, 100           # Load divisor (number of elements)
    div t2, t2, t5            # Calculate average

    
    # Print average
    li  a0, 1             # File descriptor for stdout
    mv  a1, t2            # Move average to a1 (argument for print_integer)
    jal ra, print_integer # Call print_integer function
    
    # Print newline
    li  a0, 4             # File descriptor for stdout

    li  a2, 1             # Length of string
    li  a3, 0             # Unused argument
    ecall                 # System call to print newline
    
    # Return average
    mv  a0, t2            # Move average to a0
    li  a1, 10            # Return syscall number
    ecall                 # System call to exit

# Function to generate random number
random_number:
    li  a0, 32768   # Set upper limit for random number
    li  a1, 0       # Set lower limit for random number
    li  a7, 0       # Specify system call number for random number generation
    ecall           # System call to generate random number


# Function to print integer
print_integer:
    li  a7, 1       # Specify system call number for printing integer
    ecall           # System call to print integer
    ret             # Return from function

# Return from function
