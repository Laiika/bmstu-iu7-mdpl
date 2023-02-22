public num
public read_shex


DSEG SEGMENT PARA PUBLIC 'DSEG'
    in_msg db 'Input signed hexadecimal number (from -8000 to +7FFF): $'
    num dw 0
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CSEG'
    assume cs:CSEG, ds:DSEG
	
read_sign:
	mov ah, 1h
    int 21h
	
	mov si, 0
	
	cmp al, '-'
	je minus
	jmp plus
	
	minus:
	    mov si, 1
	plus:
	ret
	

read_shex proc near
    mov ah, 9h
    mov dx, offset in_msg
    int 21h
	
	call read_sign
    mov bx, 0
	
    read_symb:
        mov ah, 1h
        int 21h

        cmp al, 13 ; if enter
        je end_input
		
		cmp al, '9'
		ja proc_letter
		
		sub al, '0'
		jmp add_digit
		
		proc_letter:
			sub al, 'A'
			add al, 10
			
		add_digit:
		mov cl, 4
        shl bx, cl
        add bl, al
		
        jmp read_symb


    end_input:
		cmp si, 1
		je reverse
		jmp skip
		
		reverse:
		    neg bx
		skip:
        mov num, bx
		
    ret
read_shex endp

CSEG ENDS
END