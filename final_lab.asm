.MODEL SMALL
.STACK 100H
.DATA
    p      DB 'TYPE A Binary Number: $'
    ILLEGAL_MSG DB 0DH,0AH,'ILLEGAL DIGIT, TRY AGAIN: $'
    REV_MSG     DB 0DH,0AH,'Reverse BINARY IT IS $'
    MOD_MSG     DB 0DH,0AH,'after changing odd number of bit set 1 there: $'
    RESULT_MSG  DB 0DH,0AH,'The resultant number is: $'
    EVEN_MSG    DB 'even$'
    ODD_MSG     DB 'odd$'
    INPUT_BUF   DB 17        ; Buffer size (16 chars + Enter)
                DB 0         ; Characters read
                DB 17 DUP(0) ; Actual buffer
    BIN_NUM     DW 0
    REV_NUM     DW 0
    MASK        DW 0AAAAH    ; Mask for odd bits (1010101010101010)

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

MAIN:
    ; Show initial p
    MOV AH, 09H
    LEA DX, p
    INT 21H

READ_INPUT:
    ; Read input with DOS function 0Ah
    MOV AH, 0AH
    LEA DX, INPUT_BUF
    INT 21H

    ; Validate input and count binary digits
    MOV SI, OFFSET INPUT_BUF + 2  ; Start of input
    MOV CX, 0                     ; Valid digit counter
    MOV DI, 0                     ; Position counter

VALIDATE_LOOP:
    MOV AL, [SI]
    INC SI
    CMP AL, 0DH                   ; Check for Enter key
    JE END_VALIDATION
    
    CMP AL, ' '
    JE SKIP_SPACE                 ; Ignore spaces
    
    CMP AL, '0'
    JB INVALID_INPUT
    CMP AL, '1'
    JA INVALID_INPUT
    
    INC CX                        ; Count valid binary digits
SKIP_SPACE:
    INC DI
    CMP DI, 16                    ; Max 16 positions
    JBE VALIDATE_LOOP

END_VALIDATION:
    CMP CX, 16                    ; Must have exactly 16 binary digits
    JNE INVALID_INPUT

    ; Convert to binary number
    MOV SI, OFFSET INPUT_BUF + 2
    MOV BX, 0                     ; Result storage
    MOV CX, 16

CONVERT_LOOP:
    MOV AL, [SI]
    INC SI
    CMP AL, ' '
    JE CONVERT_LOOP               ; Skip spaces
    
    SHL BX, 1                     ; Make space for new bit
    CMP AL, '1'
    JNE NEXT_BIT
    OR BL, 1                      ; Set bit if '1'
NEXT_BIT:
    LOOP CONVERT_LOOP
    MOV BIN_NUM, BX

    ; Reverse bits (16-bit reversal)
    MOV CX, 16
    MOV AX, BIN_NUM
    MOV DX, 0

REVERSE_LOOP:
    SHR AX, 1                     ; Get bit from LSB
    RCL DX, 1                     ; Push bit into result
    LOOP REVERSE_LOOP
    MOV REV_NUM, DX

    ; Print reversed binary
    MOV AH, 09H
    LEA DX, REV_MSG
    INT 21H
    MOV BX, REV_NUM
    CALL PRINT_BINARY

    ; Apply odd position mask
    MOV AX, REV_NUM
    OR AX, MASK                   ; Set odd bits to 1
    MOV REV_NUM, AX

    ; Print modified binary
    MOV AH, 09H
    LEA DX, MOD_MSG
    INT 21H
    MOV BX, REV_NUM
    CALL PRINT_BINARY

    ; Check even/odd
    MOV AH, 09H
    LEA DX, RESULT_MSG
    INT 21H
    TEST REV_NUM, 1               ; Check LSB
    JZ IS_EVEN
    
    LEA DX, ODD_MSG
    JMP PRINT_RESULT

IS_EVEN:
    LEA DX, EVEN_MSG

PRINT_RESULT:
    INT 21H
    JMP EXIT

INVALID_INPUT:
    MOV AH, 09H
    LEA DX, ILLEGAL_MSG
    INT 21H
    JMP MAIN                      ; Show main p again

; Procedure to print 16-bit binary from BX
PRINT_BINARY PROC
    MOV CX, 16                    ; 16 bits to print
PRINT_LOOP:
    ROL BX, 1                     ; Rotate MSB to CF
    JC PRINT_ONE
    MOV DL, '0'
    JMP PRINT_CHAR
PRINT_ONE:
    MOV DL, '1'
PRINT_CHAR:
    MOV AH, 02H
    INT 21H
    LOOP PRINT_LOOP
    RET
PRINT_BINARY ENDP

EXIT:
    MOV AH, 4CH
    INT 21H
END START