format ELF executable 3
entry start

segment readable executable
start:
    mov ecx, 45
    xor esi, esi            ; счётчик в строке — в esi (int 0x80 его не трогает)
print_matrix:
    push ecx
    push esi
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe
    mov edx, 1
    int 0x80
    pop esi
    pop ecx

    inc esi
    cmp esi, 5
    jne skip_nl

    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    pop ecx
    xor esi, esi

skip_nl:
    loop print_matrix

    mov eax, 1
    xor ebx, ebx
    int 0x80

segment readable writeable
pipe    db '|'
newline db 0x0A
