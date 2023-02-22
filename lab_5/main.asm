STK SEGMENT PARA STACK 'STACK'
	db 200 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DSEG'
	msg_rows db 'Input number of rows: $'
    msg_cols db 'Input number of cols: $'
    msg_input db 'Enter matrix: $'
    msg_output db 'Result matrix: $'
	n db 0
	m db 0
	mtr db 81 dup(0)
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CSEG'
	assume cs:CSEG, ds:DSEG
	
read_digit:
	mov ah, 01h
	int 21h
	sub al, '0'
	cmp al, 0
	jl end_prog
	cmp al, 9
	jg end_prog
	ret
	
new_str:
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    ret
	
print_space:
    mov ah, 02h
    mov dl, ' '
    int 21h
    ret
	
chng_elem:
	mov mtr[bx][si], 0
	jmp metka
	
end_prog:
    mov ax, 4c00h
    int 21h
	
	
input_matrix:
	mov dx, offset msg_rows
	mov ah, 09h
	int 21h
	; ввод числа строк
	call read_digit
	cmp al, 0
	je end_prog
	mov n, al
	call new_str
	
	mov dx, offset msg_cols
	mov ah, 09h
	int 21h
	; ввод числа столбцов
	call read_digit
	cmp al, 0
	je end_prog
	mov m, al
	call new_str
		
	mov dx, offset msg_input
	mov ah, 09h
	int 21h
	call new_str
	; чтение матрицы
	xor cx, cx
	mov cl, n
	mov bx, 0
	
	read_mtr:
		mov di, cx
		mov cl, m 
		mov si, 0
		
		read_row:
			call read_digit
			mov mtr[bx][si], al
			inc si
		
			call print_space
			loop read_row
		
        call new_str
		
		mov cx, di
		add bx, 9
		
		loop read_mtr
		
	ret
		
		
proc_matrix:
	; обработка матрицы
	xor cx, cx
	mov cl, n
	mov bx, 0
	
	proc_mtr:
		mov di, cx
		mov cl, m 
		mov si, 0
		
		proc_row:
			mov al, mtr[bx][si]
			test al, 1

			jnz chng_elem
		
			metka:
		
			inc si
		
			loop proc_row
		
		mov cx, di
		add bx, 9
		
		loop proc_mtr
		
	ret

		
print_matrix:
	mov dx, offset msg_output
	mov ah, 09h
	int 21h
	call new_str
	; вывод матрицы
	xor cx, cx
	mov cl, n
	mov bx, 0
	
	print_mtr:
		mov di, cx
		mov cl, m 
		mov si, 0
		
		print_row:
			add mtr[bx][si], '0'
			mov dl, mtr[bx][si]
			mov ah, 2
			int 21h
		
			inc si
		
			call print_space
			loop print_row
			
		call new_str
		
		mov cx, di
		add bx, 9
		
		loop print_mtr
		
	ret
	
	
main:
	mov ax, DSEG
	mov ds, ax
	
	call input_matrix
	
	call proc_matrix
	
	call print_matrix
		
	jmp end_prog
	
CSEG ENDS
END main
		
		
		
	
	
		
		
		
		
		
		
		
		