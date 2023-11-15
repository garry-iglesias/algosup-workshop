; =============================================================================
;
; x86/DOS Assembly File I/O example.
;
; =============================================================================
org 100h

%define BUFFER_SIZE 1000h

section .data
    fileName db 'file.txt' ,0

section .bss
    fileHandle resw 1
    inputBuffer resb (BUFFER_SIZE + 1)
    inputBufferByteCount resw 1

section .text
	xor ax ,ax
	mov dx ,fileName
	call ioOpenFileHandle
	mov [fileHandle] ,ax    ; Keep file handle.

loopBuffer:
	mov bx ,[fileHandle]    ; Load file handle.
	mov cx ,BUFFER_SIZE     ; Read as much as we can.
    mov dx ,inputBuffer     ; ds:dx -> target buffer.
	call ioReadFileHandle   ; Load buffer... ( ax <- number of byte red)
    mov [inputBufferByteCount] ,ax

    ; output buffer:
    add ax ,dx              ; Calculate "end of buffer" address.
    mov bx ,ax              ; "Effective address" is restricted to some registers, bx is one of them.
	mov byte [bx] ,'$'      ; "Close" input buffer as a DOS printable string.

    ; Send input buffer to the 'terminal':
    mov ah, 9       ; DOS "print string" function.
    int 21h         ; Call the DOS interrupt 21h to execute the function

    ; Something else to read ?
    cmp word [inputBufferByteCount] ,BUFFER_SIZE
    je loopBuffer

    ; - Exit to DOS:
    mov ah, 4ch
    xor al, al
    int 21h

; -----------------------------------------------
; Open a file:
;   ds:dx = asciz filename
;   al = access mode - 0 RO / 1 WO / 2 RW
;   CF -> Failed
;       ax = error code
;   NCF -> Success
;       ax = file handle
ioOpenFileHandle:
    mov ax, 3d00h
    int 21h
    ret

; -----------------------------------------------
; Close an opened file:
;   bx = file handle
;   CF -> Failed
;       ax = error code
ioCloseFileHandle:
    mov ax, 3e00h
    int 21h
    ret

; -----------------------------------------------
; Read from an opened file:
;   bx = file handle
;   cx = size to read in bytes
;   ds:dx = target read address
;   CF -> Failed
;       ax = error code
;   NCF -> Success
;       ax = number of byte loaded
ioReadFileHandle:
    mov ax, 3f00h
    int 21h
    ret

