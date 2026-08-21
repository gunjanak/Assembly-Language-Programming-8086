.model small
.stack 100h

.data
    num1 dw 1234h
    num2 dw 5678h

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ax, num1
    add ax, num2

    mov ah, 4ch
    int 21h
main endp
end main
