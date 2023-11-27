;keyboard.inc
; =============================================================================
;
;   Keyboard Handler for 80x86.
;
; =============================================================================
; This handler hooks the hardware keyboard interrupt and update the 
; [nsKeyboardMap] byte array with pressed/released status.
;
; Index in the [nsKeyboardMap] array is the key scan code.
;
; Functions:
;   nsKeyboardInitialize        -> installs the keyboard handler.
;   nsKeyboardShutdown          -> restore the default keyboard handler.
;
; Usage:
;   byte [nsKeyboardMap + scanCode] -> 0: released, 1: pressed.
;
; =============================================================================

%ifndef KEYBOARD_INC
%define KEYBOARD_INC

%ifdef DEBUG_KEYCODE
%include "strings.inc"
%endif

%define SCANCODE_COUNT  128

%define SCANCODE_ESC    (01h)
%define SCANCODE_LEFT   (4bh)
%define SCANCODE_RIGHT  (4dh)
%define SCANCODE_UP     (48h)
%define SCANCODE_DOWN   (50h)

; -----------------------------------------------
; Set interrupt vector.
;   al = int number
;   ds:dx = new vector address
%define DOSFN_SET_INT_VEC   025h
%define SET_DOSFN_SET_INT_VEC( intNum )    mov ax ,(DOSFN_SET_INT_VEC<<8)|intNum

; -----------------------------------------------
; Get interrupt vector.
;   al = int number
; Return:
;   es:bx = new vector address
%define DOSFN_GET_INT_VEC   035h
%define SET_DOSFN_GET_INT_VEC( intNum )    mov ax ,(DOSFN_GET_INT_VEC<<8)|intNum

section .bss
    nsKeyboardPreviousHandler resd 1        ; Low word: segment, High word: offset
    nsKeyboardMap resb SCANCODE_COUNT
%ifdef DEBUG_KEYCODE
    nsKeyCode resb 1                        ; Raw code from keyboard port.
    nsKeyCodePrintBuffer resb 3
%endif

section .data
    kbInitMsg db ` * Initializing keyboard handler...\r\n` ,0
    kbShutMsg db ` * Shutting down keyboard handler...\r\n` ,0

section .text

; -----------------------------------------------
nsKeyboardInitialize:
    mov si ,kbInitMsg
    call printAsciiZ

    ; Get previous vector:
    SET_DOSFN_GET_INT_VEC( 09h )
    int 21h
    ; es:bx => eax
    mov ax ,bx
    shl eax ,16
    mov ax ,es
    mov [nsKeyboardPreviousHandler] ,eax

    ; Set new vector:
    SET_DOSFN_SET_INT_VEC( 09h )
    mov dx ,nsKeyboardInterruptHandler
    int 21h

    ; Clear keyboard map:
    mov ax ,ds
    mov es ,ax
    xor eax ,eax
    mov di ,nsKeyboardMap
    mov cx ,(128 / 4)
    rep stosd
    ret

; -----------------------------------------------
nsKeyboardShutdown:
    mov si ,kbShutMsg
    call printAsciiZ

    ; Load previous handler in ds:dx
    mov eax ,[nsKeyboardPreviousHandler]
    mov edx ,eax
    shr edx ,16
    push ds
    mov ds ,ax
    SET_DOSFN_SET_INT_VEC( 09h )
    int 21h
    pop ds
    ret

; -----------------------------------------------
nsKeyboardInterruptHandler:
    pushf
    push ds
    push ax
    push bx

    ; Restore ds to our segment:
    mov ax ,cs
    mov ds ,ax

    ; Read scan code
    in al ,60h

%ifdef DEBUG_KEYCODE
    push es
    push si
    push di
    mov [nsKeyCode] ,al ; keep it around...
    mov bx ,ds
    mov es ,bx
    mov di ,nsKeyCodePrintBuffer
    call stringUByteToHexa
    mov si ,nsKeyCodePrintBuffer
    call printAsciiZ
    mov al ,[nsKeyCode]
    pop di
    pop si
    pop es
%endif

    mov bl ,al
    and bx ,7fh
    ;and al ,80h
    shr al ,7
    xor al ,1
    mov [nsKeyboardMap + bx] ,al
    
    ; Complete interrupt handling (PIC):
    mov al ,20h
    out 20h ,al

    pop bx
    pop ax
    pop ds
    popf
    iret

%endif
