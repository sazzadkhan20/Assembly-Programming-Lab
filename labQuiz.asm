.MODEL SMALL
.STACK 100H

.DATA
    PROMPT    DB 'Input a character: $'
    NEWLINE   DB 0DH, 0AH, '$'   ; Carriage return + line feed
    VALID_MSG DB 'Valid: $'      ; Valid message
    INVALID   DB 'Invalid$'      ; Invalid message

.CODE
MAIN PROC
    ; Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display input prompt
    MOV AH, 09H
    LEA DX, PROMPT
    INT 21H

    ; Read a character (stored in AL)
    MOV AH, 01H
    INT 21H
    MOV BL, AL      ; Store in BL (preserve while we print messages)

    ; Print newline after input
    MOV AH, 09H
    LEA DX, NEWLINE
    INT 21H

    ; Check if BL >= 'A' AND BL <= 'Z'
    CMP BL, 'A'
    JL  NOT_VALID   ; Jump if BL < 'A'
    CMP BL, 'Z'
    JG  NOT_VALID   ; Jump if BL > 'Z'

    ; -- VALID CHARACTER PROCESSING --
    ; Print "Valid: " prefix
    MOV AH, 09H
    LEA DX, VALID_MSG
    INT 21H

    ; Print the actual character
    MOV AH, 02H
    MOV DL, BL
    INT 21H

    JMP EXIT

NOT_VALID:
    ; Print "Invalid" message
    MOV AH, 09H
    LEA DX, INVALID
    INT 21H

EXIT:
    ; Terminate program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN