.MODEL TINY

CSEG SEGMENT
    assume cs:CSEG
    org 100h
main:
    jmp init
	
	old_1ch dd 0
    is_init db 1
    speed   db 1Fh ; нач. скорость автоповтора ввода
    time    db 0

my_1ch proc near
    push ax
	push dx

    mov ah, 02h ; текущее время: секунды - в dh
    int 1Ah

    cmp dh, time
    je skip ; если время не изменилось, то скорость не меняется

    mov time, dh
	dec speed
	
	mov al, 0F3h
	out 60h, al
	mov al, speed
	out 60h, al ; устанавливаю скорость автоповтора ввода
	
	cmp speed, 0
    jnz skip
    
    mov speed, 1Fh

	skip:
		pop dx
		pop ax
		jmp cs:old_1ch ; вызываю старый обработчик прерывания таймера
my_1ch endp

init:
    mov ax, 351Ch
    int 21h ; адрес обработчика прерывания таймера теперь в es:bx

    cmp es:is_init, 1 
    je uninstall

    mov word ptr old_1ch, bx
    mov word ptr old_1ch + 2, es

    mov ax, 251Ch
    mov dx, offset my_1ch
    int 21h ; меняю вектор 1ch в таблице векторов прерываний на свой

    mov dx, offset init_msg
    mov ah, 9h
    int 21h

    mov dx, offset init
    int 27h ; завершение программу - всё, начиная с init, будет освобождено из памяти

uninstall:
    mov dx, offset end_msg
    mov ah, 9h
    int 21h

    ; возвращаю скорость по умолчанию
    mov al, 0F3h
    out 60h, al
    mov al, 0
    out 60h, al
    
	; установка старого вектора прерывания
    mov dx, word ptr es:old_1ch                      
    mov ds, word ptr es:old_1ch + 2
    mov ax, 251ch
    int 21h

    mov ah, 49h
    int 21h

    mov ax, 4c00h
    int 21h
	
    init_msg db 'Start', '$'
    end_msg db 'Exit', '$'
    
CSEG ENDS
END main