.Model Small
.Stack 100H

.Data
    msg1 DB "ENTER A HEX DIGIT: $"
    msg2 DB 0AH,0DH,"IN DECIMAL IT IS $"
    msg3 DB 0AH,0DH,"NO ANSWER$"

.Code
Main Proc
    ; Initialize Data Segment
    MOV AX, @Data
    MOV DS, AX

    ; Display input prompt
    MOV AH, 9
    LEA DX, msg1
    INT 21H

    ; Read a single character (hex digit)
    MOV AH, 1
    INT 21H        ; Input stored in AL
    MOV BL, AL     ; Keep a copy in BL

    ; Check if input is A-F
    CMP BL, 'A'
    JL INVALID      
    CMP BL, 'F'
    JG INVALID     

    ; Convert A-F to 10-15
    SUB BL, 'A'    ; 
    ADD BL, 10     ; 

    ; Display result message
    MOV AH, 9
    LEA DX, msg2
    INT 21H

    ; Display '1' (tens digit)
    MOV DL, '1'
    MOV AH, 2
    INT 21H

    ; Calculate and display units digit (0-5)
    MOV AL, BL
    SUB AL, 10      
    ADD AL, '0'   
    MOV DL, AL
    MOV AH, 2
    INT 21H

    JMP EXIT

INVALID:
    ; Display "NO ANSWER" for invalid input
    MOV AH, 9
    LEA DX, msg3
    INT 21H

EXIT:
    ; Terminate program
    MOV AH, 4CH
    INT 21H
Main Endp
End