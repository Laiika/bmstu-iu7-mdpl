.686
.MODEL FLAT, C
.STACK

.CODE

mystrcpy PROC
    push ebp
	mov ebp, esp
	push edi
    push ebx
    push esi

	mov edi, [ebp + 8]    ; dst
	mov esi, [ebp + 12]   ; src
	mov ecx, [ebp + 16]   ; size

    mov ebx, edi          ; сохраняем dst, чтобы в конце вернуть его из функции
    
    ; проверка перекрытия строк
    cmp edi, esi
    jbe copy               ; dst <= src

    mov eax, edi
    sub eax, esi
    cmp eax, ecx
    ja copy                ; dst - src > size
    
    ; dst > src и dst - src < len => копирование с конца
    add edi, ecx
    dec edi
    add esi, ecx
    dec esi
    std             ; DF = 1

    copy:
        rep movsb
        cld             ; сброс флага направления DF
        mov eax, ebx    ; в eax возвращаемое значение (указатель dst)

    pop esi
    pop ebx
    pop edi
	pop ebp
    ret
mystrcpy ENDP
END