public convert_sdec
extrn num: word


DSEG SEGMENT PARA PUBLIC 'DSEG'
    out_msg2 db 'Converted number: $'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CSEG'
    assume cs:CSEG, ds:DSEG

to_sdec:
	mov bx, num
    cmp bx, 7FFFh                          
    jna skip_sign

    mov dl, '-'
    mov ah, 2h
    int 21h

    neg bx

    skip_sign:

	mov ax, bx
	mov bx, 10
    mov cx, 0               ;количество выводимых цифр
	div10:
		xor dx, dx
        div bx              ;делим AX на 10(основание системы счисления)
        add dl, '0'

        push dx                 ;и сохраняем его в стеке
        inc cx                  ;увеличиваем счётчик цифр
        test ax, ax            
        jnz div10   
	  
	cmp cx, 0
	jnz end_conv
	
	mov dx, '0'
	push dx
	inc cx
	
	end_conv:
	mov ah, 2
	
    print_loop: 
		pop dx              ;извлекаем из стека очередную цифру
        int 21h
        loop print_loop
	
    ret

convert_sdec proc near
    mov dx, offset out_msg2
    mov ah, 9
    int 21h

    call to_sdec

    ret
convert_sdec endp

CSEG ENDS
END