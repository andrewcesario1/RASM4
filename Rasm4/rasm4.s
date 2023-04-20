// Programer: Andrew Cesario
// Lab #18
// Purpose: Linked List
// Author: Andrew Cesario
// Date: 4/11/2023
//
//
// X0-X2 - parameters to linux function services
// X8 - linux function number
//
.equ R, 0 // Define constant R to be 0
.equ W, 01 // Define constant W to be 01
.equ RW, 02 // Define constant RW to be 02
.equ T_RW, 01002 // Define constant T_RW to be 01002
.equ C_W, 0101 // Define constant C_W to be 0101
.equ RW_RW____, 0660 // Define constant RW_RW____ to be 0660
.equ AT_FDCWD, -100 // Define constant AT_FDCWD to be -100
.EQU SIZE, 21

.global main     // Declare the global symbol _start
.text              // Begin the .text section

main:            // Define the _start label

while_input_not_7:
    ldr x0, =menu1
    bl  putstring
    
    
    ldr x0, =memoryBytes
    ldr x1, =szMemoryBytes
    bl  int64asc
    ldr x0, =szMemoryBytes
    bl  putstring
    
    ldr x0, =menu2
    bl  putstring
    
    ldr x0, =nodes
    ldr x1, =szNodes
    bl  int64asc
    ldr x0, =szNodes
    bl  putstring
    
    ldr x0, =menu3
    bl  putstring
    
    ldr x0, =kbBuf
    mov x1, #SIZE
    bl  getstring
    ldr x0, =kbBuf
    bl ascint64
    
    mov x21, x0
    cmp x21, #7
    beq end_while_not_7
    
switch_option:
    cmp x21, #1
    bne end_traverse
    
    ldr x0, =chCr
    bl  putch
    bl traverse
    b while_input_not_7
    
end_traverse:
    cmp x21,  #2
    
    bne end_add_list
    
    ldr x0, =menu
    bl  putstring
    
    ldr x0, =kbBuf2
    mov x1, #SIZE
    bl  getstring
    ldr x0, =kbBuf2
    mov w1, #0x61
    
    ldr w0, [x0]
    cmp w0, w1
    
    bne end_add_a_list
    
    ldr x0, =addFromKeyboard
    bl  putstring
    ldr x0, =kbBuf
    mov x1, #512
    bl  getstring
    ldr x19, =kbBuf
    bl  insertLast
    b while_input_not_7
    
end_add_a_list:
    ldr x0, =fileNameOutput
    bl  putstring
    
    ldr x0, =szFile
    mov x1, #SIZE
    bl  getstring
    
    mov x0, #AT_FDCWD // Move the value of AT_FDCWD into x0
    mov x8, #56 // Move the value 56 into x8
    ldr x1, =szFile // Load the address of szFile into x1
    
    mov x2, #R // Move the value of R into x2
    mov x3, #RW_RW____ // Move the value of RW_RW____ into x3
    svc 0 // Call the kernel with syscall number 0
    
    ldr x4, =iFD
    strb w0, [x4]
    
readFileTop:
    ldr x1, =fileBuf
    bl  getline
    cmp x0, #0
    beq last
    
    ldr x19, =fileBuf
    bl insertLast
    
    ldr x0, =iFD
    ldrb w0, [x0]
    
    b readFileTop
    
last:
    ldr x0, =iFD
    ldrb w0, [x0]
    
    mov x8, #57
    svc 0
    
    b while_input_not_7
    
end_add_list:
    cmp x21, #3
    
    bne end_delete_list
    
    ldr x0, =enterIndex
    bl  putstring
    
    
    
    
    
end_delete_list:
    cmp x21, #4
    
    bne end_edit_list
    
    ldr x0, =enterIndex
    bl  putstring
    
    ldr x0, =kbBuf
    mov x1, #SIZE
    bl  getstring
    ldr x0, =kbBuf
    bl ascint64
    
    ldr x1, =indexToEdit
    str x0, [x1]

    
    ldr x0, =changeIndex
    bl  putstring

    
    ldr x0, =userString
    ldr x0, [x0]
    cmp x0, #0
    bgt secondIndexChange
    ldr x0, =userString
    mov x1, #512
    bl  getstring
    
    ldr x0, =userString
    
edit_start:
    ldr x1, =indexToEdit
    ldr x1, [x1]

    bl edit_traverse
    
    b while_input_not_7
    
secondIndexChange:
    ldr x0, =userString2
    mov x1, #512
    bl  getstring
    
    ldr x1, =indexToEdit
    ldr x1, [x1]
    
    ldr x0, =userString2
    
    b edit_start
    
