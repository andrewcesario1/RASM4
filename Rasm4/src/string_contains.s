// Programmer: [Your Name]
// Rasm #3
// Purpose: substring_existsIgnoreCase
// Author: [Your Name]
// Date: [Date]

.global string_contains

string_contains:
    // Save the return address and preserve registers as per AAPCS
    stp x29, x30, [sp, -16]!  // Save the frame pointer and link register and decrement the stack pointer by 16 bytes
    stp x19, x20, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x21, x22, [sp, -16]!  // Save x21 and x22 and decrement the stack pointer by 16 bytes
    stp x23, x24, [sp, -16]!  // Save x23 and x24 and decrement the stack pointer by 16 bytes
    stp x25, x26, [sp, -16]!  // Save x25 and x26 and decrement the stack pointer by 16 bytes
    stp x27, x28, [sp, -16]!  // Save x27 and x28 and decrement the stack pointer by 16 bytes
    // Set up the frame pointer
    mov x29, sp
    
    
    mov x20, x1
    bl string_copy
    mov x19, x0
    ldr x19, [x19]
    mov x0, x19
    mov x1, x20
    bl lowercase_strings
    mov x19, x0
    mov x20, x1
    
    // Loop through the string
search_loop:
    ldrb w21, [x19] // Load 1 byte from the string into w23 and increment the pointer
    
    // Check if the byte is zero
    cbz w21, not_found
    
    mov x0, x19
    mov x1, x20
    bl string_startsWith_2 // Call string_startsWith_1 to check if the substring starts at this position
    add x19, x19, #1
    
    // Check if the substring was found
    cmp w0, #1
    beq found
    
    // If the substring was not found, continue searching
    b search_loop
    
found:
    // The substring was found, return 1
    mov w0, #1
    b done
    
not_found:
    // The substring was not found,
    mov w0, #0
    b done
    
    
lowercase_strings:
    str x30, [SP, #-16]!            // Decrement SP by 16 bytes and store the value of x30
    
    // Loop through the first string and convert each character to lowercase
    mov x21, #0
    mov x22, #0
loop1:
    ldrb w19, [x0, x21]
    
    cbz w19, loop2
    
    cmp w19, #65
    blt nextchar1
    cmp w19, #90
    bgt nextchar1
    
    add w19, w19, #32
    
    strb w19, [x0, x21]
    
nextchar1:
    add x21, x21, #1
    b loop1
    
loop2:
    ldrb w20, [x1, x22]
    
    cbz w20, lowercaseDone
    
    cmp w20, #65
    blt nextchar2
    cmp w20, #90
    bgt nextchar2
    
    add w20, w20, #32
    
    strb w20, [x1, x22]
    
nextchar2:
    add x22, x22, #1
    b loop2
    
    
lowercaseDone:
    ldr x30, [SP], #16    // Load previous frame pointer from stack and adjust stack pointer
    ret                   // Return from subroutine
    
done:
    // Restore the return address and registers
    ldp x27, x28, [sp], 16  // Restore x27 and x28 and increment the stack pointer by 16 bytes
    ldp x25, x26, [sp], 16  // Restore x25 and x26 and increment the stack pointer by 16 bytes
    ldp x23, x24, [sp], 16  // Restore x23 and x24 and increment the stack pointer by 16 bytes
    ldp x21, x22, [sp], 16  // Restore x21 and x22 and increment the stack pointer by 16 bytes
    ldp x19, x20, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x29, x30, [sp], 16  // Restore the frame pointer and link register and increment the stack pointer by 16 bytes
    ret
    
    ldr x0, [x0]
    bl free
    
.data
szString: .skip 512

