// Programer: Andrew Cesario
// Rasm #3
// Purpose: string_copy
// Author: Andrew Cesario
// Date: 3/24/2023

.global string_copy

string_copy:
    // Save the return address and preserve registers as per AAPCS
    stp x29, x30, [sp, -16]!  // Save the frame pointer and link register and decrement the stack pointer by 16 bytes
    stp x19, x20, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x21, x22, [sp, -16]!  // Save x21 and x22 and decrement the stack pointer by 16 bytes
    stp x23, x24, [sp, -16]!  // Save x23 and x24 and decrement the stack pointer by 16 bytes
    stp x25, x26, [sp, -16]!  // Save x25 and x26 and decrement the stack pointer by 16 bytes
    stp x27, x28, [sp, -16]!  // Save x27 and x28 and decrement the stack pointer by 16 bytes
    // Set up the frame pointer
    mov x29, sp
    
    // Get the length of the string
    mov x19, x0   // Copy the string pointer to another register
    bl string_length   // Call string_length to get the length
    add x0, x0, #1   // Add 1 to account for the null terminator

    bl malloc   // Call malloc to allocate the memory
    ldr x3,=ptrString  // Load the address of the ptrString global variable into x3
    str x0,[x3]  // Store the pointer to the allocated memory in the ptrString global variable
    
    mov x1, x19  // Copy the length of the string to x1
copy_loop:
    ldrb w2, [x1], #1   // Load the current byte of the string to w2 and increment x1 by 1
    strb w2, [x0], #1   // Store the current byte to the new memory location and increment x0 by 1
    cbnz w2, copy_loop   // If the current byte is not zero, loop again

done:
    // Restore the return address and registers
    ldp x27, x28, [sp], 16  // Restore x27 and x28 and increment the stack pointer by 16 bytes
    ldp x25, x26, [sp], 16  // Restore x25 and x26 and increment the stack pointer by 16 bytes
    ldp x23, x24, [sp], 16  // Restore x23 and x24 and increment the stack pointer by 16 bytes
    ldp x21, x22, [sp], 16  // Restore x21 and x22 and increment the stack pointer by 16 bytes
    ldp x19, x20, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x29, x30, [sp], 16  // Restore the frame pointer and link register and increment the stack pointer by 16 bytes
    ldr x0,=ptrString  // Load the address of the ptrString global variable into x0
    ret
    
 .data
 ptrString: .quad 0
