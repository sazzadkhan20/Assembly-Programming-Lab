.Model Small
.Stack 100H
.Data
A DB "Input a Value: $"

.Code
Main Proc
    Mov AX,@Data
    Mov DS,AX
    
    Mov AH,9  ; 9 - string output
    LEA DX,A  ; DX - 16 bit
    INT 21H
    
    Mov AH,1 ; Single Value Input
    INT 21H
    Mov BL,AL ; AL input accept and store BL register
    
    ;New Line
    Mov AH,2    ; 2 - single value output
    Mov DL,0AH  ; 0AH - newline ascii value 
    INT 21H   
    
    Mov AH,2
    Mov DL,0DH  ;  0DH - crett ascii value 
    INT 21H
    
    Mov AH,2
    Mov DL,BL
    INT 21H
    
    Mov AH,4CH
    INT 21H
    Main Endp
End




