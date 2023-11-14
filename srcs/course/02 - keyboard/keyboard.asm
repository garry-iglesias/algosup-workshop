; =============================================================================
;
; x86/DOS Assembly Keyboard buffer example.
;
; =============================================================================
org 100h

; -----------------------------------------------
; We declare some initialized data.
section .data
    charDump db `Entered character: '`
    charValue db 'X'
    charDumpTail db `'\r\n$`

; -----------------------------------------------
; This section host code.
section .text
readKeyboard:
    ; Read next key in buffer:
    xor ax, ax
    int 16h

    ; Overwrite the first char in 'charDump' with received char:
    mov [charValue] ,al

    ; Print the loaded char:
    mov ah, 9
    mov dx, charDump
    int 21h

    ; Compare the red char with ESCAPE (ASCII #27)
    cmp byte [charValue] ,27
    jne readKeyboard        ; Loop while not "escape".

    ; Exit the program
    mov ah, 4Ch
    xor al, al
    int 21h
