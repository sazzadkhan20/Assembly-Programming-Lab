.MODEL SMALL
.STACK 100H
.DATA
    msg1 DB "Enter a number: $"   
    msg2 DB 0DH, 0AH, "Positive$"
    msg3 DB 0DH, 0AH, "Negative$"
    newline DB 0DH, 0AH, "$"  ; New line

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Display "Enter a number: "
    MOV AH, 9
    LEA DX, msg1
    INT 21H

    ; Read first character (check for negative sign)
    MOV AH, 1
    INT 21H  
    MOV BL, AL   ; Store first character in BL

    CMP BL, 2DH  ; Compare with '-' (ASCII 2DH)
    JE NEGATIVE_INPUT  ; If '-', go to NEGATIVE_INPUT

    ; If first input is not '-', treat it as part of a positive number
    SUB BL, '0'  ; Convert ASCII to integer
    JMP READ_DIGITS

NEGATIVE_INPUT:
    ; Read next digit
    MOV AH, 1
    INT 21H  
    SUB AL, '0'   ; Convert ASCII to integer
    MOV BL, AL    ; Store in BL
    JMP NEGATIVE  ; Jump to negative check

READ_DIGITS:
    ; Read additional digits (not needed for single-digit numbers)
    ; For simplicity, assume single-digit numbers only for now
    JMP POSITIVE

POSITIVE:
    MOV AH, 9
    LEA DX, msg2
    INT 21H
    JMP EXIT

NEGATIVE:
    MOV AH, 9
    LEA DX, msg3
    INT 21H

EXIT:
    ; Print new line
    MOV AH, 9
    LEA DX, newline
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
