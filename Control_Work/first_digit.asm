format ELF executable 3
entry start

segment readable executable
start:
    mov ebp, esp
    mov eax, [ebp]
    cmp eax, 2
    jne .usage

    mov esi, [ebp + 8]
    call parse_int
    mov [n], eax

    xor ebx, ebx            ; сумма
    mov ecx, 1              ; k
.loop:
    cmp ecx, [n]
    jg .done
    push ebx                ; сохраняем сумму
    push ecx                ; сохраняем счётчик
    mov eax, ecx
    call first_digit
    pop ecx                 ; восстанавливаем
    pop ebx
    mov edx, ecx
    imul edx, eax
    add ebx, edx
    inc ecx
    jmp .loop
.done:
    mov eax, ebx
    call print_num
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80
    mov eax, 1
    xor ebx, ebx
    int 0x80

.usage:
    mov eax, 4
    mov ebx, 1
    mov ecx, usage_msg
    mov edx, usage_len
    int 0x80
    mov eax, 1
    mov ebx, 1
    int 0x80

first_digit:
    mov ebx, 10
.fd_loop:
    cmp eax, 10
    jl .fd_done
    xor edx, edx
    div ebx
    jmp .fd_loop
.fd_done:
    ret

parse_int:
    xor eax, eax
    xor ecx, ecx
    movzx edx, byte [esi]
    cmp dl, '-'
    jne .loop
    mov ecx, 1
    inc esi
.loop:
    movzx edx, byte [esi]
    cmp dl, '0'
    jb .done
    cmp dl, '9'
    ja .done
    imul eax, eax, 10
    sub dl, '0'
    movzx edx, dl
    add eax, edx
    inc esi
    jmp .loop
.done:
    test ecx, ecx
    jz .ret
    neg eax
.ret:
    ret

print_num:
    mov edi, buf + 15
    mov ebx, 10
.cnv:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .cnv
    inc edi
    mov edx, buf + 15
    sub edx, edi
    inc edx
    mov ecx, edi
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret

segment readable writeable
n           dd 0
buf         rb 16
nl          db 0x0A
usage_msg   db 'Usage: ./first_digit n', 0x0A
usage_len   = $ - usage_msg
