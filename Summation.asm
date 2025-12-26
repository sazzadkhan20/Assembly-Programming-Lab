.Model Small
.Stack 100H
.Data
    msg1 DB "?$" 
    msg2 DB "THE SUM OF $" 
    msg3 DB " AND $" 
    msg4 DB " IS $" 

.Code
Main Proc
    Mov AX,@Data
    Mov DS,AX
      
    ; Display ?
    Mov AH,9
    LEA DX,msg1
    INT 21H   

    ; Read first digit
    Mov AH,1
    INT 21H  
    SUB AL, '0'    ; Convert ASCII to integer
    Mov BL,AL      ; Store first digit in BL 
    
    ; Read second digit
    Mov AH,1
    INT 21H  
    SUB AL, '0'    
    Mov BH,AL       
    
    ; New Line
    Mov AH,2
    Mov DL,0DH  ; Carriage return
    INT 21H 
    Mov DL,0AH  ; Line feed
    INT 21H  

    ; Display "THE SUM OF "
    Mov AH,9
    LEA DX,msg2
    INT 21H      

    ; Display first digit
    Mov AH,2
    Mov DL, BL
    ADD DL, '0'  ; Convert integer to ASCII
    INT 21H  

    ; Display " AND "
    Mov AH,9
    LEA DX,msg3
    INT 21H  

    ; Display second digit
    Mov AH,2
    Mov DL, BH
    ADD DL, '0'  ; Convert integer to ASCII
    INT 21H  

    ; Display " IS "
    Mov AH,9
    LEA DX,msg4
    INT 21H  

    ; Calculate sum
    ADD BL, BH  ; Sum = BL + BH

    ; Display sum
    Mov AH,2
    Mov DL, BL
    ADD DL, '0'  ; Convert sum to ASCII
    INT 21H  

    ; Exit program
    Mov AH,4CH
    INT 21H

Main Endp
End Main
