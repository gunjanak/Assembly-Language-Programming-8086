DATA SEGMENT
    MSG DB 'computer science$'    ; String to be converted (must end with '$')
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA

START:
    ; Initialize Data Segment
    MOV AX, DATA
    MOV DS, AX

    ; Load the effective address of the string into SI
    LEA SI, MSG

CONVERT_LOOP:
    ; Load character from [SI] into AL
    MOV AL, [SI]

    ; Check if we have reached the string terminator ('$')
    CMP AL, '$'
    JE DISPLAY_STRING

    ; Check if the character is lowercase ('a' to 'z')
    CMP AL, 'a'
    JB NEXT_CHAR
    CMP AL, 'z'
    JA NEXT_CHAR

    ; Convert lowercase to uppercase by subtracting 20H (32 in decimal)
    SUB AL, 32
    MOV [SI], AL

NEXT_CHAR:
    ; Move to the next character in the string
    INC SI
    JMP CONVERT_LOOP

DISPLAY_STRING:
    ; Print the converted string using DOS Interrupt 21h (Function 09h)
    LEA DX, MSG
    MOV AH, 09H
    INT 21H

    ; Exit program to DOS using Interrupt 21h (Function 4Ch)
    MOV AH, 4CH
    INT 21H

CODE ENDS
END START
