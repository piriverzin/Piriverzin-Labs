format ELF executable 3
entry start

segment readable executable
start:
    mov ebp, esp
    mov eax, [ebp]
    cmp eax, 2
    jl .usage

    mov esi, [ebp + 8]
    movzx eax, byte [esi]
    test eax, eax
    jz .usage

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
buf         rb 16
nl          db 0x0A
usage_msg   db 'Usage: ./ascii <char>', 0x0A
usage_len   = $ - usage_msg
