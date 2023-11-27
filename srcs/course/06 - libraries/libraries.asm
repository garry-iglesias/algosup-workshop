; =============================================================================
;
; Assembly "library" example.
;
; =============================================================================
org 100h

section .data
    libraryText db 'Library example!$'

section .text
    mov dx ,libraryText
    call DOS_printString
    call exitToDOS

%include "some-library.inc"
