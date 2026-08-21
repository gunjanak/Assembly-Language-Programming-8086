DATA SEGMENT
    ; Input buffer format for INT 21h / AH=0Ah:
    ; Byte 0: Max buffer size, Byte 1: Actual chars read, Bytes 2+: Characters
    BUF1    DB 50, ?, 50 DUP(0)
    BUF2    DB 50, ?, 50 DUP(0)
    
    PROMPT1 DB 'Enter first string: $'
    PROMPT2 DB 13, 10, 'Enter second string: $'
    MSG_EQ  DB 13, 10, 'Strings are equal$'
    MSG_NEQ DB 13, 10, 'Strings are not equal$'
DATA ENDS

STACK SEGMENT PARA STACK 'STACK'
    DW 64 DUP(?)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK

START:
    ; Initialize Data Segment
    MOV AX, DATA
    MOV DS, AX

    ; --- Prompt and Read String 1 ---
    LEA DX, PROMPT1
    MOV AH, 09H
    INT 21H

    LEA DX, BUF1
    MOV AH, 0AH
    INT 21H

    ; --- Prompt and Read String 2 ---
    LEA DX, PROMPT2
    MOV AH, 09H
    INT 21H

    LEA DX, BUF2
    MOV AH, 0AH
    INT 21H

    ; --- Compare Lengths ---
    MOV SI, OFFSET BUF1
    MOV AL, [SI+1]          ; Get actual length of string 1
    MOV DI, OFFSET BUF2
    MOV BL, [DI+1]          ; Get actual length of string 2

    CMP AL, BL
    JNE NOT_EQUAL           ; If lengths differ, strings are not equal

    ; --- Compare Content Character by Character ---
    MOV CX, 0
    MOV CL, AL              ; Set loop counter to string length
    JCXZ STRINGS_EQUAL      ; If length is 0, they are equal

    ADD SI, 2               ; Point SI to start of actual string 1 text
    ADD DI, 2               ; Point DI to start of actual string 2 text

COMPARE_LOOP:
    MOV AL, [SI]
    MOV DL, [DI]
    CMP AL, DL
    JNE NOT_EQUAL
    INC SI
    INC DI
    DEC CX
    JNZ COMPARE_LOOP

STRINGS_EQUAL:
    LEA DX, MSG_EQ
    MOV AH, 09H
    INT 21H
    JMP EXIT_PROG

NOT_EQUAL:
    LEA DX, MSG_NEQ
    MOV AH, 09H
    INT 21H

EXIT_PROG:
    ; Exit to DOS
    MOV AH, 4CH
    INT 21H

CODE ENDS
END START
