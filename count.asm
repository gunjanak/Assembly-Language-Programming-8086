DATA SEGMENT
    MSG DB 'Microprocessor organization$' ; Input string ending with '$'
    MSG_LEN EQU $ - MSG - 1             ; Calculate length excluding '$'
    COUNT DB 0                          ; Variable to store the count of 'o'
DATA ENDS

STACK SEGMENT PARA STACK 'STACK'
    DW 64 DUP(?)                        ; Defined stack segment
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK

START:
    ; Initialize Data Segment
    MOV AX, DATA
    MOV DS, AX

    ; Initialize pointers and counters
    LEA SI, MSG                         ; SI points to the start of the string
    XOR CX, CX                          ; Clear CX
    MOV CL, MSG_LEN                     ; Load string length into CL
    XOR BL, BL                          ; BL will act as our 'o' counter

COUNT_LOOP:
    MOV AL, [SI]                        ; Load current character into AL

    ; Check for lowercase 'o'
    CMP AL, 'o'
    JE INCREMENT_COUNT
    
    ; Check for uppercase 'O' (just in case)
    CMP AL, 'O'
    JE INCREMENT_COUNT
    JMP NEXT_CHAR

INCREMENT_COUNT:
    INC BL                              ; Increment occurrence counter

NEXT_CHAR:
    INC SI                              ; Move to the next character
    DEC CX                              ; Decrement loop counter
    JNZ COUNT_LOOP                      ; Repeat until CX is 0

    ; Store the final count
    MOV COUNT, BL

    ; --- Display the result ---
    ; Convert the numeric count in BL to its ASCII character representation
    MOV AL, COUNT
    ADD AL, 30H                         ; Convert to ASCII ('0' to '9')
    MOV DL, AL                          ; Move character to DL for output

    ; Use DOS Interrupt 21h (Function 02h) to display a single character
    MOV AH, 02H
    INT 21H

    ; Exit program to DOS using Interrupt 21h (Function 4Ch)
    MOV AH, 4CH
    INT 21H

CODE ENDS
END START
