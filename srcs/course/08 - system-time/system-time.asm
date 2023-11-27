; =============================================================================
;
; x86/DOS Assembly System Time example.
;
; =============================================================================
org 100h

section .bss
    timeHours resb 1
    timeMinutes resb 1
    timeSeconds resb 1
    printBuffer resb 4

section .text
timeLoop:
    call printCarriageReturn

    ; Read system time.
    mov ah ,02h
    int 1ah

    ; Keep time around:
    mov [timeHours] ,ch
    mov [timeMinutes] ,cl
    mov [timeSeconds] ,dh

    ; Display time:
    mov al ,[timeHours]
    mov di ,printBuffer
    call stringUByteToHexa
    mov si ,printBuffer
    call printAsciiZ
    call printColumn

    mov al ,[timeMinutes]
    mov di ,printBuffer
    call stringUByteToHexa
    mov si ,printBuffer
    call printAsciiZ
    call printColumn

    mov al ,[timeSeconds]
    mov di ,printBuffer
    call stringUByteToHexa
    mov si ,printBuffer
    call printAsciiZ

    ; Loop until key pressed:
    call keybIsKey
    jz timeLoop
    jmp sysExitProgram

; -----------------------------------------------
; Exit the program
sysExitProgram:
    mov ah, 4ch
    xor al, al
    int 21h

; -----------------------------------------------
printColumn:
    mov dl, ':'
    mov ax ,0600h
    int 21h
    ret

; -----------------------------------------------
printCarriageReturn:
    mov dl, `\r`
    mov ax ,0600h
    int 21h
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
;   ZF = 0 some key
;   ZF = 1 no key
keybIsKey:
    mov ax, 0100h
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
