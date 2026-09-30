format ELF executable 3
entry start

segment readable executable
start:
    mov esi, src + 35
    mov edi, buf
    mov ebx, 36
copy_loop:
    mov al, [esi]
    mov [edi], al
    dec esi
    inc edi
    dec ebx
    jnz copy_loop

    mov eax, 4
    mov ebx, 1
    mov ecx, buf
    mov edx, 36
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

segment readable writeable
src     db 'QMzbakBZZOJsiwfnCQdUMxGKXmoProNjpZOP'
newline db 0x0A
        rb 256
buf     rb 36
