.stack 100h
.code
main proc
    mov ax,5h
    mov bx,6h
    
    push ax
    push bx
    
    pop ax
    pop bx