PUBLIC I
PUBLIC STRING
EXTRN output_STR: near

STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	I db ?
	STRING db 30                   
           db ?                     
           db 30 dup("$")
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG
new_line:      
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h  
    ret
main:
	mov ax, DSEG
	mov ds, ax
	mov dx, offset STRING
	
	mov ah, 0Ah ; чтение строки
	int 21h
	call new_line
	
	mov ah, 01h ; чтение цифры
	int 21h
	mov I, al
	call new_line
	
	call output_STR	
	
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main