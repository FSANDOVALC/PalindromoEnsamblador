;Memoria de Datos
ORG 1000H
TAMANO EQU 30 ;Tamanho de caracteres con los que funciona el programa
txt_inicio DB "Programa para reconocer palindromos -> ingrese un texto de maximo 30 caracteres sin espacios; digite enter para terminar:" ;Text mostrado a usuario que indica limitacion del algoritmo
NUM1 DB 00H
msjnopalin DB "no es palindromo" ;Texto mostrado cuando el texto ingresado no es un palindromo
finmsjnopalin DB 00H ;Variable de referencia de fin mensaje no es palindromo
msjpalin DB "si es palindromo" ;Texto mostrado cuando el texto ingresado si es un palindromo
finmsjpalin DB 00H ;Variable de referencia de fin mensaje si es palindromo
MSJ DB TAMANO DUP(0) ;Texto ingresado para reconocer si es palindromo
FIN DB 01H ;Variable de referencia de fin texto ingresado
MSJREV DB TAMANO DUP(0) ;Texto escrito al contrario, es decir de derecha a izquierda
;Memoria de instrucciones
ORG 3000H ;Subrutinas
OBTLAZO: MOV BX, AX ;Subrutina para obtener cadena de texto ingresado por el usuario -> Mueve a BX direccion inicial de txt_ingresado
INT 6 ;Interrupcion 6 para reconocer el caracter ingresado
MOV DL, [BX] ;Mueve el caracter leido a dl
CMP WORD PTR[BX], 0DH ;Comparador para validar si usuario tecleo enter
JZ OBTFIN ;Si el comparador da 0, deja de solicitar caracteres al usuario y sale del ciclo
INC AX ;Incrementa direccion para escribir el siguiente caracter
CALL OBTLAZO ;Llama a la etiqueta OBTLAZO para obtener otro caracter ingresado
OBTFIN: MOV WORD PTR[BX], 00H ;Mueve a la ultima direccion donde se escribio ODH el valor 00H para obviar el enter
RET ;Termina la subrutina OBTLAZO
IMPTEXT_INGRESADO: MOV BX, OFFSET MSJ
MOV AL, OFFSET FIN - OFFSET MSJ ;Imprime texto ingresado
INT 7
ORG_DATOS: MOV BX, OFFSET FIN-01H ;Escribir el valor de la ultima direccion en CL  Ex: [1007] -> BX
MOV CL, [BX] ;Objeto apuntado por [BX], se coloca en CL -> 61
MOV AX, OFFSET MSJREV ;Se coloca en AX la direccion inicial de MSJREV -> Ex: 1005
MOV DX, OFFSET FIN-OFFSET MSJ ;Se coloca en DX ->  Ex: 30 (cantidad de caracteres) que va a ser utilizado como contador
CMP CL,00H ;Comparo si el valor en CL es cero para no colocarlo
JZ FIN_ORG_DATOS ;Llamada a finalizar la subrutina ORG_DATOS
MOV MSJREV, CL ;Se coloca al inicio de MSJREV el ultimo valor ASCII de la cadena ingresada
FIN_ORG_DATOS: RET ;Fin de la Subrutina ORG_DATOS
REV_PALABRA: DEC BX ;Inicio rutina revertir palabra -> Decremento direccion de cadena 1
MOV CL, [BX] ;Objeto apuntado por [BX], se coloca en CL
CMP CL, 00H ;Comparador para validar si el objeto en memoria es 00H
JZ SALTAR_INCAX ;Saltar el aumento de dir AX cuando el objeto en memoria es 00H
PUSH BX ;Push de BX para luego tenerlo como referencia para BX
MOV BX, AX ;Muevo a BX -> AX
MOV [BX],CL ;Se mueve el valor de CL -> 62 a la direccion 1006
POP BX ;Muevo a sobreescribir BX con el ultimo valor ingresado en la pila
INC AX ;Incremento de direccion de AX
JMP DEC_CONT ;Decremento el contador
SALTAR_INCAX: MOV CL,[BX] ;Se salta los pasos ejecutados anteriormente, en caso de que el objeto en memoria es 00H
DEC_CONT: DEC DL ;Se decrementa DL en una unidad
JNZ REV_PALABRA ;Flag cuando el contador sea igual a cero
RET ;Fin rutina revertir palabra
OBT_DIRS_Y_CONT: MOV AX, OFFSET MSJ ;Subrutina para obtener direcciones iniciales y contador -> Mueve a AX  la direccion inicial de MSJ
MOV BX, OFFSET MSJREV ;Mueve a BX la direccion inicial de MSJREV
MOV DX, OFFSET FIN-OFFSET MSJ ;Contador utilizado en ciclo
RET ;Fin de subrutina OBT_DIRS_Y_CONT
PALINDROMO: MOV CL, [BX] ;Subrutina para comparar cadenas de texto y validar si es palindromo
PUSH BX ;Se coloca en la pila la direccion 1005
MOV BX, AX ;Mueve a BX, AX
MOV CH, [BX] ;Mueve a CH el objeto apuntado por BX
POP BX ;Mueve a BX el ultimo dato en la pila
MOV NUM1, CL ;Mueve a NUM1 el dato de CL
SUB NUM1, CH ;Resto NUM1-CH
JNZ FINNOPALIN ;Si la resta no da cero, el texto no es palindromo
INC AX ;Incremente de direccion
INC BX ;Incremente de direccion
DEC DL ;Se decrementa el contador
JNZ PALINDROMO ;Si el contador llega a cero y no se activo el flag the JNZ FINNOPALIN, el texto es palindromo
CALL FINPALIN ;Imprime mensaje de que texto es palindromo
RET
FINNOPALIN: MOV BX, OFFSET msjnopalin ;Imprime mensaje que texto no es palindromo
MOV AL, OFFSET finmsjnopalin - OFFSET msjnopalin
INT 7
INT 0
RET
FINPALIN: MOV BX, OFFSET msjpalin ;Imprime mensaje que texto si es palindromo
MOV AL, OFFSET finmsjpalin - OFFSET msjpalin
INT 7
INT 0
RET
ORG 2000H ;Programa principal
MOV BX, OFFSET txt_inicio	; mueve a BX la direccion del txt_inicio
MOV AL, OFFSET NUM1 - OFFSET txt_inicio	; mueve a AL el tamano del txt_inicio para indicarle a la interrupcion 7 cuantos caracteres debe mostrar en pantalla
INT 7	; ejecuta la interrupcion 7 para mostrar el mensaje en pantalla
MOV AX, OFFSET MSJ
CALL OBTLAZO
CALL IMPTEXT_INGRESADO
CALL ORG_DATOS
CALL REV_PALABRA
CALL OBT_DIRS_Y_CONT
CALL PALINDROMO
HLT
END
