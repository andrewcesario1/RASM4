// Programer: Andrew Cesario
// Rasm #3
// Purpose: string_startsWith_2
// Author: Andrew Cesario
// Date: 3/24/2023

// Declare the function as a global symbol
.global string_startsWith_2

// Define the function string_startsWith_1
string_startsWith_2:
    // Save the return address and preserve registers as per AAPCS
    stp x29, x30, [sp, -16]!  // Save the frame pointer and link register and decrement the stack pointer by 16 bytes
    stp x19, x20, [sp, -16]!  // Save x19 and x20 and decrement the stack pointer by 16 bytes
    stp x21, x22, [sp, -16]!  // Save x21 and x22 and decrement the stack pointer by 16 bytes
    stp x23, x24, [sp, -16]!  // Save x23 and x24 and decrement the stack pointer by 16 bytes
    stp x25, x26, [sp, -16]!  // Save x25 and x26 and decrement the stack pointer by 16 bytes
    stp x27, x28, [sp, -16]!  // Save x27 and x28 and decrement the stack pointer by 16 bytes
    
    // Set up the frame pointer
    mov x29, sp
    
loop:
    ldrb w3, [x1]    // Load the current character from the prefix string into w3
    ldrb w4, [x0]    // Load the current character from the input string into w4
        
    add x1, x1, #1   // Increment the prefix string pointer
    add x0, x0, #1   // Increment the input string index
        
    cbz w3, true     // If prefix string pointer is 0, set x0 to 1 (true) and branch to end
        
    cmp w3, w4       // Compare the current characters from prefix string and input string
    b.ne false       // If they are not equal, branch to false
        
    b loop           // Otherwise, continue looping
        
true:
    mov x0, #1        // If the prefix string is found at the start of the input string, set x0 to 1 (true)
    b end            // and branch to end
    
false:
    mov x0, #0        // If the prefix string is not found at the start of the input string, set x0 to 0 (false)
    
end:
    // Restore the return address and registers
    ldp x27, x28, [sp], 16  // Restore x27 and x28 and increment the stack pointer by 16 bytes
    ldp x25, x26, [sp], 16  // Restore x25 and x26 and increment the stack pointer by 16 bytes
    ldp x23, x24, [sp], 16  // Restore x23 and x24 and increment the stack pointer by 16 bytes
    ldp x21, x22, [sp], 16  // Restore x21 and x22 and increment the stack pointer by 16 bytes
    ldp x19, x20, [sp], 16  // Restore x19 and x20 and increment the stack pointer by 16 bytes
    ldp x29, x30, [sp], 16  // Restore the frame pointer and link register and increment the stack pointer by 16 bytes
    ret

