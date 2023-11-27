; =============================================================================
;
;   String helpers:
;
; =============================================================================

%ifndef STRINGS
%define STRINGS

; =====================================
;   String functions:
; =====================================
section .text

; -----------------------------------------------
;   ds:si = Source string.
; Returns
;   cx = string length
stringLen:
    xor cx ,cx
    lodsb
    cmp al ,0
    jz .done
    inc cx
    jmp stringLen
.done:
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
printNextLine:
    mov si ,dosEOL
    jmp printAsciiZ

; -----------------------------------------------
printCarriageReturn:
    mov dl, `\r`
    mov ax ,0600h
    int 21h
    jmp printAsciiZ

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
; Generate a decimal string from unsigned word
;   ax = number to convert
;   es:di = target string
stringUWordToDecimal:
    and eax ,0ffffh
    jmp stringUDWordToDecimal

; -----------------------------------------------
; Generate a decimal string from unsigned double word
;   eax = number to convert
;   es:di = target string
stringUDWordToDecimal:
    cmp eax, 0               ; Zero value is just... zero.
    jz .zeroValue
    mov ebx ,1000000000      ; Start with bilions
.decLead:
    xor edx ,edx
    div ebx                 ; Check this digit.
    cmp eax ,0              ; Zero lead ?
    jnz .digitLoop          ; Nope -> go to digit writing loop.
    mov ecx ,edx            ; Keep input value (was in remainder)
    mov eax ,ebx            ; Divide by 10
    xor edx ,edx
    div dword [.tenConst]
    mov ebx ,eax
    mov eax, ecx            ; Next (leading) digit.
    jmp .decLead

.digitLoop:                 ; => eax = quot / edx = remainder
    add al, '0'             ; Emit digit
    stosb
    mov ecx ,edx              ; Next digit -> keep remainder.
    mov eax ,ebx              ; Divide by 10
    xor edx ,edx
    div dword [.tenConst]
    cmp eax, 0
    jz .endDecimal
    mov ebx ,eax
    mov eax ,ecx              ; Divide remainder.
    xor edx ,edx
    div ebx
    jmp .digitLoop

.zeroValue:
    mov al ,'0'
    stosb

.endDecimal:
    xor al ,al              ; Close string
    stosb
    ret

.tenConst dd 10

section .data
    dosEOL db `\r\n`, 0
    carriageReturn db `\r` ,0

%endif
