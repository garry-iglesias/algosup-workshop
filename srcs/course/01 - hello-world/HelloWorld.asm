org 100h

; -----------------------------------------------
; We declare some initialized data.
section .data
    hello db 'Hello, World!$'   ; DOS printable string must be terminated by a dollar sign.

; -----------------------------------------------
; This section host code.
section .text

    ; Print the message to the screen
    mov ah, 9       ; AH=9 means "print string" function
    mov dx, hello   ; Load the offset address of 'hello' into DX
    int 21h         ; Call the DOS interrupt 21h to execute the function

    ; Exit the program
    mov ah, 4Ch     ; AH=4Ch means "exit" function
    xor al, al      ; Set AL to 0 (return code)
    int 21h         ; Call the DOS interrupt 21h to exit the program
