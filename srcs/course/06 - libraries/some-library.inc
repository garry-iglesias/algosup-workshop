; =============================================================================
; =============================================================================

%ifndef SOME_LIBRARY
%define SOME_LIBRARY

section .text

; -----------------------------------------------
; ds:dx -> string to display ($ terminated).
DOS_printString:
    mov ah, 9
    int 21h

; -----------------------------------------------
exitToDOS:
    mov ah, 4Ch
    xor al, al
    int 21h

%endif
