; =============================================================================
;
; x86/DOS Assembly Memory Watcher example.
;
; =============================================================================
org 100h

section .text
    mov ax ,cs
    mov [currentSeg] ,ax
.watchLoop:
    ; Display dump line:
    mov bx ,[currentSeg]
    call .dumpLine
.inputLoop:
    call keybReadKey
    cmp al ,27  ; Escape ??
    je .stopWatch
    cmp al ,'w'
    je .moveUp
    cmp al ,'s'
    je .moveDn
    jmp .inputLoop
.moveUp:
    sub word [currentSeg] ,1
    jmp .watchLoop
.moveDn:
    add word [currentSeg] ,1
    jmp .watchLoop
.stopWatch:
    ; - Exit to DOS:
    mov ah, 4ch
    xor al, al
    int 21h

; bx = segment to dump.
.dumpLine:
    push bx
    mov ax ,bx
    lea di ,[printBuffer]
    call stringUWordToHexa
    lea si ,[printBuffer]
    call printAsciiZ
    mov si ,dumpLineColon
    call printAsciiZ
    mov word [byteIndex], 0
.eachByte:
    call printSpace
    mov bx ,sp
    mov ax ,word [bx]
    push ds
    mov ds, ax
    mov si, cs:[byteIndex]
    lodsb
    mov cs:[byteIndex], si
    pop ds
    lea di ,[printBuffer]
    call stringUByteToHexa
    lea si ,[printBuffer]
    call printAsciiZ
    cmp word [byteIndex] ,16
    jb .eachByte
    pop bx
    call printCarriageReturn
    ret

; -----------------------------------------------
section .bss
    currentSeg resw 1
    printBuffer resb 16
    byteIndex resw 1

; -----------------------------------------------
section .data
    dumpLineColon db `: ` ,0

; -----------------------------------------------
section .text

; -----------------------------------------------
; Read a key from keyboard input buffer.
;   ah = scan code
;   al = character
keybReadKey:
    xor ax, ax
    int 16h
    ret

; -----------------------------------------------
; Generate an hexa string from unsigned byte:
;   al = number to convert
;   es:di = target string
stringUByteToHexa:
    mov cx, 2
    jmp stringUnsignedToHexa

; -----------------------------------------------
; Generate an hexa string from unsigned word:
;   ax = number to convert
;   es:di = target string
stringUWordToHexa:
    mov cx, 4
    jmp stringUnsignedToHexa

; -----------------------------------------------
; Generate an hexa string from unsigned byte:
;   eax = number to convert
;   cx = number of hexadigit (lowest).
;   es:di = target string
stringUnsignedToHexa:
    mov ebx ,eax
    shl cx ,2
.hexaDigitLoop:
    sub cx ,4
    shr eax, cl
    and al, 15
    cmp al, 10
    jae .hexaLetter
    add al, '0'
    jmp .hexaFlush
.hexaLetter:
    add al, ('a' - 10)
.hexaFlush:
    stosb
    cmp cx ,0
    je .hexaEnd
    mov eax ,ebx
    jmp .hexaDigitLoop
.hexaEnd:
    xor al ,al
    stosb
    ret

; -----------------------------------------------
;   ds:si = Source string.
printAsciiZ:
    lodsb
    cmp al ,0
    jz .endPrint
    mov dl ,al
    mov ax ,0600h
    int 21h
    jmp printAsciiZ
.endPrint:
    ret

; -----------------------------------------------
printSpace:
    mov dl, ' '
    mov ax ,0600h
    int 21h
    ret

; -----------------------------------------------
printCarriageReturn:
    mov dl, 0dh
    mov ax ,0600h
    int 21h
    ret
