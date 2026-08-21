.model small
.stack 100h

.data
    array   dw 1234h, 5678h, 9ABCh, 3456h, 789Ah   ; Array of 16-bit numbers
    n       dw 5                                    ; Number of elements in the array
    largest dw ?                                    ; Variable to store the largest number

.code
main proc
    ; Initialize Data Segment
    mov ax, @data
    mov ds, ax

    ; Setup pointers and counters
    lea si, array           ; SI points to the start of the array
    mov cx, n               ; CX acts as the loop counter (number of elements)
    
    mov ax, [si]            ; Assume the first element is the largest
    add si, 2               ; Move SI to the next 16-bit element (2 bytes)
    dec cx                  ; Decrease counter since first element is already processed

find_largest:
    JCXZ done               ; If CX becomes 0, loop is finished
    
    mov dx, [si]            ; Load the current array element into DX
    cmp dx, ax              ; Compare current element with current largest (AX)
    jle not_larger          ; If DX <= AX, skip updating
    
    mov ax, dx              ; If DX > AX, update AX to be the new largest

not_larger:
    add si, 2               ; Move to the next 16-bit number in the array
    loop find_largest       ; Decrement CX and repeat if not zero

done:
    mov largest, ax         ; Store the final largest number in memory

    ; Exit program
    mov ah, 4ch
    int 21h
main endp
end main
