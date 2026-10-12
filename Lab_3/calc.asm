format ELF executable 3
entry start

segment readable executable
start:
    mov ebp, esp
    mov eax, [ebp]
    cmp eax, 4
    jne .usage

    mov esi, [ebp + 8]
    call parse_int
    mov [var_a], eax

    mov esi, [ebp + 12]
    call parse_int
    mov [var_b], eax

    mov esi, [ebp + 16]
    call parse_int
    mov [var_c], eax

    mov eax, [var_c]
    sub eax, [var_b]
    sub eax, [var_b]
    cdq
    mov ebx, [var_b]
    test ebx, ebx
    jz .div_zero
    idiv ebx

    call print_signed

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

.div_zero:
    mov eax, 4
    mov ebx, 1
    mov ecx, div_zero_msg
    mov edx, div_zero_len
    int 0x80
    mov eax, 1
    mov ebx, 2
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
    test dl, dl
    jz .done
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

print_signed:
    test eax, eax
    jns .positive
    push eax
    mov eax, 4
    mov ebx, 1
    mov ecx, minus
    mov edx, 1
    int 0x80
    pop eax
    neg eax
.positive:
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
var_a       dd 0
var_b       dd 0
var_c       dd 0
buf         rb 16
nl          db 0x0A
minus       db '-'
usage_msg   db 'Usage: ./calc a b c', 0x0A
usage_len   = $ - usage_msg
div_zero_msg db 'Error: division by zero', 0x0A
div_zero_len = $ - div_zero_msg
