.model small
.data
    A DB 1
    I DB 1
    B DB ?
    SIMBOLO DB ?
    TOTAL DW 0
    AXVAL DW 0
    ERRORESTRUCURA DB 'Error en la estructura de los paréntesis$'
.stack 
.code

programa:
;Iniciar el programa
    MOV AX, @data ; Cargar la dirección del segmento de datos en AX
    MOV DS, AX ; Establecer DS para acceder a las variables

    MOV A, 1 ; Inicializar A con un valor predeterminado

; Iniciar contador de A
    MOV CL, 3
; Leer el valor de A
LeerA:

    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H ; Función para leer un carácter
    INT 21H ; Interrupción para leer el carácter

    CMP AL, '9' ; Comparar con '9'
    JG  ErrorEstructura ; Si es mayor que '9', tirar excecpcion y reiniciar el programa
    CMP AL, '0' ; Comparar con '0'
    JL LeerParentesis  
    ;Restar el valor ASCII de '0' para obtener el valor numérico
    SUB AL, '0'
    ;Comparar contador para ver si hay que multiplicar
    CMP CL, 2
    JE Multiplicar10
    CMP CL, 1
    JE Multiplicar10 
    ;Ubicar el valor de A
    MOV A, AL
    LOOP LeerA ; Se puede leer a lo mucho 3 digitos para A
    JMP LeerParentesis

; Toma por hecho que el registro AL tiene el valor
Multiplicar10:
    MOV BL, 10
    MOV DL, AL 
    MOV AL, A
    MUL BL
    XOR A, A
    MOV A, AL
    ADD A, DL
    CMP A, 255 ; Verificar si el resultado excede el rango de un byte
    JG ErrorEstructura ; Si es mayor que 255, tirar excepción y reiniciar el programa
    LOOP LeerA
; Leer parentesis
LeerParentesis:
    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H  
    INT 21H

    CMP AL, '(' ; Comparar con '('
    JE LeerSimbolo
    CMP AL, ')' ; Comparar con ')'
    JE SUMATORIAJMP
    JMP ErrorEstructura

;Lee el simbolo de la operacion    
LeerSimbolo:
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
    MOV SIMBOLO, AL ; Guardar el símbolo de la operación
    JMP LEERB
RESTAJMP:
    MOV SIMBOLO, AL ; Guardar el símbolo de la operación
    JMP LEERB
MULTIPLICACIONJMP:
    MOV SIMBOLO, AL ; Guardar el símbolo de la operación
    JMP LEERB
DIVISIONJMP:
    MOV SIMBOLO, AL ; Guardar el símbolo de la operación
    JMP LEERB
; MODJMP:
;     MOV SIMBOLO, AL ; Guardar el símbolo de la operación

;Lee el numero despues de simbolo
LEERB:
    XOR AX, AX ; Limpiar el registro AX
    MOV AH, 1H
    INT 21H

    CMP AL, '9' ; Comparar con '9'
    JG  ErrorEstructura ; Si es mayor que '9', volver al inicio del programa
    CMP AL, '0' ; Comparar con '0'
    JL ErrorEstructura
    MOV B, AL
    MOV CL, A
    JMP LeerParentesis

  
ErrorEstructura:
    MOV DX, OFFSET ERRORESTRUCURA
    MOV AH, 9H ; Función para mostrar un mensaje
    INT 21H ; Interrupción para mostrar el mensaje
    JMP programa ; Volver al inicio del programa

; Compara el simbolo para realizar la operación correspondiente
SUMATORIAJMP:
;Servira para imprimir 
MOV BX, 10
MOV CX, 0

;Revisar simbolos
CMP SIMBOLO, '+' ; Comparar con '+'
JE SUMA
CMP SIMBOLO, '-' ; Comparar con '-'
JE RESTA
CMP SIMBOLO, '*' ; Comparar con '*'
JE MULTIPLICACION
CMP SIMBOLO, '/' ; Comparar con '/'
JE DIVISION
JMP ErrorEstructura


SUMA: 
ADD I, B
; Hay que imprimimr el resultado de la suma que esta en AX porque podria ser de dos bytes
JMP PRINT
INC I 
LOOP SUMA
JMP FIN

RESTA:
SUB I, B
; Hay que imprimimr el resultado de la resta que esta en AL
INC I
LOOP RESTA
JMP FIN

MULTIPLICACION:
MOV AL, I
MUL B
; Hay que imprimimr el resultado de la multiplicacion que esta en AX porque podria ser de dos bytes
JMP CONVERTMUL
LOOPMULTIPLICACION:
MOV CL, A 
DEC A
INC I
LOOP MULTIPLICACION
JMP FIN

DIVISION:
MOV AL, I
DIV B
MOV I, AL

CONVERTMUL:
XOR DX, DX
DIV BX
PUSH DX
INC CX
CMP AX, 0
JNE CONVERTMUL

PRINT:  
POP DX
ADD DL, '0'
MOV AH, 2H
INT 21H
LOOP PRINT 
CMP SIMBOLO, '*' ; Comparar con '*'
JE LOOPMULTIPLICACION
CMP SIMBOLO, '/' ; Comparar con '/'
JE DIVISION



END programa
