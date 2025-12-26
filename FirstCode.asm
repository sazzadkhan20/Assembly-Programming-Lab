.Model Small ; Model Type
.Stack 100H  ; Stack Address
.Data        ; Data Segment
A DB "Hello ! $"  ; DB - Define Byte variable Declare

.Code        ; Code Segment
MAIN PROC    ; Procedure Start

 Mov AX,@Data ; Access to the data Segment
 Mov DS,AX
 
 MOV AH,9 ; 9 For String output
 LEA DX,A ; LEA = Load Effective Address
 INT 21H ; For Black Screen output
 
 MOV AH,4CH ; Ending Message
 INT 21H    ; Message Window
 
 MAIN ENDP  ; Procedure End

 END        ; Code End

