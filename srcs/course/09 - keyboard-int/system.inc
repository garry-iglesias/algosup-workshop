; =============================================================================
;
;   System/Globals features.
;
; =============================================================================

%ifndef SYSTEM_GLOBALS_UTILS
%define SYSTEM_GLOBALS_UTILS

section .text

; -----------------------------------------------
; Exit the program
sysExitProgram:
    mov ah, 4Ch     ; AH=4Ch means "exit" function
    xor al, al      ; Set AL to 0 (return code)
    int 21h         ; Call the DOS interrupt 21h to exit the program
    ; we are out.

%endif
