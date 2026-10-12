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
    mov eax, [n]
    mov edi, digits + 15
    mov byte [edi], 0
    dec edi
    mov ebx, 10
    test eax, eax
    jnz .split
    mov byte [edi], '0'
    dec edi
    jmp .done_split
.split:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .split
.done_split:
    inc edi
.print:
    mov al, [edi]
    test al, al
    jz .done
    mov [tmp_ch], al
    mov eax, 4
    mov ebx, 1
    mov ecx, tmp_ch
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, zero_ch
    mov edx, 1
    int 0x80
    inc edi
    jmp .print
.done:
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
segment readable writeable
inbuf   rb 16
n       dd 0
digits  rb 16
tmp_ch      db 0
zero_ch db '0'
nl      db 0x0A
