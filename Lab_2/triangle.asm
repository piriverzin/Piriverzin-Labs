format ELF executable 3
entry start

segment readable executable
start:
    mov edi, 1
outer_loop:
    mov ecx, edi
inner_loop:
    push ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, pipe
    mov edx, 1
    int 0x80
    pop ecx
    loop inner_loop

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    inc edi
    cmp edi, 10
    jne outer_loop

    mov eax, 1
    xor ebx, ebx
    int 0x80

segment readable writeable
pipe    db '|'
newline db 0x0A
