.MODEL SMALL
.STACK 100H

.DATA
MSG1 DB "TYPE A CHARACTER: $"
MSG2 DB 0DH,0AH,"THE ASCII CODE OF ", 0
MSG3 DB " IN HEX IS $"
HEX  DB 2 DUP(?) ; To hold the two-digit hex string

.CODE
MAIN:                   ; ? Use label MAIN instead of PROC/ENDP

    MOV AX, @DATA
    MOV DS, AX

START:
    ; Print prompt
    MOV AH, 9
    LEA DX, MSG1
    INT 21H

    ; Input character
    MOV AH, 1
    INT 21H       ; AL = character input
    CMP AL, 13    ; Check for ENTER (carriage return)
    JE EXIT

    MOV BL, AL    ; Save input character in BL

    ; Print newline + MSG2
    MOV AH, 9
    LEA DX, MSG2
    INT 21H

    ; Print the character itself
    MOV DL, BL
    MOV AH, 2
    INT 21H

    ; Print MSG3
    MOV AH, 9
    LEA DX, MSG3
    INT 21H

    ; Convert character to hex
    MOV AL, BL     ; character ASCII code in AL
    MOV AH, 0

    ; High nibble
    MOV CL, AL
    SHR CL, 4
    CALL NIBBLE_TO_HEX
    MOV HEX[0], DL

    ; Low nibble
    MOV CL, AL
    AND CL, 0FH
    CALL NIBBLE_TO_HEX
    MOV HEX[1], DL

    ; Print both hex digits
    MOV AH, 2
    MOV DL, HEX[0]
    INT 21H
    MOV DL, HEX[1]
    INT 21H

    ; Newline
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    MOV DL, 0DH
    INT 21H

    JMP START

EXIT:
    MOV AH, 4CH
    INT 21H

; ===== Helper to convert nibble (0–15) to ASCII hex =====
NIBBLE_TO_HEX PROC
    CMP CL, 9
    JG ALPHA
    ADD CL, '0'
    JMP DONE
ALPHA:
    ADD CL, 'A' - 10
DONE:
    MOV DL, CL
    RET
NIBBLE_TO_HEX ENDP

END MAIN  ; ? Must match the MAIN label
