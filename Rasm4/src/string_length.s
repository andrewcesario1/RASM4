// Programer: Andrew Cesario
// Rasm #3
// Purpose: String length function
// Author: Andrew Cesario
// Date: 3/24/2023
//
//
// X0-X2 - parameters to linux function services
// X8 - linux function number
//
//
// Subroutine String_length: Provided a pointer to a null terminated string, String_length will 
//      return the length of the string in X0
// X0: Must point to a null terminated string
// LR: Must contain the return address
// All registers are preserved, except X0

.text
.global string_length

string_length:
    // Save the return address and preserve registers as per AAPCS
    stp x29, x30, [sp, -16]!  // Save the frame pointer and link register and decrement the stack pointer by 16 bytes
    stp x1, x2, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x3, x4, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x5, x6, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x7, x8, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x9, x10, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x11, x12, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x13, x14, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x15, x16, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x17, x18, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x19, x20, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x21, x22, [sp, -16]!  // Save x21 and x22 and decrement the stack pointer by 16 bytes
    stp x23, x24, [sp, -16]!  // Save x23 and x24 and decrement the stack pointer by 16 bytes
    stp x25, x26, [sp, -16]!  // Save x25 and x26 and decrement the stack pointer by 16 bytes
    stp x27, x28, [sp, -16]!  // Save x27 and x28 and decrement the stack pointer by 16 bytes
    // Set up the frame pointer
    mov x29, sp

    // Load the string pointer into register x1
    mov x1, x0
    
    mov x0, #0

loop:
    // Load the byte at the current address into register w2
    ldrb w2, [x1], #1
    // Check if it's a null terminator
    cbz w2, done
    // If it's not, increment the length counter
    add x0, x0, #1
    // Repeat until we reach the null terminator
    b loop

done:
    // Restore the return address and registers
    ldp x27, x28, [sp], 16  // Restore x27 and x28 and increment the stack pointer by 16 bytes
    ldp x25, x26, [sp], 16  // Restore x25 and x26 and increment the stack pointer by 16 bytes
    ldp x23, x24, [sp], 16  // Restore x23 and x24 and increment the stack pointer by 16 bytes
    ldp x21, x22, [sp], 16  // Restore x21 and x22 and increment the stack pointer by 16 bytes
    ldp x19, x20, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x17, x18, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x15, x16, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x13, x14, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x11, x12, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x9, x10, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x7, x8, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x5, x6, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x3, x4, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x1, x2, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x29, x30, [sp], 16  // Restore the frame pointer and link register and increment the stack pointer by 16 bytes
    ret
