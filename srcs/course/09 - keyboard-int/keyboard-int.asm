org 100h
section .text
    jmp programStart        ;; Jump to program entry point.

%include "keyboard.inc"
%include "system.inc"
%include "strings.inc"

section .bss
    ;printBuffer resb 5

section .text
; -----------------------------------------------
programStart:
    call nsKeyboardInitialize
.waitForQuit:
    call dumpPressedKeys
    mov al ,[nsKeyboardMap + SCANCODE_ESC]
    cmp al ,0
    jz .waitForQuit
    call nsKeyboardShutdown
    jmp sysExitProgram


section .data
    msgDumpKeyboardMap db 'Currently pressed scan codes:' ,0
    msgEraseLineEnd db `         \r` ,0
    scanCodePrintBuffer db ' XX' ,0

section .text
; -----------------------------------------------
dumpPressedKeys:
    mov si ,msgDumpKeyboardMap
    call printAsciiZ
    ;mov si ,nsKeyboardMap
    ;mov cx ,SCANCODE_COUNT
    xor bx ,bx
.eachScanCode:
    mov al ,[nsKeyboardMap + bx]
    cmp al ,0
    jz .nextScanCode
    push bx
    mov al ,bl
    mov di ,scanCodePrintBuffer
    inc di
    call stringUByteToHexa
    call printSpace
    mov si ,scanCodePrintBuffer
    call printAsciiZ
    pop bx
.nextScanCode:
    ;call printCarriageReturn
    inc bx
    cmp bx ,SCANCODE_COUNT
    jb .eachScanCode

    ; Clear line tail and go back to origin.
    mov si ,msgEraseLineEnd
    call printAsciiZ
    ret
