; =============================================================================
;
; x86/DOS Assembly Graphic mode example.
;
; =============================================================================
org 100h

%define VGA_320_200_MEMADDR 0a000h

; -----------------------------------------------
section .data
    loopColor db 0

; -----------------------------------------------
; Entry point:
section .text
    call gfxSetGraphicMode
    call cyclePixelTest
    call gfxSetTextMode
    jmp exitToDOS

; -----------------------------------------------
cyclePixelTest:
    ;call gfxWaitForVSync
    mov ax, 10  ; x
    mov bl, 10  ; y
    mov bh, [loopColor]  ; color
    call gfxSetPixelValue
    mov al, [loopColor]
    inc al
    mov [loopColor], al
    call keybIsKey
    jz cyclePixelTest
    ret

; -----------------------------------------------
keybIsKey:
    mov ax, 0100h
    int 16h
    ret

; -----------------------------------------------
exitToDOS:
    mov ah, 4Ch
    xor al, al
    int 21h

; -----------------------------------------------
; Set graphic mode: 320x200 pixels 256 colours.
gfxSetGraphicMode:
    mov ax, 13h
    int 10h
    ret

; -----------------------------------------------
; Set text mode: 80x25 chars.
gfxSetTextMode:
    mov ax, 07h
    int 10h
    ret

; -----------------------------------------------
; Set a pixel value.
;   ax = x position
;   bl = y position
;   bh = palette index
gfxSetPixelValue:
    mov cx, 320
    mul cx
    mov cl, bh
    xor bh, bh
    add ax, bx
    mov di, ax
    mov bx, VGA_320_200_MEMADDR
    mov es, bx
    mov [es:di] ,cl
    ret
