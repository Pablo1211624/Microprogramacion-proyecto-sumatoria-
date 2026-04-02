.model small
.386
.data
    A DB 1
    I DB 0
    I_VALOR DB 0
    B DB 0
    N DB 0
    SIMBOLO DB '+'
    TOTAL DW 0

    MSGMENU DB 13,10,'1.Ingresar funcion',13,10
            DB '2.Ingresar n',13,10
            DB '3.Ingresar i',13,10
            DB '4.Valuar',13,10
            DB '5.Salir',13,10,'$'

    MSGFUNC  DB 13,10,'Ingrese funcion: $'
    MSGN     DB 13,10,'Ingrese N: $'
    MSGI     DB 13,10,'Ingrese I inicial: $'
    SALTO    DB 13,10,'$'

.stack 100h
.code

programa:
    MOV AX,@data
    MOV DS,AX

MENU:
    MOV DX,OFFSET MSGMENU
    MOV AH,9
    INT 21H
    CALL LEER
    CMP AL,'1'
    JE FUNCION
    CMP AL,'2'
    JE LEERN
    CMP AL,'3'
    JE LEERI
    CMP AL,'4'
    JE SUMATORIA
    CMP AL,'5'
    JE FIN
    JMP MENU

LEER:
    MOV AH,08H
    INT 21H
    CMP AL,13
    JE LEER
    MOV DL,AL
    MOV AH,2
    INT 21H
    RET

FUNCION:
    MOV DX,OFFSET MSGFUNC
    MOV AH,9
    INT 21H
    CALL LEER
    CMP AL,'('
    JE ES_SIN_A
    SUB AL,'0'
    MOV A,AL
    CALL LEER ; Leer '('
ES_SIN_A:
    CALL LEER ; Leer 'i'
    CALL LEER ; Leer el operador (+, -, *, /, M)
    MOV SIMBOLO,AL
    
    CMP AL,'M'
    JNE SIGUE_B
    CALL LEER ; Leer 'O'
    CALL LEER ; Leer 'D'

SIGUE_B:
    CALL LEER ; Leer número B
    SUB AL,'0'
    MOV B,AL
    CALL LEER ; Leer ')'
    JMP MENU

LEERN:
    MOV DX,OFFSET MSGN
    MOV AH,9
    INT 21H
    CALL LEER
    SUB AL,'0'
    MOV N,AL
    JMP MENU

LEERI:
    MOV DX,OFFSET MSGI
    MOV AH,9
    INT 21H
    CALL LEER
    SUB AL,'0'
    MOV I_VALOR,AL
    JMP MENU

SUMATORIA:
    MOV AL, I_VALOR
    MOV I, AL
    MOV TOTAL, 0

CICLO:
    XOR AX, AX
    MOV AL, I
    MOV BL, B

    ; --- LÓGICA DE OPERACIONES ---
    CMP SIMBOLO, '+'
    JE HACE_SUMA
    CMP SIMBOLO, '-'
    JE HACE_RESTA
    CMP SIMBOLO, '*'
    JE HACE_MULT
    CMP SIMBOLO, '/'
    JE HACE_DIVI
    CMP SIMBOLO, 'M'
    JE HACE_MOD
    JMP CONTINUA

HACE_SUMA:
    ADD AL, BL
    JMP CONTINUA
HACE_RESTA:
    SUB AL, BL
    JMP CONTINUA
HACE_MULT:
    MUL BL
    JMP CONTINUA
HACE_DIVI:
    XOR AH, AH
    DIV BL
    JMP CONTINUA
HACE_MOD:
    XOR AH, AH
    DIV BL
    MOV AL, AH ; El residuo queda en AH, lo pasamos a AL para operar

CONTINUA:
    ; Aplicar el multiplicador A que está afuera del paréntesis
    XOR AH, AH
    MOV BL, A
    MUL BL
    
    MOV BX, AX
    ADD TOTAL, BX
    
    MOV AX, BX
    CALL IMPRIMIR

    MOV AL, I
    CMP AL, N
    JAE RESULTADO_FINAL

    MOV DL, '+'
    MOV AH, 2
    INT 21H

    INC I
    JMP CICLO

RESULTADO_FINAL:
    MOV DX, OFFSET SALTO
    MOV AH, 9
    INT 21H
    MOV AX, TOTAL
    CALL IMPRIMIR
    JMP MENU

IMPRIMIR:
    MOV BX, 10
    MOV CX, 0
DIVI_IMP:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    OR AX, AX
    JNZ DIVI_IMP
MUESTRA_IMP:
    POP DX
    ADD DL, '0'
    MOV AH, 2
    INT 21H
    LOOP MUESTRA_IMP
    RET

FIN:
    MOV AH, 4CH
    INT 21H
END programa