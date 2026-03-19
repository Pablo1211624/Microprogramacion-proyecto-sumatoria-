.model small
.data
    A DB 1
    I DB 1
    B DB ?
    TOTAL DB 0
    ERRORESTRUCURA DB 'Error en la estructura de los paréntesis$'
.stack 
.code

programa:
; Leer el valor de A

LeerA:

    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H ; Función para leer un carácter
    INT 21H ; Interrupción para leer el carácter

    CMP AL, '9' ; Comparar con '9'
    JG  LeerA ; Si es mayor que '9', volver al inicio del programa
    CMP AL, '0' ; Comparar con '0'
    JL validar_parentesis
    MOV A, AL 
    JMP LeerParentesis ; Continuar con la lectura de los paréntesis

LeerParentesis:

    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H  
    INT 21H

    CMP AL, '(' ; Comparar con '('
    JE LeerI
    CMP AL, ')' ; Comparar con ')'
    JE SUMATORIAJMP
    JMP ErrorEstructura
    
LeerI:
    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H
    INT 21H

    CMP AL, '+' ; Comparar con '+'
    JE SUMAJMP
    CMP AL, '-' ; Comparar con '-'
    JE RESTAJMP
    CMP AL, '*' ; Comparar con '*'
    JE MULTIPLICACIONJMP
    CMP AL, '/' ; Comparar con '/'
    JE DIVISIONJMP
    CMP AL, 'm' ; Comparar con 'm'
    JE MODJMP
    JMP ErrorEstructura

SUMAJMP:
    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H
    INT 21H

    CMP AL, '9' ; Comparar con '9'
    JG  ErrorEstructura ; Si es mayor que '9', volver al inicio del programa
    CMP AL, '0' ; Comparar con '0'
    JL ErrorEstructura
    MOV B, AL 
    xor BL, BL ; Limpiar el registro BL
    MOV BL, I
    ADD BL, B
    MOV I, BL ; ahora el resultado de la suma es la cantidad que va a avanzar
    JMP LeerParentesis


RESTAJMP:
    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H
    INT 21H

    CMP AL, '9' ; Comparar con '9'
    JG  ErrorEstructura ; Si es mayor que '9', volver al inicio del programa
    CMP AL, '0' ; Comparar con '0'
    JL ErrorEstructura
    MOV B, AL
    XOR BL, BL ; Limpiar el registro BL
    MOV BL, I
    SUB BL, B
    MOV I, BL ; ahora el resultado de la resta es la cantidad que va a avanzar
    JMP LeerParentesis

MULTIPLICACIONJMP:
    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H
    INT 21H
    
    CMP AL, '9' ; Comparar con '9'
    JG  ErrorEstructura ; Si es mayor que '9', volver al inicio
    CMP AL, '0' ; Comparar con '0'
    JL ErrorEstructura
    MOV B, AL
    XOR BL, BL ; Limpiar el registro BL
    MOV BL, I
    MUL BL
    MOV I, AL ; ahora el resultado de la multiplicación es la cantidad que va a avanzar
    JMP LeerParentesis

DIVISIONJMP:
    xor AX, AX ; Limpiar el registro AX
    MOV AH, 1H
    INT 21H

    CMP AL, '9' ; Comparar con '9'
    JG  ErrorEstructura ; Si es mayor que '9', volver al inicio
    CMP AL, '0' ; Comparar con '0'
    JL ErrorEstructura
    MOV B, AL ; Guardar el valor de B
    XOR BL, BL ; Limpiar el registro BL
    MOV BL, I
    DIV BL
    MOV I, AL ; ahora el cociente es la cantidad que va a avanzar
    JMP LeerParentesis

MODJMP:
    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H
    INT 21H

    CMP AL, 'o' ; Comparar con 'o'
    JE OJMP
    OJMP:
        XOR AX, AX ; Limpiar el registro AX
        MOV AH, 1H
        INT 21H

        CMP AL, 'd' ; Comparar con 'd'
        JE MODOPERACION
        MODOPERACION:
            XOR AX, AX ; Limpiar el registro AX
            MOV AH, 1H
            INT 21H

            MOV B, AL ; Guardar el valor de B
            XOR BL, BL ; Limpiar el registro BL
            MOV BL, I

            DIV BL
            MOV I, AH ; ahora el cociente es la cantida que va a avanzar    
    JMP ErrorEstructura

LeerSimbolo:

    XOR AX, AX ; Limpiar el registro AX
LeerB:

validar_parentesis:
    CMP AL, '(' ; Comparar con '('
    JE LeerI
    JMP ErrorEstructura
   
ErrorEstructura:
    MOV DX, OFFSET ERRORESTRUCURA
    MOV AH, 9H ; Función para mostrar un mensaje
    INT 21H ; Interrupción para mostrar el mensaje
    JMP programa ; Volver al inicio del programa

END programa
