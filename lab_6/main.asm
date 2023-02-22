extrn read_shex: near
extrn convert_ubin: near
extrn convert_sdec: near


STK SEGMENT PARA STACK 'STACK'
    db 200 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DSEG'
    menu db 'Available actions:', 13, 10
        db '1. Input signed hexadecimal number', 13, 10
        db '2. Convert to unsigned binary', 13, 10
        db '3. Convert to signed decimal', 13, 10
        db '4. Exit', 13, 10
        db 'Choose action: $'
    menu_arr dw read_shex, convert_ubin, convert_sdec, exit
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CSEG'
    assume cs:CSEG, ds:DSEG, ss:STK

print_menu:
    mov ah, 9h
    mov dx, offset menu
    int 21h
    ret

input_action:
    mov ah, 1h
    int 21h
    sub al, '1'
    mov dl, 2
    mul dl 
    ret
	
new_str:
    mov ah, 2
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    ret

exit proc near
    mov ax, 4c00h
    int 21h
exit endp

main:
    mov ax, DSEG
    mov ds, ax

    menu_loop:
        call print_menu
		call input_action
		mov bx, ax
		
        call new_str
        call menu_arr[bx]
		call new_str
        jmp menu_loop

CSEG ENDS
END main