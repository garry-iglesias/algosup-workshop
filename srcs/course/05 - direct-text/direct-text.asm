; =============================================================================
;
; x86/DOS Assembly Direct To Memory text example.
;
; =============================================================================
org 100h

%define TEXT_MEM_SEGMENT 0b800h
%define TEXT_ATTRIBUTES 0fh

%define AT_LINE     12
%define AT_COLUMN   12

section .data
textContent db 'Direct Memory Text' ,0

section .text
    ; es:di -> points to text video memory.
    mov ax ,TEXT_MEM_SEGMENT
    mov es ,ax
    ;xor di ,di                                     ; <- up-left corner.
    mov di ,((AT_LINE-1)*160) + ((AT_COLUMN-1)*2)   ; <- at specific location.

    ; ds:si -> source text.
    mov si ,textContent

    ; prefetch text attributes.
    mov ah ,TEXT_ATTRIBUTES

displayLoop:
    ; load next char:
    lodsb

    ; end of source string ?
    cmp al ,0
    je endDisplay

    ; write loaded char and attribute:
    stosw
    jmp displayLoop

endDisplay:

    ; - Exit to DOS:
    mov ah, 4ch
    xor al, al
    int 21h
