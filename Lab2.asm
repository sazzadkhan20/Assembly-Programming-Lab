.MODEL SMALL
.STACK 100H

.DATA
MSG1 DB "TYPE A CHARACTER: $"
MSG2 DB 0AH,0DH, "THE ASCII CODE OF ", 0
MSG3 DB " IN BINARY IS $"
MSG4 DB 0AH,0DH, "THE NUMBER OF 1 BITS IS $"
BINARY DB 8 DUP(?)      ; To store 8 binary digits (as ASCII)
BITCOUNT DB 0           ; Counter for number of 1s

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Show prompt
    MOV AH, 9
    LEA DX, MSG1
    INT 21H

    ; Read character input
    MOV AH, 1
    INT 21H          ; AL = input character
    MOV BL, AL       ; Store character in BL
    MOV BH, AL       ; Also in BH for later

    ; Show "THE ASCII CODE OF "
    MOV AH, 9
    LEA DX, MSG2
    INT 21H

    ; Print the character
    MOV DL, BL
    MOV AH, 2
    INT 21H

    ; Show " IN BINARY IS"
    MOV AH, 9
    LEA DX, MSG3
    INT 21H

    ; Convert to binary and count 1s
    MOV CL, 8           ; 8 bits
    LEA DI, BINARY
    XOR CH, CH          ; Zero BITCOUNT

BINARY_LOOP:
    MOV AL, BH
    AND AL, 80H         ; Mask highest bit
    JZ STORE_ZERO
    MOV BYTE PTR [DI], '1'
    INC BITCOUNT
    JMP NEXT_BIT

STORE_ZERO:
    MOV BYTE PTR [DI], '0'

NEXT_BIT:
    SHL BH, 1           ; Shift left
    INC DI
    DEC CL
    JNZ BINARY_LOOP

    ; Print binary string
    LEA SI, BINARY
    MOV CX, 8
PRINT_BIN:
    MOV DL, [SI]
    MOV AH, 2
    INT 21H
    INC SI
    LOOP PRINT_BIN

    ; Show newline and "THE NUMBER OF 1 BITS IS"
    MOV AH, 9
    LEA DX, MSG4
    INT 21H

    ; Convert BITCOUNT (0-8) to ASCII and print
    MOV AL, BITCOUNT
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 2
    INT 21H

    ; Exit
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END