end_edit_list:
    cmp x21, #5
    
    bne end_search_list
    
    ldr x0, =searchMenu
    bl  putstring
    
    ldr x0, =searchIn
    mov x1, #512
    bl  getstring
    
    ldr x0, =searchIn
    mov x24, x0
    bl  search_traverse
    
    b while_input_not_7
    
    
    
    
end_search_list:
    cmp x21, #6
    
    bne end_save_list
    
    ldr x0, =fileNameOutput
    bl  putstring
    
    ldr x0, =filename
    mov x1, #SIZE
    bl  getstring
    
    bl save_traverse
    
    b while_input_not_7
    
    
end_save_list:
   cmp x21, #7
  
   bne error
   
end_while_not_7:
   b exit
   
error:
    ldr x0, =errorInput
    bl  putstring
    
    b while_input_not_7

    // Exit the program
exit:
    mov X0, #0             // Move the value 0 into the x0 register
    mov X8, #93            // Move the value 93 into the x8 register
    svc 0                  // Call the kernel with syscall number 0

insertLast:
    str x30, [SP, #-16]!  // Save the return address on the stack

    mov x0, #16     // Move the value 16 into register x0
    bl malloc       // Call malloc to allocate memory for a new node

    ldr x1, =newNode  // Load the memory address of newNode into register x1
    str x0, [x1]    // Store the memory address returned by malloc in newNode

    mov x0, x19     // Move the value of x19 into register x0
    bl string_copy  // Call the string_copy function to copy the string to the new node

    ldr x1, =newNode  // Load the memory address of newNode into register x1
    ldr x1, [x1]    // Load the memory address of the new node into register x1
    ldr x0, [x0]    // Load the memory address of the string into register x0
    str x0, [x1]    // Store the memory address of the string in the new node

    mov x3, #0      // Move the value 0 into register x3
    add x1, x1, #8  // Increment the address in register x1 by 8
    str x3, [x1]    // Store the value 0 in the next field of the new node

    ldr x0, =head   // Load the memory address of head into register x0
    ldr x0, [x0]    // Load the memory address of the head node into register x0
    CBNZ x0, NOTEMPTY   // If x0 is non-zero, jump to the NOTEMPTY label
    
    ldr x1, =newNode                // Load the address of `newNode` into register x1
    ldr x1, [x1]                    // Load the value stored at `newNode` into register x1

    ldr x0, =head                   // Load the address of `head` into register x0
    str x1, [x0]                    // Store the value of register x1
    ldr x0, =tail                   // Load the address of `tail` into register x0
    str x1, [x0]                    // Store the value of register x1

    b insertLastEnd                 // Branch to the function `insertLastEnd`

NOTEMPTY:
    ldr x0, =tail                   // Load the address of `tail` into register x0
    ldr x0, [x0]                    // Load the value stored at `tail` into register x0
    ldr x1, =newNode                // Load the address of `newNode` into register x1
    ldr x1, [x1]                    // Load the value stored at `newNode` into register x1

    str x1, [x0, #8]                // Store the value of register x1
    ldr x0, =tail                   // Load the address of `tail` into register x0
    str x1, [x0]                    // Store the value of register x1

insertLastEnd:
    ldr x30, [SP], #16              // Load the value stored at SP into register x30
    ret                             // Return to the calling function and pop the return address

traverse:
    str x30, [SP, #-16]!            // Decrement SP by 16 bytes and store the value of x30

    ldr x0, =head                   // Load the address of `head` into register x0
    ldr x0, [x0]                    // Load the value stored at `head` into register x0

    ldr x1, =currentNode            // Load the address of `currentNode` into register x1
    str x0, [x1]                    // Store the value of register x0
    
    cmp x0, #0
    beq traverse_end_0
    
    mov x23, #0
traverse_top:
    cmp x0, #0                      // Compare the value stored in x0 with 0
    beq traverse_end                // If they are equal, branch to `traverse_end`
    
    
    ldr x0, [x0]                    // Load the value pointed by register x0 into register x0
    ldr x1, =szIndex
    str x0, [x1]
    
    ldr x0, =openingB
    bl  putstring
    mov x0, x23
    ldr x1, =index
    bl  int64asc
    
    ldr x0, =index
    bl  putstring
    
    ldr x0, =closingB
    bl  putstring
    
    
    ldr x0, =szIndex
    ldr x0, [x0]
    bl putstring                    // Call the function `putstring`
    
    ldr x0, =chCr
    bl  putch

    
    add x23, x23, #1
    
    ldr x1, =currentNode            // Load address of 'currentNode' into x1
    ldr x1, [x1]          // Load value of pointer into x1
    add x1, x1, #8        // Add 8 bytes to the pointer in x1
    ldr x1, [x1]          // Load value of pointer into x1
    
    
    ldr x0, =currentNode   // Load address of 'currentNode' into x0
    str x1, [x0]          // Store value of x1 into 'currentNode'
    
    
    mov x0, x1            // Copy value of x1 into x0
    b traverse_top        // Branch to 'traverse_top' label
    
    
traverse_end:         // Define 'traverse_end' label
    ldr x30, [SP], #16    // Load previous frame pointer from stack and adjust stack pointer
    ret                   // Return from subroutine
    
traverse_end_0:
    ldr x0, =empty
    bl  putstring
    b   traverse_end
    
save_traverse:
    str x30, [SP, #-16]!            // Decrement SP by 16 bytes and store the value of x30

    ldr x11, =head                   // Load the address of `head` into register x0
    ldr x11, [x11]                    // Load the value stored at `head` into register x0

    ldr x12, =currentNode            // Load the address of `currentNode` into register x1
    str x11, [x12]                    // Store the value of register x0
    
    
    mov x0, #-100 // Move the value -100 into the x0 register
    mov x8, #56 // this will be used to indicate that we want to open a file
    ldr x1, =filename // Load the address of the filename string into x1
    mov x2, #0101 // sets the flags for file permissions
    mov x3, #0600 // sets the flags for file access modes
    svc 0 // open the file
    
    ldr x4, =iFA
    strb w0, [x4]
    
    
save_traverse_top:
    cmp x11, #0                      // Compare the value stored in x0 with 0
    beq save_traverse_end                // If they are equal, branch to `traverse_end`
    
    ldr x0, [x11] // Load the address of the string into x1
    bl  string_length
    
    mov x2, x0
    
    ldr x0, =iFA
    ldrb w0, [x0]
  
   
    mov x8, #64 // indicate that we want to write to a file
    ldr x1, [x11] // Load the address of the string into x1
    svc 0 // write the string to the file
    
    ldr x12, =currentNode            // Load address of 'currentNode' into x1
    ldr x12, [x12]          // Load value of pointer into x1
    add x12, x12, #8        // Add 8 bytes to the pointer in x1
    ldr x12, [x12]          // Load value of pointer into x1
    
    
    ldr x11, =currentNode   // Load address of 'currentNode' into x0
    str x12, [x11]          // Store value of x1 into 'currentNode'
    
    
    mov x11, x12            // Copy value of x1 into x0
    
    
    b save_traverse_top        // Branch to 'traverse_top' label
    
    
save_traverse_end:         // Define 'traverse_end' label
    ldr x0, =iFA
    ldrb w0, [x0]
    mov x8, #57
    svc 0
    
    ldr x30, [SP], #16    // Load previous frame pointer from stack and adjust stack pointer
    ret                   // Return from subroutine
    
search_traverse:
    str x30, [SP, #-16]!            // Decrement SP by 16 bytes and store the value of x30

    ldr x19, =head                   // Load the address of `head` into register x0
    ldr x19, [x19]                    // Load the value stored at `head` into register x0

    ldr x20, =currentNode            // Load the address of `currentNode` into register x1
    str x19, [x20]                    // Store the value of register x0
    
    cmp x19, #0
    beq search_traverse_end_0
    
    mov x23, #0
    mov x26, #0
    
search_traverse_top:
    cmp x19, #0                      // Compare the value stored in x0 with 0
    beq search_traverse_end                // If they are equal, branch to `traverse_end`
    
    ldr x0, [x19]                    // Load the value pointed by register x0 into register x0
    ldr x1, =szIndex
    str x0, [x1]
    
    ldr x0, [x19] // Load the address of the string into x1
    mov x1, x24
    bl string_contains
    
    cmp x0, #0
    beq search_skip_output
    
    ldr x0, =openingB
    bl  putstring
    mov x0, x23
    ldr x1, =index
    bl  int64asc
    
    ldr x0, =index
    bl  putstring
    
    ldr x0, =closingB
    bl  putstring
    
    
    ldr x0, =szIndex
    ldr x0, [x0]
    bl putstring                    // Call the function `putstring`
    
    ldr x0, =chCr
    bl  putch
    
    
    add x26, x26, #1

    

search_skip_output:    
    add x23, x23, #1
    
    ldr x20, =currentNode            // Load address of 'currentNode' into x1
    ldr x20, [x20]          // Load value of pointer into x1
    add x20, x20, #8        // Add 8 bytes to the pointer in x1
    ldr x20, [x20]          // Load value of pointer into x1
    
    
    ldr x0, =currentNode   // Load address of 'currentNode' into x0
    str x20, [x0]          // Store value of x1 into 'currentNode'
    
    
    mov x19, x20           // Copy value of x1 into x0
    b search_traverse_top        // Branch to 'traverse_top' label
    
    
search_traverse_end:         // Define 'traverse_end' label
    cmp x26, #1
    blt search_nothing
    ldr x30, [SP], #16    // Load previous frame pointer from stack and adjust stack pointer
    ret                   // Return from subroutine
    
search_traverse_end_0:
    ldr x0, =empty
    bl  putstring
    b   search_traverse_end
    
search_nothing:
    ldr x0, =noSearches
    bl  putstring
    mov x26, #1
    b   search_traverse_end
    
edit_traverse:
    str x30, [SP, #-16]!            // Decrement SP by 16 bytes and store the value of x30
    
    mov x19, x0
    mov x20, x1
    
    ldr x0, =head                   // Load the address of `head` into register x0
    ldr x0, [x0]                    // Load the value stored at `head` into register x0

    ldr x1, =currentNode            // Load the address of `currentNode` into register x1
    str x0, [x1]                    // Store the value of register x0
    
    cmp x0, #0
    beq edit_traverse_end_0
    
    mov x23, #0
edit_traverse_top:
    cmp x23, x20                      // Compare the value stored in x0 with 0
    bne edit_next_node                // If they are equal, branch to `traverse_end`
    
    
    str x19, [x0]
    
    b edit_traverse_end

edit_next_node:
    add x23, x23, #1
    
    ldr x1, =currentNode            // Load address of 'currentNode' into x1
    ldr x1, [x1]          // Load value of pointer into x1
    add x1, x1, #8        // Add 8 bytes to the pointer in x1
    ldr x1, [x1]          // Load value of pointer into x1
    
    
    ldr x0, =currentNode   // Load address of 'currentNode' into x0
    str x1, [x0]          // Store value of x1 into 'currentNode'
    
    
    mov x0, x1            // Copy value of x1 into x0
    b edit_traverse_top        // Branch to 'traverse_top' label
    
    
edit_traverse_end:         // Define 'traverse_end' label
    ldr x30, [SP], #16    // Load previous frame pointer from stack and adjust stack pointer
    ret                   // Return from subroutine
    
edit_traverse_end_0:
    ldr x0, =empty
    bl  putstring
    b   edit_traverse_end
    
getchar: // Define the getchar label
    mov x2, #1 // Move the value 1 into x2
    mov x8, #63 // Move the value 63 into x8
    svc 0 // Call the kernel with syscall number 0
    ret
    
getline:
    str x30, [SP, #-16]!

top:
    bl getchar
    
    ldrb w2, [x1]
    
    cmp x0, #0x0
    BEQ EOF
    
    cmp x0, #0x0
    BLT fileError
    
    add x1, x1, #1
    
    ldr x0, =iFD
    ldrb w0, [x0]
    
    cmp w2, #0xa
    beq EOLINE
    
    b top
    
EOLINE:
    mov w2, #0
    strb w2, [x1]
    b skip

EOF:
    mov x19, x0
    mov x0, x19
    b skip

fileError:
    mov x19, x0
    mov x0, x19
    b skip

skip:
    ldr x30, [SP], #16
    ret

   .data
head: .quad 0
tail: .quad 0
chCr: .byte 0xA
newNode: .quad 0
currentNode: .quad 0

kbBuf: .skip 512
kbBuf2: .skip 21
fileBuf: .skip 512
menu1: .asciz "\n\n              RASM4 TEXT EDITOR\n      Data Structure Heap Memory Consumption: "
menu2: .asciz " bytes\n      Number of Nodes: "
menu3: .asciz "\n<1> View all strings\n\n<2> Add string\n   <a> from keyboard\n   <b> from File\n\n<3> Delete string.\n\n<4> Edit string.\n\n<5> String search.\n\n<6> Save File (output.txt)\n\n<7> Quit\n\nEnter option: "
menu: .asciz "Enter a or b: "

nodes: .quad 0
szNodes: .skip 21
index: .skip 21
memoryBytes: .skip 21
szMemoryBytes: .skip 21
addFromKeyboard: .asciz "Enter String: "
successView: .asciz "\nAll strings in list:\n\n"
successAdd: .asciz "\nAdded to list.\n"
empty:      .asciz "[Empty]\n"
openingB: .asciz "["
closingB:  .asciz "] "
str1:  .asciz "The Cat in the Hat\n"
fileNameOutput: .asciz "Enter the file name: "
searchMenu: .asciz "Search for: "
searchIn: .skip 512
noSearches: .asciz "No search results found\n"
enterIndex: .asciz "Enter index: "
changeIndex: .asciz "Change to: "
indexToEdit: .quad 0
userString: .skip 512
userString2: .skip 512

line: .skip 512

errorInput: .asciz "Not a valid option\n"
szFile: .skip 21
filename: .skip 21
iFD: .byte 0
iFA: .byte 0
szIndex: .skip 512
