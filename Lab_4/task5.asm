format ELF executable 3
entry start
segment readable executable
start:
    mov eax, 3
    mov ebx, 0
    mov ecx, inbuf
    mov edx, 16
    int 0x80
    mov esi, inbuf
    call parse_int
    mov [n], eax
    xor ebx, ebx
    mov ecx, 1
.loop:
    cmp ecx, [n]
    jg .done
    mov eax, ecx
    xor edx, edx
    mov esi, 11
    div esi
    test edx, edx
    jz .skip
    mov eax, ecx
    xor edx, edx
    mov esi, 5
    div esi
    test edx, edx
    jz .skip
    inc ebx
.skip:
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
inbuf   rb 16
n       dd 0
buf     rb 16
nl      db 0x0A
