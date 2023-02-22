PUBLIC output_STR
EXTRN STRING: byte
EXTRN I: byte

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG
output_STR proc near
	mov ax, seg STRING
	mov ds, ax
	
	xor bx, bx 
	mov bl, ds:I
	sub bl, '0'
	add bl, 1
	mov dl, [ds:STRING + bx]
	
	mov ah, 2
	int 21h
	ret
output_STR endp
CSEG ENDS
END