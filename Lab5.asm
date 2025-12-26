.model small
.stack 100h
.data
.code
main:
    ; Initialize registers
    mov ax, 1234h    ; AX = 1234h
    mov bx, 5678h    ; BX = 5678h
    mov cx, 9ABCh    ; CX = 9ABCh
    mov sp, 0100h    ; SP = 0100h (initial stack pointer)

    ; Instruction sequence
    push ax          ; Push AX onto stack -> SP = 00FEh
    push bx          ; Push BX onto stack -> SP = 00FCh
    xchg ax, cx      ; Swap AX and CX -> AX = 9ABC, CX = 1234
    pop cx           ; Pop top of stack (was BX) into CX -> CX = 5678, SP = 00FEh
    push ax          ; Push AX onto stack -> SP = 00FCh
    pop bx           ; Pop top of stack into BX -> BX = 9ABC, SP = 00FEh

    ; Done. Final values are:
    ; AX = 9ABCh
    ; BX = 9ABCh
    ; CX = 5678h
    ; SP = 00FEh

    ; End the program
    mov ah, 4Ch
    int 21h
end main
