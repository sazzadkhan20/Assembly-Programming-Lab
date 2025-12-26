.MODEL SMALL
.STACK 100H
.DATA 
MSG1 DB "ENTER A CHARACTER: $"
MSG2 DB 0AH,0DH, "CONVERTED CHARACTER: $"
.CONVERTED DB "CONVERTED$"
.CODE
MAIN PROC  
    ; Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX
    
    ; Print the message asking for the character input
    MOV AH, 9
    LEA DX, MSG1
    INT 21H  
    
    ; Taking the input character from user
    MOV AH, 1
    INT 21H
    MOV BL, AL  ; Store input character in BL
    
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    
    ; Check if the character is a letter and convert it
    ; Using AND/OR to convert case with mask

    MOV AL, BL  ; Copy the input character to AL
    
    ; Check if the character is uppercase (A-Z)
    CMP AL, 'A'
    JL NotLetter  ; If it's less than 'A', it's not a letter
    CMP AL, 'Z'
    JG NotLetter  ; If it's greater than 'Z', it's not a letter

    ; Convert uppercase to lowercase by ORing with binary mask 00100000
    OR AL, 00100000B    ; This will convert uppercase to lowercase (A-Z -> a-z)
    JMP PrintConverted

NotLetter:
    ; Check if the character is lowercase (a-z)
    CMP BL, 'a' 
    JL EndProgram
    CMP BL, 'z'
    JG EndProgram
    
    ; Convert lowercase to uppercase by ANDing with binary mask 11011111
    AND AL, 11011111B   ; This will convert lowercase to uppercase (a-z -> A-Z)
             
    
PrintConverted:  
    ; Display the converted character
    MOV AH, 2      ; Use AH = 2 for printing a single character
    MOV DL, AL     ; Move the converted character into DL
    INT 21H        ; Print the character
    
EndProgram:
    ; Exit the program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END
