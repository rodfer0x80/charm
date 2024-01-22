.section .data
hello_msg:  .asciz "Hello, ARM!\n"

.section .text
.global _start

_start:
    @ write the message to stdout
    ldr r0, =1        @ file descriptor 1 (stdout)
    ldr r1, =hello_msg @ pointer to the message
    ldr r2, =13        @ message length
    mov r7, #4         @ system call number for write
    swi 0              @ make the system call

    @ exit the program
    mov r7, #1         @ system call number for exit
    mov r0, #0         @ exit code 0
    swi 0              @ make the system call

