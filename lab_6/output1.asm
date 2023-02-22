public convert_ubin
extrn num: word


DSEG SEGMENT PARA PUBLIC 'DSEG'
    out_msg db 'Converted number: $'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CSEG'
    assume cs:CSEG, ds:DSEG

print_ubin:
	mov ah, 2h
	mov bx, num
    mov cx, 16

    print_loop: 
        mov si, cx
		mov cl, 1
		
		mov dl, '0'
		sal bx, cl
		jc print_1
		jmp print
		
		print_1:
		    mov dl, '1'
		print:
        int 21h
		
		mov cx, si
        loop print_loop

    ret

convert_ubin proc near
    mov dx, offset out_msg
    mov ah, 9h
    int 21h

    call print_ubin

    ret
convert_ubin endp

CSEG ENDS
END